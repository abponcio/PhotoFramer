import SwiftUI

struct PersonBoundingBoxView: View {
    let rect: CGRect
    let isFrameGood: Bool

    var body: some View {
        GeometryReader { geometry in
            let frame = CGRect(
                x: rect.origin.x * geometry.size.width,
                y: rect.origin.y * geometry.size.height,
                width: rect.width * geometry.size.width,
                height: rect.height * geometry.size.height
            )

            RoundedRectangle(cornerRadius: 4)
                .stroke(
                    isFrameGood ? AppTheme.CameraHUD.goodGreen : AppTheme.CameraHUD.subjectStroke,
                    lineWidth: 1.5
                )
                .frame(width: frame.width, height: frame.height)
                .position(x: frame.midX, y: frame.midY)
        }
        .allowsHitTesting(false)
    }
}
