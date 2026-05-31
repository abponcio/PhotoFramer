import AVFoundation
import Combine
import Foundation
import UIKit

@MainActor
final class CameraPermissionManager: ObservableObject {
    enum Status: Equatable {
        case notDetermined
        case authorized
        case denied
        case restricted
    }

    @Published private(set) var status: Status = .notDetermined

    init() {
        refresh()
    }

    func refresh() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            status = .authorized
        case .notDetermined:
            status = .notDetermined
        case .denied:
            status = .denied
        case .restricted:
            status = .restricted
        @unknown default:
            status = .denied
        }
    }

    func requestAccess() async -> Bool {
        let granted = await AVCaptureDevice.requestAccess(for: .video)
        refresh()
        return granted
    }

    var settingsURL: URL? {
        URL(string: UIApplication.openSettingsURLString)
    }
}
