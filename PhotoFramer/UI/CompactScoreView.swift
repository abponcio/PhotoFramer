import SwiftUI

struct CompactScoreView: View {
    let score: Int
    let isLevel: Bool

    private var scoreColor: Color {
        switch CompositionRules.scoreColor(for: score, isLevel: isLevel) {
        case .good: return AppTheme.CameraHUD.goodGreen
        case .adjust: return AppTheme.CameraHUD.adjustYellow
        case .critical: return AppTheme.CameraHUD.criticalOrange
        }
    }

    var body: some View {
        Text("\(score)")
            .font(.caption.monospacedDigit().weight(.semibold))
            .foregroundStyle(scoreColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .stroke(scoreColor.opacity(isFrameGood ? 1 : 0.5), lineWidth: isFrameGood ? 2 : 1)
            )
    }

    private var isFrameGood: Bool {
        score >= CompositionRules.goodScoreThreshold && isLevel
    }
}
