import Combine
import CoreMotion
import Foundation

@MainActor
final class LevelDetector: ObservableObject {
    @Published private(set) var rollDegrees: Double = 0
    @Published private(set) var pitchDegrees: Double = 0

    var isLevel: Bool {
        abs(rollDegrees) < CompositionRules.levelRollThreshold
    }

    private let motionManager = CMMotionManager()
    private var isUpdating = false

    func start() {
        guard motionManager.isDeviceMotionAvailable, !isUpdating else { return }
        motionManager.deviceMotionUpdateInterval = 1.0 / 30.0
        isUpdating = true

        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: .main) { [weak self] motion, _ in
            guard let self, let motion else { return }
            let roll = motion.attitude.roll * 180 / .pi
            let pitch = motion.attitude.pitch * 180 / .pi
            self.rollDegrees = roll
            self.pitchDegrees = pitch
        }
    }

    func stop() {
        motionManager.stopDeviceMotionUpdates()
        isUpdating = false
    }
}
