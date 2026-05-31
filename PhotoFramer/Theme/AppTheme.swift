import SwiftUI

enum AppTheme {
    enum CameraHUD {
        static let hudForeground = Color.white
        static let hudForegroundDim = Color.white.opacity(0.55)
        static let hudBackground = Color.black.opacity(0.5)
        static let shutterRing = Color.white
        static let shutterInner = Color.white.opacity(0.3)
        static let goodGreen = Color(red: 0.188, green: 0.820, blue: 0.345)
        static let adjustYellow = Color(red: 1.0, green: 0.839, blue: 0.039)
        static let criticalOrange = Color(red: 1.0, green: 0.624, blue: 0.039)
        static let gridLine = Color.white.opacity(0.35)
        static let subjectStroke = Color.white.opacity(0.6)
        static let idealMarker = Color.white.opacity(0.8)
    }

    enum Onboarding {
        static let surface = Color(red: 0.949, green: 0.984, blue: 1.0)
        static let primary = Color(red: 0.0, green: 0.278, blue: 0.322)
        static let onSurface = Color(red: 0.035, green: 0.118, blue: 0.145)
        static let onSurfaceMuted = Color(red: 0.251, green: 0.282, blue: 0.290)
        static let primaryContainer = Color(red: 0.118, green: 0.373, blue: 0.420)
        static let onPrimary = Color.white
    }
}
