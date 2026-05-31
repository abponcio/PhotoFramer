import SwiftUI

struct CoachingOverlayStack: View {
    let composition: CompositionState
    let showGrid: Bool

    var body: some View {
        ZStack {
            if showGrid {
                GridOverlayView()
            }

            HorizonOverlayView(
                rollDegrees: composition.rollDegrees,
                isLevel: composition.isLevel
            )

            if let rect = composition.personRect {
                PersonBoundingBoxView(rect: rect, isFrameGood: composition.isFrameGood)

                if composition.showSubjectMarker, let ideal = composition.idealSubjectPoint {
                    SubjectMarkerView(idealPoint: ideal, personRect: rect)
                }
            }
        }
    }
}
