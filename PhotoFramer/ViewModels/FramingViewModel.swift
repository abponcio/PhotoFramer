import Combine
import CoreMedia
import SwiftUI
import UIKit

@MainActor
final class FramingViewModel: ObservableObject, CameraFrameDelegate {
    @Published var composition = CompositionState()
    @Published var showGrid = true
    @Published var showSaveToast = false
    @Published var showCameraOpenFailed = false
    @Published var saveErrorMessage: String?

    let cameraManager = CameraManager()
    let levelDetector = LevelDetector()
    private let personDetector = PersonDetector()
    private var lastPersonRect: CGRect?
    private var lastLuma: (Double, Double) = (0, 0)
    private var didTriggerGoodHaptic = false

    private let goodHaptic = UIImpactFeedbackGenerator(style: .medium)

    init() {
        cameraManager.frameDelegate = self
    }

    func onAppearAuthorized() {
        cameraManager.configure()
        cameraManager.start()
        levelDetector.start()
        goodHaptic.prepare()
    }

    func onDisappear() {
        cameraManager.stop()
        levelDetector.stop()
    }

    func cameraManager(_ manager: CameraManager, didOutput sampleBuffer: CMSampleBuffer) {
        lastPersonRect = personDetector.detect(in: sampleBuffer)
        lastLuma = CompositionEngine.analyzeUpperThirdLuma(from: sampleBuffer)
        refreshComposition()
    }

    func refreshComposition() {
        let state = CompositionEngine.evaluate(
            rollDegrees: levelDetector.rollDegrees,
            pitchDegrees: levelDetector.pitchDegrees,
            personRect: lastPersonRect,
            upperThirdLuma: lastLuma.0,
            upperThirdVariance: lastLuma.1
        )
        composition = state

        if state.isFrameGood && !didTriggerGoodHaptic {
            goodHaptic.impactOccurred()
            didTriggerGoodHaptic = true
        } else if !state.isFrameGood {
            didTriggerGoodHaptic = false
        }
    }

    func openNativeCamera() async {
        let opened = await NativeCameraLauncher.openCamera()
        if !opened {
            showCameraOpenFailed = true
        }
    }

    func captureInApp() {
        cameraManager.capturePhoto { [weak self] result in
            Task { @MainActor in
                guard let self else { return }
                switch result {
                case .success(let image):
                    do {
                        try await PhotoCaptureService.saveToPhotoLibrary(image)
                        self.showSaveToast = true
                    } catch {
                        self.saveErrorMessage = error.localizedDescription
                    }
                case .failure(let error):
                    self.saveErrorMessage = error.localizedDescription
                }
            }
        }
    }
}
