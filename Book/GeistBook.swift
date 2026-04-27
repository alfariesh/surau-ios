import SwiftUI

// MARK: - Enums

enum GeistBookVariant { case stripe, simple, image }

enum GeistBookRatio {
    case geist, a4, b5, novel, tradePaperback, square

    var w: CGFloat {
        switch self {
        case .geist: 49; case .a4: 210; case .b5: 176
        case .novel: 5;  case .tradePaperback: 6; case .square: 1
        }
    }
    var h: CGFloat {
        switch self {
        case .geist: 60; case .a4: 297; case .b5: 250
        case .novel: 7;  case .tradePaperback: 9; case .square: 1
        }
    }
}

// MARK: - Tokens

private enum T {
    static let depthRatio:            CGFloat = 0.29
    static let backRevealRatio:       CGFloat = 0.34
    static let pagesVisibleRatio:     CGFloat = 0.28
    static let pagesTaperRatio:       CGFloat = 0.018
    static let spineWidthRatio:       CGFloat = 0.082
    static let bodyPadRatio:          CGFloat = 0.061
    static let bodyPadSpineRatio:     CGFloat = 0.142
    static let titleSizeRatio:        CGFloat = 0.105
    static let titleLineHMul:         CGFloat = 1.25
    static let titleTrackingMul:      CGFloat = -0.02
    static let simpleIllRatio:        CGFloat = 0.22
    static let spineCorner:           CGFloat = 6
    static let outerCorner:           CGFloat = 4
    static let pressTilt:             Double  = 20
    static let pressScale:            CGFloat = 1.03
    static let backDarken:            CGFloat = 0.35
    static let perspective:           CGFloat = 1.0 / 3.5
}

// MARK: - Brand colours

extension Color {
    static let geistAmber600     = Color(red: 0.969, green: 0.725, blue: 0.333) // #F7B955
    static let geistBackground200 = Color(white: 0.98)                          // #FAFAFA
}

// MARK: - GeistBook

struct GeistBook: View {

    // --- Public API ---
    let title: String
    var color: Color                = .geistAmber600
    var textColor: Color            = Color(white: 0.09)
    var variant: GeistBookVariant   = .stripe
    var textured: Bool              = false
    var width: CGFloat              = 196
    var ratio: GeistBookRatio       = .b5
    var bodyBackground: Color       = .geistBackground200
    var onTap: (() -> Void)?        = nil
    var rtl: Bool                   = false
    private let _illustration: AnyView?

    // Standard init (no illustration)
    init(
        title: String,
        color: Color = .geistAmber600,
        textColor: Color = Color(white: 0.09),
        variant: GeistBookVariant = .stripe,
        textured: Bool = false,
        width: CGFloat = 196,
        ratio: GeistBookRatio = .b5,
        bodyBackground: Color = .geistBackground200,
        onTap: (() -> Void)? = nil,
        rtl: Bool = false
    ) {
        self.title = title; self.color = color; self.textColor = textColor
        self.variant = variant; self.textured = textured; self.width = width
        self.ratio = ratio; self.bodyBackground = bodyBackground
        self.onTap = onTap; self.rtl = rtl; self._illustration = nil
    }

    // Init with @ViewBuilder illustration
    init<Content: View>(
        title: String,
        color: Color = .geistAmber600,
        textColor: Color = Color(white: 0.09),
        variant: GeistBookVariant = .stripe,
        textured: Bool = false,
        width: CGFloat = 196,
        ratio: GeistBookRatio = .b5,
        bodyBackground: Color = .geistBackground200,
        onTap: (() -> Void)? = nil,
        rtl: Bool = false,
        @ViewBuilder illustration: () -> Content
    ) {
        self.title = title; self.color = color; self.textColor = textColor
        self.variant = variant; self.textured = textured; self.width = width
        self.ratio = ratio; self.bodyBackground = bodyBackground
        self.onTap = onTap; self.rtl = rtl
        self._illustration = AnyView(illustration())
    }

    // --- State ---
    @GestureState private var isPressed = false

    // --- Derived layout ---
    private var height:        CGFloat { width * ratio.h / ratio.w }
    private var depth:         CGFloat { width * T.depthRatio }
    private var backRevealX:   CGFloat { depth * T.backRevealRatio }
    private var pagesW:        CGFloat { depth * T.pagesVisibleRatio }
    private var frontOffsetX:  CGFloat { rtl ? backRevealX : 0 }
    private var backOffsetX:   CGFloat { isPressed ? (rtl ? 0 : backRevealX) : (rtl ? backRevealX : 0) }
    private var pagesOffsetX:  CGFloat { rtl ? frontOffsetX - pagesW : width - 1 }
    private var anchor:        UnitPoint { rtl ? .trailing : .leading }
    private var rotY:          Double { isPressed ? (rtl ? T.pressTilt : -T.pressTilt) : 0 }
    private var bookScale:     CGFloat { isPressed ? T.pressScale : 1 }
    private var spring:        Animation { .spring(response: 0.5, dampingFraction: 1.0) }

