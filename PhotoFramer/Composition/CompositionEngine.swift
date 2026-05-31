import CoreGraphics
import CoreMedia
import CoreVideo
import Foundation

enum CompositionEngine {
    static func evaluate(
        rollDegrees: Double,
        pitchDegrees: Double,
        personRect: CGRect?,
        upperThirdLuma: Double,
        upperThirdVariance: Double
    ) -> CompositionState {
        var flags = CompositionFlags()
        var subscores: [Double] = []

        let levelScore = scoreLevel(rollDegrees: rollDegrees, flags: &flags)
        subscores.append(levelScore * CompositionRules.weightLevel)

        let pitchScore = scorePitch(pitchDegrees: pitchDegrees, flags: &flags)
        subscores.append(pitchScore * CompositionRules.weightPitch)

        let skyScore = scoreSky(luma: upperThirdLuma, variance: upperThirdVariance, pitch: pitchDegrees, flags: &flags)
        subscores.append(skyScore * CompositionRules.weightSky)

        var idealPoint: CGPoint?
        var showMarker = false

        if let rect = personRect {
            showMarker = true
            idealPoint = idealPlacement(for: rect)

            let edgeScore = scoreEdges(rect: rect, flags: &flags)
            subscores.append(edgeScore * CompositionRules.weightEdge)

            let thirdsScore = scoreThirds(rect: rect, ideal: idealPoint!, flags: &flags)
            subscores.append(thirdsScore * CompositionRules.weightThirds)

            let clipScore = scoreClipping(rect: rect, flags: &flags)
            subscores.append(clipScore * CompositionRules.weightClip)

            scoreSubjectSize(rect: rect, flags: &flags)
            scoreHorizontalPlacement(rect: rect, ideal: idealPoint!, flags: &flags)
            scoreCentering(rect: rect, flags: &flags)
        } else {
            subscores.append(CompositionRules.weightEdge)
            subscores.append(CompositionRules.weightThirds)
            subscores.append(CompositionRules.weightClip)
        }

        let totalWeight = CompositionRules.weightLevel + CompositionRules.weightPitch +
            CompositionRules.weightSky + CompositionRules.weightEdge +
            CompositionRules.weightThirds + CompositionRules.weightClip
        let raw = subscores.reduce(0, +) / totalWeight
        let score = Int((raw * 100).rounded().clamped(to: 0...100))

        let isLevel = abs(rollDegrees) < CompositionRules.levelRollThreshold
        let suggestion = SuggestionEngine.suggestion(from: flags, score: score, isLevel: isLevel)

        return CompositionState(
            score: score,
            suggestion: suggestion,
            isFrameGood: suggestion == .frameIsGood,
            rollDegrees: rollDegrees,
            pitchDegrees: pitchDegrees,
            isLevel: isLevel,
            personRect: personRect,
            idealSubjectPoint: idealPoint,
            showSubjectMarker: showMarker,
            upperThirdLuma: upperThirdLuma,
            upperThirdVariance: upperThirdVariance,
            flags: flags
        )
    }

