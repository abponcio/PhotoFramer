import Foundation

enum FramingSuggestion: String, CaseIterable, Identifiable {
    case levelPhone = "Level the phone"
    case raiseCamera = "Raise camera"
    case lowerCamera = "Lower camera"
    case tooMuchSky = "Too much sky"
    case headBodyCutOff = "Head or body may be cut off"
    case subjectTooCloseToEdge = "Subject too close to edge"
    case stepBack = "Step back"
    case getCloser = "Get closer"
    case moveLeft = "Move left"
    case moveRight = "Move right"
    case subjectTooCentered = "Subject too centered"
    case frameIsGood = "Frame is good"

    var id: String { rawValue }

    var displayText: String { rawValue }
}
