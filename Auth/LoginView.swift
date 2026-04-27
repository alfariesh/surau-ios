import SwiftUI

struct LoginView: View {
    @Binding var path: NavigationPath
    @Environment(AuthViewModel.self) private var auth

    @State private var email = ""
    @State private var password = ""
    @FocusState private var focusedField: Field?

    private enum Field: Hashable { case email, password }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                AuthHeader(
                    icon: "building.columns.fill",
                    title: "Selamat Datang",
                    subtitle: "Masuk ke akun Surau kamu"
                )
                .padding(.top, 60)
                .padding(.bottom, 40)

                // Fields
                VStack(spacing: 16) {
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
                        placeholder: "Password",
                        systemImage: "lock",
                        text: $password,
                        isSecure: true,
                        isFocused: focusedField == .password
                    )
                    .focused($focusedField, equals: .password)
                    .submitLabel(.go)
                    .onSubmit { performLogin() }
                    .textContentType(.password)

                    HStack {
                        Spacer()
                        Button("Lupa password?") {
                            focusedField = nil
                            path.append(AuthRoute.forgotPassword)
                        }
                        .font(.subheadline)
                        .foregroundStyle(Color.brandPrimary)
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
                    title: "Masuk",
                    isLoading: auth.isLoading,
                    isDisabled: email.trimmingCharacters(in: .whitespaces).isEmpty || password.isEmpty
                ) {
                    performLogin()
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)

                SocialDivider()
                    .padding(.horizontal, 24)
                    .padding(.vertical, 24)

                VStack(spacing: 12) {
                    SocialButton(
                        title: "Masuk dengan Apple",
                        icon: "apple.logo",
                        style: .dark
                    ) {
                        focusedField = nil
                        Task { await auth.signInWithApple() }
                    }

                    SocialButton(
                        title: "Masuk dengan Google",
                        icon: "globe",
                        style: .light
                    ) {
                        focusedField = nil
                        Task { await auth.signInWithGoogle() }
                    }
                }
                .padding(.horizontal, 24)

                HStack(spacing: 4) {
                    Text("Belum punya akun?")
                        .foregroundStyle(.secondary)
                    Button("Daftar sekarang") {
                        focusedField = nil
                        path.append(AuthRoute.signUp)
                    }
                    .foregroundStyle(Color.brandPrimary)
                    .fontWeight(.semibold)
                }
                .font(.subheadline)
                .padding(.top, 32)
                .padding(.bottom, 48)
            }
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
        .scrollDismissesKeyboard(.interactively)
        .animation(.easeInOut(duration: 0.25), value: auth.errorMessage)
        .onChange(of: email) { auth.errorMessage = nil }
        .onChange(of: password) { auth.errorMessage = nil }
    }

    private func performLogin() {
        focusedField = nil
        Task { await auth.login(email: email.trimmingCharacters(in: .whitespaces), password: password) }
    }
}
