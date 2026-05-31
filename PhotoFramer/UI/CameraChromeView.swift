import SwiftUI

struct CameraChromeView: View {
    @ObservedObject var viewModel: FramingViewModel
    let onShutterTap: () -> Void
    let onCaptureInApp: () -> Void

    var body: some View {
        VStack {
            topBar
            Spacer()
            CoachingCaptionView(
                text: viewModel.composition.suggestion.displayText,
                isGood: viewModel.composition.isFrameGood
            )
            .padding(.bottom, 8)
            bottomBar
        }
    }

    private var topBar: some View {
        HStack {
            Image(systemName: "bolt.slash.fill")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(AppTheme.CameraHUD.hudForegroundDim)
                .frame(width: 44, height: 44)

            Spacer()

            HStack(spacing: 16) {
                Button {
                    viewModel.showGrid.toggle()
                } label: {
                    Image(systemName: viewModel.showGrid ? "grid" : "grid.circle")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(
                            viewModel.showGrid
                                ? AppTheme.CameraHUD.hudForeground
                                : AppTheme.CameraHUD.hudForegroundDim
                        )
                }
                .frame(width: 44, height: 44)

                CompactScoreView(
                    score: viewModel.composition.score,
                    isLevel: viewModel.composition.isLevel
                )
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 8)
        .background(AppTheme.CameraHUD.hudBackground.ignoresSafeArea(edges: .top))
    }

    private var bottomBar: some View {
        VStack(spacing: 8) {
            HStack(alignment: .center) {
                thumbnailButton
                Spacer()
                shutterButton
                Spacer()
                captureInAppButton
            }
            .padding(.horizontal, 28)

            Text("PHOTO")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(AppTheme.CameraHUD.hudForeground)
                .tracking(1.5)
        }
        .padding(.top, 12)
        .padding(.bottom, 24)
        .background(
            AppTheme.CameraHUD.hudBackground
                .ignoresSafeArea(edges: .bottom)
        )
    }

    private var thumbnailButton: some View {
        Group {
            if let thumb = viewModel.cameraManager.lastThumbnail {
                Image(uiImage: thumb)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 48, height: 48)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.white.opacity(0.3), lineWidth: 1))
            } else {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(AppTheme.CameraHUD.hudForegroundDim, lineWidth: 1)
                    .frame(width: 48, height: 48)
            }
        }
        .frame(width: 56, height: 56)
    }

    private var shutterButton: some View {
        Button(action: onShutterTap) {
            ZStack {
                Circle()
                    .stroke(AppTheme.CameraHUD.shutterRing, lineWidth: 4)
                    .frame(width: 72, height: 72)
                Circle()
                    .fill(AppTheme.CameraHUD.shutterInner)
                    .frame(width: 60, height: 60)
            }
            .scaleEffect(viewModel.cameraManager.captureFlash ? 0.92 : 1)
            .animation(.easeOut(duration: 0.12), value: viewModel.cameraManager.captureFlash)
        }
        .accessibilityLabel("Open iPhone Camera")
    }

    private var captureInAppButton: some View {
        Button(action: onCaptureInApp) {
            Image(systemName: "square.and.arrow.down")
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(AppTheme.CameraHUD.hudForeground)
                .frame(width: 44, height: 44)
        }
        .accessibilityLabel("Capture in app")
    }
}
