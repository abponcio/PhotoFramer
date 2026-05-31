import CoreGraphics
import Foundation

enum CompositionRules {
    static let levelRollThreshold: Double = 2
    static let levelRollFail: Double = 4
    static let pitchMin: Double = -12
    static let pitchMax: Double = 8
    static let pitchRaiseThreshold: Double = -15
    static let pitchLowerThreshold: Double = 10

    static let edgeMargin: CGFloat = 0.08
    static let edgeCritical: CGFloat = 0.05
    static let clipMargin: CGFloat = 0.02
    static let thirdsTolerance: CGFloat = 0.12
    static let centerTolerance: CGFloat = 0.08

    static let subjectTooLargeArea: CGFloat = 0.45
    static let subjectTooSmallArea: CGFloat = 0.12

    static let skyLumaThreshold: Double = 0.72
    static let skyVarianceThreshold: Double = 0.02

    static let goodScoreThreshold: Int = 80
    static let adjustScoreThreshold: Int = 40

    static let weightLevel: Double = 0.25
    static let weightPitch: Double = 0.15
    static let weightEdge: Double = 0.20
    static let weightThirds: Double = 0.20
    static let weightClip: Double = 0.10
    static let weightSky: Double = 0.10

    static let thirdIntersections: [CGPoint] = [
        CGPoint(x: 1.0 / 3.0, y: 1.0 / 3.0),
        CGPoint(x: 2.0 / 3.0, y: 1.0 / 3.0),
        CGPoint(x: 1.0 / 3.0, y: 2.0 / 3.0),
        CGPoint(x: 2.0 / 3.0, y: 2.0 / 3.0)
    ]

    static let preferredPortraitThird = CGPoint(x: 1.0 / 3.0, y: 2.0 / 3.0)

    static func scoreColor(for score: Int, isLevel: Bool) -> ScoreColor {
        if score >= goodScoreThreshold && isLevel { return .good }
        if score >= adjustScoreThreshold { return .adjust }
        return .critical
    }

    enum ScoreColor {
        case good, adjust, critical
    }
}
