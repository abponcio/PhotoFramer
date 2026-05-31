import SwiftUI

struct HorizonOverlayView: View {
    let rollDegrees: Double
    let isLevel: Bool

    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let lineLength = geometry.size.width * 0.55
            let color = isLevel ? AppTheme.CameraHUD.goodGreen : AppTheme.CameraHUD.adjustYellow

            Path { path in
                path.move(to: CGPoint(x: -lineLength / 2, y: 0))
                path.addLine(to: CGPoint(x: lineLength / 2, y: 0))
            }
            .stroke(color, lineWidth: 1)
            .position(center)
            .rotationEffect(.degrees(-rollDegrees))
        }
        .allowsHitTesting(false)
    }
}
