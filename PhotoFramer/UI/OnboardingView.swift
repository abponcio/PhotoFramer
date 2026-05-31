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
        Image("PhotoFramerLogo")
            .resizable()
            .scaledToFit()
            .frame(width: 120, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .shadow(color: .black.opacity(0.12), radius: 12, y: 6)
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
