import CoreGraphics
import CoreMedia
import Vision

final class PersonDetector {
    private let request = VNDetectHumanRectanglesRequest()
    private var lastProcessTime: CFTimeInterval = 0
    private var lastRect: CGRect?
    private let minInterval: CFTimeInterval = 0.125

    func detect(in sampleBuffer: CMSampleBuffer) -> CGRect? {
        let now = CACurrentMediaTime()
        guard now - lastProcessTime >= minInterval else { return lastRect }
        lastProcessTime = now

        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: [:])
        do {
            try handler.perform([request])
        } catch {
            return nil
        }

        guard let observations = request.results, !observations.isEmpty else {
            lastRect = nil
            return nil
        }

        let largest = observations.max { a, b in
            a.boundingBox.width * a.boundingBox.height < b.boundingBox.width * b.boundingBox.height
        }

        guard let box = largest?.boundingBox else {
            lastRect = nil
            return nil
        }

        // Vision uses bottom-left origin; convert to top-left normalized.
        let rect = CGRect(
            x: box.origin.x,
            y: 1 - box.origin.y - box.height,
            width: box.width,
            height: box.height
        )
        lastRect = rect
        return rect
    }
}
