import UIKit

enum NativeCameraLauncher {
    @MainActor
    static func openCamera() async -> Bool {
        guard let url = URL(string: "camera://") else { return false }
        return await UIApplication.shared.open(url)
    }
}
