import CoreGraphics
import Foundation

struct CompositionState: Equatable {
    var score: Int = 0
    var suggestion: FramingSuggestion = .levelPhone
    var isFrameGood: Bool = false

    var rollDegrees: Double = 0
    var pitchDegrees: Double = 0
    var isLevel: Bool = false

    var personRect: CGRect?
    var idealSubjectPoint: CGPoint?
    var showSubjectMarker: Bool = false

    var upperThirdLuma: Double = 0
    var upperThirdVariance: Double = 0

    var flags: CompositionFlags = CompositionFlags()
}

struct CompositionFlags: Equatable {
    var needsLevel: Bool = true
    var needsRaiseCamera: Bool = false
    var needsLowerCamera: Bool = false
    var tooMuchSky: Bool = false
    var headBodyCutOff: Bool = false
    var subjectTooCloseToEdge: Bool = false
    var needsStepBack: Bool = false
    var needsGetCloser: Bool = false
    var needsMoveLeft: Bool = false
    var needsMoveRight: Bool = false
    var subjectTooCentered: Bool = false
}
