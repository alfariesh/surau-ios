import SwiftUI

// MARK: - 3×3 color grid for the mesh gradient

private extension Color {
    // Row 0 — bright, airy blues (top of screen)
    static let sgTL = Color(red: 0.20, green: 0.30, blue: 0.92)
    static let sgTC = Color(red: 0.38, green: 0.52, blue: 0.99)
    static let sgTR = Color(red: 0.26, green: 0.18, blue: 0.88)

    // Row 1 — brand palette (mid screen)
    static let sgML = Color(red: 0.55, green: 0.36, blue: 0.96) // brandSecondary
    static let sgMC = Color(red: 0.31, green: 0.44, blue: 0.97) // brandPrimary
    static let sgMR = Color(red: 0.42, green: 0.28, blue: 0.93)

    // Row 2 — deep, rich darks (bottom of screen)
    static let sgBL = Color(red: 0.18, green: 0.10, blue: 0.62)
    static let sgBC = Color(red: 0.22, green: 0.22, blue: 0.72)
    static let sgBR = Color(red: 0.32, green: 0.14, blue: 0.75)
}

// MARK: - ShapeStyle extension

extension ShapeStyle where Self == AnyShapeStyle {
    static func surauGrain(time: TimeInterval) -> Self {
        AnyShapeStyle(ShaderLibrary.default.grainGradient(
            .boundingRect,
            .float(3),
            .float(time),
            .colorArray([
                .sgTL, .sgTC, .sgTR,
                .sgML, .sgMC, .sgMR,
                .sgBL, .sgBC, .sgBR
            ])
        ))
    }
}

// MARK: - SurauBackground view

struct SurauBackground: View {
    @State private var startTime = Date.now

    var body: some View {
        TimelineView(.animation) { context in
            let t = startTime.distance(to: context.date)
            Rectangle()
                .fill(.surauGrain(time: t))
                .ignoresSafeArea()
        }
    }
}