    // MARK: body

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.clear.frame(width: width + backRevealX, height: height)

            // Back cover
            bookShape()
                .fill(color.darkened(by: T.backDarken))
                .frame(width: width, height: height)
                .offset(x: backOffsetX)
                .animation(spring, value: isPressed)

            // Pages slab
            PagesSlabCanvas(width: pagesW + 1, height: height, rtl: rtl)
                .frame(width: pagesW + 1, height: height)
                .scaleEffect(CGSize(width: isPressed ? 1 : 0.001, height: 1),
                             anchor: rtl ? .trailing : .leading)
                .opacity(isPressed ? 1 : 0)
                .offset(x: pagesOffsetX)
                .animation(spring, value: isPressed)

            // Front cover
            frontCover
                .frame(width: width, height: height)
                .clipShape(bookShape())
                .shadow(color: .black.opacity(0.22), radius: 8, x: 2, y: 4)
                .rotation3DEffect(.degrees(rotY),
                                  axis: (x: 0, y: 1, z: 0),
                                  anchor: anchor,
                                  perspective: T.perspective)
                .scaleEffect(bookScale, anchor: anchor)
                .offset(x: frontOffsetX)
                .animation(spring, value: isPressed)
        }
        .frame(width: width + backRevealX, height: height)
        .gesture(
            DragGesture(minimumDistance: 0)
                .updating($isPressed) { _, state, _ in state = true }
                .onEnded { v in
                    if hypot(v.translation.width, v.translation.height) < 10 { onTap?() }
                }
        )
    }

    // MARK: - Front cover layers

    @ViewBuilder private var frontCover: some View {
        ZStack {
            bodyBackground  // base paper
            coverContent
            spineShadow
        }
        .drawingGroup()  // composites so .multiply blends against book content, not screen
    }

    @ViewBuilder private var coverContent: some View {
        switch variant {
        case .stripe: stripeCover
        case .simple: simpleCover
        case .image:  imageCover
        }
    }

    // Stripe: coloured top half + bodyBackground bottom half
    @ViewBuilder private var stripeCover: some View {
        VStack(spacing: 0) {
            ZStack {
                color.frame(maxWidth: .infinity, maxHeight: .infinity)
                if let ill = _illustration { ill }
                if textured { textureOverlay }
            }
            .frame(maxWidth: .infinity)
            .frame(height: height * 0.5)

            ZStack(alignment: rtl ? .topTrailing : .topLeading) {
                bodyBackground.frame(maxWidth: .infinity, maxHeight: .infinity)
                coverBody(showLogo: true, simpleVariant: false)
                if textured { textureOverlay }
            }
        }
    }

    // Simple: full-colour body
    @ViewBuilder private var simpleCover: some View {
        ZStack {
            color.frame(maxWidth: .infinity, maxHeight: .infinity)
            coverBody(showLogo: false, simpleVariant: true)
            if textured { textureOverlay }
        }
    }

    // Image: full-bleed illustration + scrim + title
    @ViewBuilder private var imageCover: some View {
        ZStack(alignment: rtl ? .bottomTrailing : .bottomLeading) {
            if let ill = _illustration { ill.frame(maxWidth: .infinity, maxHeight: .infinity) }

            // Bottom scrim for legibility
            LinearGradient(
                colors: [.clear, .black.opacity(0.55)],
                startPoint: .top, endPoint: .bottom
            )
            .frame(maxWidth: .infinity)
            .frame(height: height * 0.45)
            .frame(maxHeight: .infinity, alignment: .bottom)

            // Title
            Text(title)
                .font(.system(size: titleFontSize, weight: .semibold))
                .tracking(titleFontSize * T.titleTrackingMul)
                .lineSpacing(titleFontSize * (T.titleLineHMul - 1))
                .foregroundStyle(textColor)
                .multilineTextAlignment(rtl ? .trailing : .leading)
                .padding(.leading,   rtl ? padAll : padSpine)
                .padding(.trailing,  rtl ? padSpine : padAll)
                .padding(.bottom, padAll)

            if textured { textureOverlay }
        }
    }

    // Shared body content (title + logo/illustration)
    @ViewBuilder private func coverBody(showLogo: Bool, simpleVariant: Bool) -> some View {
        VStack(alignment: rtl ? .trailing : .leading,
               spacing: simpleVariant ? width * 0.05 : 0) {

            Text(title)
                .font(.system(size: titleFontSize, weight: .semibold))
                .tracking(titleFontSize * T.titleTrackingMul)
                .lineSpacing(titleFontSize * (T.titleLineHMul - 1))
                .foregroundStyle(textColor)
                .multilineTextAlignment(rtl ? .trailing : .leading)
                .frame(maxWidth: .infinity, alignment: rtl ? .trailing : .leading)

            if simpleVariant {
                bottomDecoration(showLogo: showLogo)
            } else {
                Spacer()
                bottomDecoration(showLogo: showLogo)
            }
        }
        .padding(.leading,  rtl ? padAll : padSpine)
        .padding(.trailing, rtl ? padSpine : padAll)
        .padding(.top, padAll)
        .padding(.bottom, padAll)
    }

    @ViewBuilder private func bottomDecoration(showLogo: Bool) -> some View {
        HStack {
            if rtl { Spacer() }
            if showLogo {
                VercelLogo(size: width * 0.082, color: textColor)
            } else if let ill = _illustration {
                ill
            } else {
                SimpleIllustration(width: width * T.simpleIllRatio)
            }
            if !rtl { Spacer() }
        }
    }

    // Spine shadow with multiply blend
    @ViewBuilder private var spineShadow: some View {
        let stops: [Gradient.Stop] = rtl ? [
            .init(color: .clear, location: 0),
            .init(color: .black.opacity(0.08), location: 0.20),
            .init(color: .black.opacity(0.35), location: 0.24),
            .init(color: .black.opacity(0.05), location: 0.45),
            .init(color: .black.opacity(0.08), location: 0.65),
            .init(color: .black.opacity(0.22), location: 0.85),
            .init(color: .black.opacity(0.30), location: 1.00),
        ] : [
            .init(color: .black.opacity(0.30), location: 0.00),
            .init(color: .black.opacity(0.22), location: 0.15),
            .init(color: .black.opacity(0.08), location: 0.35),
            .init(color: .black.opacity(0.05), location: 0.55),
            .init(color: .black.opacity(0.35), location: 0.76),
            .init(color: .black.opacity(0.08), location: 0.80),
            .init(color: .clear,               location: 1.00),
        ]

        LinearGradient(stops: stops, startPoint: .leading, endPoint: .trailing)
            .frame(width: width * T.spineWidthRatio)
            .frame(maxHeight: .infinity)
            .frame(maxWidth: .infinity, alignment: rtl ? .trailing : .leading)
            .blendMode(.multiply)
    }

    // Texture overlay — subtle diagonal noise effect
    @ViewBuilder private var textureOverlay: some View {
        LinearGradient(
            colors: [.black.opacity(0.05), .white.opacity(0.04), .black.opacity(0.05)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .allowsHitTesting(false)
    }

    // MARK: - Helpers

    private func bookShape() -> UnevenRoundedRectangle {
        rtl
        ? UnevenRoundedRectangle(topLeadingRadius: T.outerCorner, bottomLeadingRadius: T.outerCorner,
                                  bottomTrailingRadius: T.spineCorner, topTrailingRadius: T.spineCorner)
        : UnevenRoundedRectangle(topLeadingRadius: T.spineCorner, bottomLeadingRadius: T.spineCorner,
                                  bottomTrailingRadius: T.outerCorner, topTrailingRadius: T.outerCorner)
    }

    private var titleFontSize: CGFloat { width * T.titleSizeRatio }
    private var padAll:   CGFloat { width * T.bodyPadRatio }
    private var padSpine: CGFloat { width * T.bodyPadSpineRatio }
}

// MARK: - Pages slab

private struct PagesSlabCanvas: View {
    let width: CGFloat
    let height: CGFloat
    let rtl: Bool

    var body: some View {
        Canvas { ctx, size in
            let taper = size.height * T.pagesTaperRatio
            var path = Path()
            if rtl {
                path.move(to: CGPoint(x: size.width, y: 0))
                path.addLine(to: CGPoint(x: 0, y: taper))
                path.addLine(to: CGPoint(x: 0, y: size.height - taper))
                path.addLine(to: CGPoint(x: size.width, y: size.height))
            } else {
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: size.width, y: taper))
                path.addLine(to: CGPoint(x: size.width, y: size.height - taper))
                path.addLine(to: CGPoint(x: 0, y: size.height))
            }
            path.closeSubpath()

            let gradient = Gradient(stops: rtl ? [
                .init(color: Color(white: 1.00), location: 0.0),
                .init(color: Color(white: 0.965), location: 0.3),
                .init(color: Color(white: 0.87),  location: 1.0),
            ] : [
                .init(color: Color(white: 0.87),  location: 0.0),
                .init(color: Color(white: 0.965), location: 0.7),
                .init(color: Color(white: 1.00),  location: 1.0),
            ])
            ctx.fill(path, with: .linearGradient(
                gradient,
                startPoint: CGPoint(x: 0, y: size.height / 2),
                endPoint:   CGPoint(x: size.width, y: size.height / 2)
            ))
        }
        .frame(width: width, height: height)
    }
}

