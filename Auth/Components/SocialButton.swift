import SwiftUI

struct SocialButton: View {
    enum Style { case light, dark }

    let title: String
    let icon: String
    let style: Style
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                Text(title)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .foregroundStyle(style == .dark ? .white : .primary)
            .background(style == .dark ? Color.black : Color(UIColor.secondarySystemBackground))
            .clipShape(.rect(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(Color(UIColor.separator), lineWidth: 1)
            }
        }
    }
}
