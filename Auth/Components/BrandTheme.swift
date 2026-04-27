import SwiftUI

extension Color {
    static let brandPrimary   = Color(red: 0.31, green: 0.44, blue: 0.97)  // #4F70F7
    static let brandSecondary = Color(red: 0.55, green: 0.36, blue: 0.96)  // #8C5CF5
}

extension LinearGradient {
    static let brand = LinearGradient(
        colors: [.brandPrimary, .brandSecondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
