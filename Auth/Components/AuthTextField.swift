import SwiftUI

struct AuthTextField: View {
    let placeholder: String
    let systemImage: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: TextInputAutocapitalization = .sentences
    var isFocused: Bool = false
    var errorMessage: String? = nil

    @State private var isRevealed = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .foregroundStyle(iconColor)
                    .frame(width: 20)
                    .animation(.easeInOut(duration: 0.2), value: isFocused)

                if isSecure && !isRevealed {
                    SecureField(placeholder, text: $text)
                        .autocorrectionDisabled()
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                        .textInputAutocapitalization(autocapitalization)
                        .autocorrectionDisabled()
                }

                if isSecure {
                    Button {
                        isRevealed.toggle()
                    } label: {
                        Image(systemName: isRevealed ? "eye.slash" : "eye")
                            .foregroundStyle(.secondary)
                            .frame(width: 20)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(UIColor.secondarySystemBackground))
            .clipShape(.rect(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(borderColor, lineWidth: isFocused ? 1.5 : 1)
            }

            if let error = errorMessage {
                Label(error, systemImage: "exclamationmark.circle.fill")
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 4)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isFocused)
        .animation(.easeInOut(duration: 0.2), value: errorMessage)
    }

    private var iconColor: Color {
        if errorMessage != nil { return .red }
        return isFocused ? .brandPrimary : .secondary
    }

    private var borderColor: Color {
        if errorMessage != nil { return .red }
        return isFocused ? .brandPrimary : Color(UIColor.separator)
    }
}
