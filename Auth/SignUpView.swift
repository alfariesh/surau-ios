import SwiftUI

struct SignUpView: View {
    @Binding var path: NavigationPath
    @Environment(AuthViewModel.self) private var auth

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var agreedToTerms = false
    @FocusState private var focusedField: Field?

    private enum Field: Hashable { case name, email, password, confirm }

    private var passwordsMatch: Bool {
        confirmPassword.isEmpty || password == confirmPassword
    }

    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
            && email.contains("@")
            && password.count >= 8
            && password == confirmPassword
            && agreedToTerms
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                AuthHeader(
                    icon: "person.badge.plus",
                    title: "Buat Akun",
                    subtitle: "Bergabung dengan komunitas Surau"
                )
                .padding(.top, 40)
                .padding(.bottom, 32)

                VStack(spacing: 16) {
                    AuthTextField(
                        placeholder: "Nama Lengkap",
                        systemImage: "person",
                        text: $name,
                        isFocused: focusedField == .name
                    )
                    .focused($focusedField, equals: .name)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .email }
                    .textContentType(.name)

                    AuthTextField(
                        placeholder: "Email",
                        systemImage: "envelope",
                        text: $email,
                        keyboardType: .emailAddress,
                        autocapitalization: .never,
                        isFocused: focusedField == .email
                    )
                    .focused($focusedField, equals: .email)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .password }
                    .textContentType(.emailAddress)

                    AuthTextField(
                        placeholder: "Password (min. 8 karakter)",
                        systemImage: "lock",
                        text: $password,
                        isSecure: true,
                        isFocused: focusedField == .password
                    )
                    .focused($focusedField, equals: .password)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .confirm }
                    .textContentType(.newPassword)

                    AuthTextField(
                        placeholder: "Konfirmasi Password",
                        systemImage: "lock.fill",
                        text: $confirmPassword,
                        isSecure: true,
                        isFocused: focusedField == .confirm,
                        errorMessage: passwordsMatch ? nil : "Password tidak cocok"
                    )
                    .focused($focusedField, equals: .confirm)
                    .submitLabel(.done)
                    .onSubmit { focusedField = nil }
                    .textContentType(.newPassword)

                    if !password.isEmpty {
                        PasswordStrengthBar(password: password)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                    }

                    // Terms & Conditions
                    HStack(alignment: .top, spacing: 12) {
                        Button {
                            agreedToTerms.toggle()
                        } label: {
                            Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                                .foregroundStyle(agreedToTerms ? Color.brandPrimary : Color.secondary)
                                .font(.title3)
                        }
                        .buttonStyle(.plain)

                        Text("Saya setuju dengan **Syarat & Ketentuan** dan **Kebijakan Privasi** Surau.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .onTapGesture { agreedToTerms.toggle() }
                    }
                }
                .padding(.horizontal, 24)

                // Error banner
                if let message = auth.errorMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text(message)
                    }
                    .font(.subheadline)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }

                PrimaryButton(
                    title: "Buat Akun",
                    isLoading: auth.isLoading,
                    isDisabled: !isFormValid
                ) {
                    performSignUp()
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)

                HStack(spacing: 4) {
                    Text("Sudah punya akun?")
                        .foregroundStyle(.secondary)
                    Button("Masuk") {
                        if path.count > 0 { path.removeLast() }
                    }
                    .foregroundStyle(Color.brandPrimary)
                    .fontWeight(.semibold)
                }
                .font(.subheadline)
                .padding(.top, 24)
                .padding(.bottom, 48)
            }
        }
        .navigationTitle("Daftar")
        .navigationBarTitleDisplayMode(.inline)
        .scrollDismissesKeyboard(.interactively)
        .animation(.easeInOut(duration: 0.25), value: auth.errorMessage)
        .animation(.easeInOut(duration: 0.2), value: password.isEmpty)
        .onChange(of: email) { auth.errorMessage = nil }
        .onChange(of: password) { auth.errorMessage = nil }
    }

    private func performSignUp() {
        focusedField = nil
        Task {
            await auth.signUp(
                name: name.trimmingCharacters(in: .whitespaces),
                email: email.trimmingCharacters(in: .whitespaces),
                password: password
            )
        }
    }
}

private struct PasswordStrengthBar: View {
    let password: String

    private var score: Int {
        let long     = password.count >= 12
        let medium   = password.count >= 8
        let hasUpper = password.contains(where: \.isUppercase)
        let hasDigit = password.contains(where: \.isNumber)
        let hasSpec  = password.contains(where: { !$0.isLetter && !$0.isNumber })
        return [medium, long, hasUpper, hasDigit || hasSpec].filter { $0 }.count
    }

    private var filledSegments: Int {
        if score <= 1 { return 1 }
        if score <= 2 { return 2 }
        return 3
    }

    private var strengthColor: Color {
        switch filledSegments {
        case 1:  return .red
        case 2:  return .orange
        default: return .green
        }
    }

    private var strengthLabel: String {
        switch filledSegments {
        case 1:  return "Lemah"
        case 2:  return "Cukup"
        default: return "Kuat"
        }
    }

    var body: some View {
        HStack(spacing: 8) {
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { i in
                    Capsule()
                        .fill(i < filledSegments ? strengthColor : Color(UIColor.separator))
                        .frame(height: 4)
                }
            }
            Text(strengthLabel)
                .font(.caption)
                .foregroundStyle(strengthColor)
                .frame(width: 44, alignment: .leading)
        }
        .animation(.easeInOut(duration: 0.3), value: filledSegments)
    }
}