    static func analyzeUpperThirdLuma(from sampleBuffer: CMSampleBuffer) -> (luma: Double, variance: Double) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return (0, 0)
        }

        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly) }

        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        let topHeight = height / 3

        guard
            let base = CVPixelBufferGetBaseAddress(pixelBuffer),
            width > 0, topHeight > 0
        else { return (0, 0) }

        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let buffer = base.assumingMemoryBound(to: UInt8.self)

        var sum: Double = 0
        var sumSq: Double = 0
        var count: Double = 0
        let step = 8

        for y in stride(from: 0, to: topHeight, by: step) {
            for x in stride(from: 0, to: width, by: step) {
                let offset = y * bytesPerRow + x * 4
                let b = Double(buffer[offset])
                let g = Double(buffer[offset + 1])
                let r = Double(buffer[offset + 2])
                let luma = (0.299 * r + 0.587 * g + 0.114 * b) / 255.0
                sum += luma
                sumSq += luma * luma
                count += 1
            }
        }

        guard count > 0 else { return (0, 0) }
        let mean = sum / count
        let variance = max(0, (sumSq / count) - (mean * mean))
        return (mean, variance)
    }

    private static func scoreLevel(rollDegrees: Double, flags: inout CompositionFlags) -> Double {
        let absRoll = abs(rollDegrees)
        flags.needsLevel = absRoll > CompositionRules.levelRollFail
        if absRoll < CompositionRules.levelRollThreshold { return 1 }
        if absRoll < CompositionRules.levelRollFail { return 0.6 }
        return max(0, 1 - absRoll / 20)
    }

    private static func scorePitch(pitchDegrees: Double, flags: inout CompositionFlags) -> Double {
        flags.needsRaiseCamera = pitchDegrees < CompositionRules.pitchRaiseThreshold
        flags.needsLowerCamera = pitchDegrees > CompositionRules.pitchLowerThreshold

        if pitchDegrees >= CompositionRules.pitchMin && pitchDegrees <= CompositionRules.pitchMax {
            return 1
        }
        let distance = pitchDegrees < CompositionRules.pitchMin
            ? CompositionRules.pitchMin - pitchDegrees
            : pitchDegrees - CompositionRules.pitchMax
        return max(0, 1 - distance / 20)
    }

    private static func scoreSky(luma: Double, variance: Double, pitch: Double, flags: inout CompositionFlags) -> Double {
        let brightFlat = luma > CompositionRules.skyLumaThreshold && variance < CompositionRules.skyVarianceThreshold
        let lookingUp = pitch < CompositionRules.pitchRaiseThreshold
        flags.tooMuchSky = brightFlat || (luma > 0.65 && lookingUp)
        return flags.tooMuchSky ? 0.35 : 1
    }

    private static func scoreEdges(rect: CGRect, flags: inout CompositionFlags) -> Double {
        let minX = rect.minX
        let minY = rect.minY
        let maxX = rect.maxX
        let maxY = rect.maxY

        flags.subjectTooCloseToEdge = minX < CompositionRules.edgeCritical ||
            minY < CompositionRules.edgeCritical ||
            (1 - maxX) < CompositionRules.edgeCritical ||
            (1 - maxY) < CompositionRules.edgeCritical

        let ok = minX >= CompositionRules.edgeMargin &&
            minY >= CompositionRules.edgeMargin &&
            (1 - maxX) >= CompositionRules.edgeMargin &&
            (1 - maxY) >= CompositionRules.edgeMargin
        return ok ? 1 : (flags.subjectTooCloseToEdge ? 0.2 : 0.55)
    }

    private static func scoreThirds(rect: CGRect, ideal: CGPoint, flags: inout CompositionFlags) -> Double {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let nearest = CompositionRules.thirdIntersections.min {
            hypot(center.x - $0.x, center.y - $0.y) < hypot(center.x - $1.x, center.y - $1.y)
        } ?? ideal

        let distance = hypot(center.x - nearest.x, center.y - nearest.y)
        return distance < CompositionRules.thirdsTolerance ? 1 : max(0.3, 1 - distance * 3)
    }

    private static func scoreClipping(rect: CGRect, flags: inout CompositionFlags) -> Double {
        flags.headBodyCutOff = rect.minY < CompositionRules.clipMargin ||
            (1 - rect.maxY) < CompositionRules.clipMargin
        return flags.headBodyCutOff ? 0.25 : 1
    }

    private static func scoreSubjectSize(rect: CGRect, flags: inout CompositionFlags) {
        let area = rect.width * rect.height
        flags.needsGetCloser = area > CompositionRules.subjectTooLargeArea
        flags.needsStepBack = area < CompositionRules.subjectTooSmallArea
    }

    private static func scoreHorizontalPlacement(rect: CGRect, ideal: CGPoint, flags: inout CompositionFlags) {
        let dx = rect.midX - ideal.x
        if abs(dx) < 0.06 { return }
        flags.needsMoveLeft = dx > 0
        flags.needsMoveRight = dx < 0
    }

    private static func scoreCentering(rect: CGRect, flags: inout CompositionFlags) {
        let cx = abs(rect.midX - 0.5)
        let cy = abs(rect.midY - 0.5)
        flags.subjectTooCentered = cx < CompositionRules.centerTolerance &&
            cy < CompositionRules.centerTolerance
    }

    private static func idealPlacement(for rect: CGRect) -> CGPoint {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let candidates = [CompositionRules.preferredPortraitThird] + CompositionRules.thirdIntersections
        return candidates.min {
            hypot(center.x - $0.x, center.y - $0.y) < hypot(center.x - $1.x, center.y - $1.y)
        } ?? CompositionRules.preferredPortraitThird
    }
}

private extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