// MARK: - Illustrations

/// Vercel logo — solid equilateral triangle pointing up.
struct VercelLogo: View {
    let size: CGFloat
    var color: Color = .black

    var body: some View {
        Canvas { ctx, s in
            var p = Path()
            p.move(to: CGPoint(x: s.width / 2, y: 0))
            p.addLine(to: CGPoint(x: s.width, y: s.height))
            p.addLine(to: CGPoint(x: 0, y: s.height))
            p.closeSubpath()
            ctx.fill(p, with: .color(color))
        }
        .frame(width: size, height: size)
    }
}

/// Three interlocking curved segments — port of geist's simple-illustration.svg (viewBox 36×56).
struct SimpleIllustration: View {
    let width: CGFloat
    var blue: Color = Color(red: 0, green: 0.44, blue: 0.95)  // #0070F3
    var teal: Color = Color(red: 0.27, green: 0.87, blue: 0.77) // #45DEC4
    var red:  Color = Color(red: 0.9, green: 0.28, blue: 0.30)  // #E5484D

    private var height: CGFloat { width * (56 / 36) }

    var body: some View {
        Canvas { ctx, size in
            let sx = size.width  / 36
            let sy = size.height / 56

            func pt(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x * sx, y: y * sy) }

            // Teal (top dome)
            var tealPath = Path()
            tealPath.move(to: pt(32.97, 28.00))
            tealPath.addCurve(to: pt(36, 18.00), control1: pt(34.88, 25.14), control2: pt(36, 21.70))
            tealPath.addCurve(to: pt(18, 0.00), control1: pt(36, 8.06), control2: pt(27.94, 0.00))
            tealPath.addCurve(to: pt(0, 18.00), control1: pt(8.06, 0.00), control2: pt(0, 8.06))
            tealPath.addCurve(to: pt(3.03, 28.00), control1: pt(0, 21.70), control2: pt(1.12, 25.14))
            tealPath.addCurve(to: pt(18, 20.00), control1: pt(6.26, 23.18), control2: pt(11.76, 20.00))
            tealPath.addCurve(to: pt(32.97, 28.00), control1: pt(24.24, 20.00), control2: pt(29.74, 23.18))
            tealPath.closeSubpath()

            // Blue (middle lens)
            var bluePath = Path()
            bluePath.move(to: pt(3.03, 28.00))
            bluePath.addCurve(to: pt(18, 20.00), control1: pt(6.26, 23.18), control2: pt(11.76, 20.00))
            bluePath.addCurve(to: pt(32.97, 28.00), control1: pt(24.24, 20.00), control2: pt(29.74, 23.18))
            bluePath.addCurve(to: pt(18, 36.00), control1: pt(29.74, 32.82), control2: pt(24.24, 36.00))
            bluePath.addCurve(to: pt(3.03, 28.00), control1: pt(11.76, 36.00), control2: pt(6.26, 32.82))
            bluePath.closeSubpath()

            // Red (bottom dome)
            var redPath = Path()
            redPath.move(to: pt(32.97, 28.00))
            redPath.addCurve(to: pt(18, 36.00), control1: pt(29.74, 32.82), control2: pt(24.24, 36.00))
            redPath.addCurve(to: pt(3.03, 28.00), control1: pt(11.76, 36.00), control2: pt(6.26, 32.82))
            redPath.addCurve(to: pt(0, 38.00), control1: pt(1.12, 30.86), control2: pt(0, 34.30))
            redPath.addCurve(to: pt(18, 56.00), control1: pt(0, 47.94), control2: pt(8.06, 56.00))
            redPath.addCurve(to: pt(36, 38.00), control1: pt(27.94, 56.00), control2: pt(36, 47.94))
            redPath.addCurve(to: pt(32.97, 28.00), control1: pt(36, 34.30), control2: pt(34.88, 30.86))
            redPath.closeSubpath()

            ctx.fill(tealPath, with: .color(teal))
            ctx.fill(bluePath, with: .color(blue))
            ctx.fill(redPath,  with: .color(red))
        }
        .frame(width: width, height: height)
    }
}

// MARK: - Color helpers

extension Color {
    func darkened(by fraction: CGFloat) -> Color {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
        return Color(
            red:   r * (1 - fraction),
            green: g * (1 - fraction),
            blue:  b * (1 - fraction),
            opacity: Double(a)
        )
    }
}
