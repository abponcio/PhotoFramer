import SwiftUI

struct CoachingCaptionView: View {
    let text: String
    let isGood: Bool

    var body: some View {
        Text(text)
            .font(.subheadline.weight(.medium))
            .foregroundStyle(isGood ? AppTheme.CameraHUD.goodGreen : AppTheme.CameraHUD.hudForeground)
            .shadow(color: .black.opacity(0.8), radius: 4, x: 0, y: 1)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
    }
}
