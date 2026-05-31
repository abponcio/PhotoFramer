import SwiftUI

struct OnboardingView: View {
    let onEnableCamera: () -> Void
    let onOpenSettings: () -> Void
    let isDenied: Bool

    var body: some View {
        ZStack {
            AppTheme.Onboarding.surface.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                appMark

                VStack(spacing: 12) {
                    Text("PhotoFramer")
                        .font(.title2.bold)
                        .foregroundStyle(AppTheme.Onboarding.onSurface)

                    Text("Frame it right, before you shoot.")
                        .font(.body)
                        .foregroundStyle(AppTheme.Onboarding.onSurfaceMuted)
                        .multilineTextAlignment(.center)

                    Text("Live framing guidance for travel photos — level your shot, place your subject, then capture with iPhone Camera for the best quality.")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.Onboarding.onSurfaceMuted)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                }

                Spacer()

                if isDenied {
                    Button("Open Settings", action: onOpenSettings)
                        .buttonStyle(PrimaryOnboardingButtonStyle())
                } else {
                    Button("Enable Camera", action: onEnableCamera)
                        .buttonStyle(PrimaryOnboardingButtonStyle())
                }
            }
            .padding(32)
        }
    }

    private var appMark: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(AppTheme.Onboarding.primaryContainer)
                .frame(width: 80, height: 80)

            ZStack {
                Path { path in
                    let inset: CGFloat = 18
                    path.move(to: CGPoint(x: inset, y: inset + 8))
                    path.addLine(to: CGPoint(x: inset, y: inset))
                    path.addLine(to: CGPoint(x: inset + 8, y: inset))
                    path.move(to: CGPoint(x: 62 - inset, y: inset + 8))
                    path.addLine(to: CGPoint(x: 62 - inset, y: inset))
                    path.addLine(to: CGPoint(x: 62 - inset - 8, y: inset))
                    path.move(to: CGPoint(x: inset, y: 62 - inset - 8))
                    path.addLine(to: CGPoint(x: inset, y: 62 - inset))
                    path.addLine(to: CGPoint(x: inset + 8, y: 62 - inset))
                }
                .stroke(AppTheme.Onboarding.surface, lineWidth: 2)

                Circle()
                    .fill(AppTheme.CameraHUD.goodGreen)
                    .frame(width: 8, height: 8)
                    .offset(x: 14, y: 14)
            }
            .frame(width: 62, height: 62)
        }
    }
}

struct PrimaryOnboardingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(AppTheme.Onboarding.onPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(AppTheme.Onboarding.primary)
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? 0.85 : 1)
    }
}
