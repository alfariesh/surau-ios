import SwiftUI

struct SocialDivider: View {
    var body: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(Color(UIColor.separator))
                .frame(height: 1)
            Text("atau")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize()
            Rectangle()
                .fill(Color(UIColor.separator))
                .frame(height: 1)
        }
    }
}
