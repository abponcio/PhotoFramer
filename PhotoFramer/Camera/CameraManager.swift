import AVFoundation
import Combine
import CoreMedia
import UIKit

protocol CameraFrameDelegate: AnyObject {
    func cameraManager(_ manager: CameraManager, didOutput sampleBuffer: CMSampleBuffer)
}

@MainActor
final class CameraManager: NSObject, ObservableObject {
    @Published private(set) var isRunning = false
    @Published private(set) var lastThumbnail: UIImage?
    @Published var captureFlash = false

    weak var frameDelegate: CameraFrameDelegate?

    let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "com.photoframer.camera.session")
    private let videoOutputQueue = DispatchQueue(label: "com.photoframer.camera.video")

    private var videoInput: AVCaptureDeviceInput?
    private let videoOutput = AVCaptureVideoDataOutput()
    private let photoOutput = AVCapturePhotoOutput()

    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var activePhotoDelegate: PhotoCaptureDelegate?

    override init() {
        super.init()
    }

    func configure() {
        sessionQueue.async { [weak self] in
            self?.configureSession()
        }
    }

    func attachPreview(to view: CameraPreviewUIView) {
        let layer = view.previewLayer
        layer.session = session
        layer.videoGravity = .resizeAspectFill
        if let connection = layer.connection, connection.isVideoRotationAngleSupported(90) {
            connection.videoRotationAngle = 90
        }
        previewLayer = layer
    }

    func start() {
        sessionQueue.async { [weak self] in
            guard let self, !self.session.isRunning else { return }
            self.session.startRunning()
            Task { @MainActor in
                self.isRunning = true
            }
        }
    }

    func stop() {
        sessionQueue.async { [weak self] in
            guard let self, self.session.isRunning else { return }
            self.session.stopRunning()
            Task { @MainActor in
                self.isRunning = false
            }
        }
    }

    func capturePhoto(completion: @escaping (Result<UIImage, Error>) -> Void) {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto

        let delegate = PhotoCaptureDelegate { [weak self] result in
            Task { @MainActor in
                self?.activePhotoDelegate = nil
            }
            if case .success(let image) = result {
                Task { @MainActor in
                    self?.lastThumbnail = image
                    self?.captureFlash = true
                    try? await Task.sleep(nanoseconds: 150_000_000)
                    self?.captureFlash = false
                }
            }
            completion(result)
        }
        activePhotoDelegate = delegate
        photoOutput.capturePhoto(with: settings, delegate: delegate)
    }

    private func configureSession() {
        session.beginConfiguration()
        session.sessionPreset = .high

        session.inputs.forEach { session.removeInput($0) }
        session.outputs.forEach { session.removeOutput($0) }

        guard
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
            let input = try? AVCaptureDeviceInput(device: device),
            session.canAddInput(input)
        else {
            session.commitConfiguration()
            return
        }

        session.addInput(input)
        videoInput = input

        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.setSampleBufferDelegate(self, queue: videoOutputQueue)
        videoOutput.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
        ]

        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
            if let connection = videoOutput.connection(with: .video), connection.isVideoRotationAngleSupported(90) {
                connection.videoRotationAngle = 90
            }
        }

        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }

        session.commitConfiguration()
    }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    nonisolated func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        Task { @MainActor in
            frameDelegate?.cameraManager(self, didOutput: sampleBuffer)
        }
    }
}

private final class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    private let completion: (Result<UIImage, Error>) -> Void

    init(completion: @escaping (Result<UIImage, Error>) -> Void) {
        self.completion = completion
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error {
            completion(.failure(error))
            return
        }
        guard let data = photo.fileDataRepresentation(), let image = UIImage(data: data) else {
            completion(.failure(NSError(domain: "PhotoFramer", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid photo data"])))
            return
        }
        completion(.success(image))
    }
}
