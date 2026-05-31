import SwiftUI
import UIKit

struct ContentView: View {
    @StateObject private var permissions = CameraPermissionManager()
    @StateObject private var viewModel = FramingViewModel()

    var body: some View {
        Group {
            switch permissions.status {
            case .authorized:
                cameraScreen
            case .notDetermined:
                OnboardingView(
                    onEnableCamera: { Task { await requestCamera() } },
                    onOpenSettings: openSettings,
                    isDenied: false
                )
            case .denied, .restricted:
                OnboardingView(
                    onEnableCamera: {},
                    onOpenSettings: openSettings,
                    isDenied: true
                )
            }
        }
        .onAppear { permissions.refresh() }
        .alert("Open Camera", isPresented: $viewModel.showCameraOpenFailed) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Couldn't open the Camera app automatically. Open Camera from your Home Screen for the best photo quality.")
        }
        .alert("Save Failed", isPresented: .init(
            get: { viewModel.saveErrorMessage != nil },
            set: { if !$0 { viewModel.saveErrorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { viewModel.saveErrorMessage = nil }
        } message: {
            Text(viewModel.saveErrorMessage ?? "")
        }
        .overlay(alignment: .top) {
            if viewModel.showSaveToast {
                Text("Saved to Photos")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Capsule().fill(Color.black.opacity(0.7)))
                    .padding(.top, 60)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        Task {
                            try? await Task.sleep(nanoseconds: 2_000_000_000)
                            withAnimation { viewModel.showSaveToast = false }
                        }
                    }
            }
        }
        .animation(.easeInOut, value: viewModel.showSaveToast)
    }

    private var cameraScreen: some View {
        ZStack {
            CameraPreviewView(cameraManager: viewModel.cameraManager)
                .ignoresSafeArea()

            CoachingOverlayStack(
                composition: viewModel.composition,
                showGrid: viewModel.showGrid
            )
            .ignoresSafeArea()

            if viewModel.cameraManager.captureFlash {
                Color.white.opacity(0.35)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }

            CameraChromeView(
                viewModel: viewModel,
                onShutterTap: { Task { await viewModel.openNativeCamera() } },
                onCaptureInApp: { viewModel.captureInApp() }
            )
            .ignoresSafeArea()
        }
        .onAppear { viewModel.onAppearAuthorized() }
        .onDisappear { viewModel.onDisappear() }
        .onReceive(viewModel.levelDetector.$rollDegrees) { _ in
            viewModel.refreshComposition()
        }
        .onReceive(viewModel.levelDetector.$pitchDegrees) { _ in
            viewModel.refreshComposition()
        }
    }

    private func requestCamera() async {
        let granted = await permissions.requestAccess()
        if granted {
            viewModel.onAppearAuthorized()
        }
    }

    private func openSettings() {
        guard let url = permissions.settingsURL else { return }
        UIApplication.shared.open(url)
    }
}

