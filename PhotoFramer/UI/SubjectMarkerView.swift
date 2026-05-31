import SwiftUI

struct SubjectMarkerView: View {
    let idealPoint: CGPoint
    let personRect: CGRect

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let target = CGPoint(
                x: idealPoint.x * size.width,
                y: idealPoint.y * size.height
            )
            let personCenter = CGPoint(
                x: personRect.midX * size.width,
                y: personRect.midY * size.height
            )
            let offset = hypot(target.x - personCenter.x, target.y - personCenter.y)

            if offset > 24 {
                Path { path in
                    path.move(to: personCenter)
                    path.addLine(to: target)
                }
                .stroke(AppTheme.CameraHUD.idealMarker.opacity(0.5), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
            }

            ZStack {
                Circle()
                    .stroke(AppTheme.CameraHUD.idealMarker, lineWidth: 1.5)
                    .frame(width: 28, height: 28)
                Path { path in
                    path.move(to: CGPoint(x: -10, y: 0))
                    path.addLine(to: CGPoint(x: 10, y: 0))
                    path.move(to: CGPoint(x: 0, y: -10))
                    path.addLine(to: CGPoint(x: 0, y: 10))
                }
                .stroke(AppTheme.CameraHUD.idealMarker, lineWidth: 1)
            }
            .position(target)
        }
        .allowsHitTesting(false)
    }
}
