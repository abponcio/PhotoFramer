import Foundation

enum SuggestionEngine {
    static func suggestion(from flags: CompositionFlags, score: Int, isLevel: Bool) -> FramingSuggestion {
        if score >= CompositionRules.goodScoreThreshold && isLevel && !flags.hasBlockingIssues {
            return .frameIsGood
        }
        if flags.needsLevel { return .levelPhone }
        if flags.needsRaiseCamera { return .raiseCamera }
        if flags.needsLowerCamera { return .lowerCamera }
        if flags.tooMuchSky { return .tooMuchSky }
        if flags.headBodyCutOff { return .headBodyCutOff }
        if flags.subjectTooCloseToEdge { return .subjectTooCloseToEdge }
        if flags.needsStepBack { return .stepBack }
        if flags.needsGetCloser { return .getCloser }
        if flags.needsMoveLeft { return .moveLeft }
        if flags.needsMoveRight { return .moveRight }
        if flags.subjectTooCentered { return .subjectTooCentered }
        return .frameIsGood
    }
}

extension CompositionFlags {
    var hasBlockingIssues: Bool {
        needsLevel || needsRaiseCamera || needsLowerCamera || tooMuchSky ||
        headBodyCutOff || subjectTooCloseToEdge || needsStepBack || needsGetCloser ||
        needsMoveLeft || needsMoveRight || subjectTooCentered
    }
}
