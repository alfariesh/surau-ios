import SwiftUI

struct ForgotPasswordView: View {
    @Environment(AuthViewModel.self) private var auth
    @Environment(\.dismiss) private var dismiss

    @State private var email = ""
    @State private var emailSent = false
    @FocusState private var isEmailFocused: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if emailSent {
                    successContent
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .scale(scale: 0.95)),
                            removal: .opacity
                        ))
                } else {
                    formContent
                        .transition(.opacity)
                }
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle("Lupa Password")
        .navigationBarTitleDisplayMode(.inline)
        .scrollDismissesKeyboard(.interactively)
        .animation(.easeInOut(duration: 0.35), value: emailSent)
        .onChange(of: email) { auth.errorMessage = nil }
    }

    // MARK: Form

    private var formContent: some View {
        VStack(spacing: 0) {
            AuthHeader(
                icon: "lock.rotation",
                title: "Lupa Password?",
                subtitle: "Masukkan email yang terdaftar dan kami akan mengirimkan link reset password."
            )
            .padding(.top, 40)
            .padding(.bottom, 32)

            AuthTextField(
                placeholder: "Email",
                systemImage: "envelope",
                text: $email,
                keyboardType: .emailAddress,
                autocapitalization: .never,
                isFocused: isEmailFocused
            )
            .focused($isEmailFocused)
            .submitLabel(.send)
            .onSubmit { sendReset() }
            .textContentType(.emailAddress)

            if let message = auth.errorMessage {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text(message)
                }
                .font(.subheadline)
                .foregroundStyle(.red)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 12)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }

            PrimaryButton(
                title: "Kirim Link Reset",
                isLoading: auth.isLoading,
                isDisabled: !email.contains("@")
            ) {
                sendReset()
            }
            .padding(.top, 24)

            Button("Kembali ke Login") {
                dismiss()
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .padding(.top, 16)
            .padding(.bottom, 48)
        }
    }

    // MARK: Success

    private var successContent: some View {
        VStack(spacing: 24) {
            Spacer().frame(height: 60)

            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.12))
                    .frame(width: 108, height: 108)
                Image(systemName: "envelope.badge.checkmark.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.green)
            }

            VStack(spacing: 10) {
                Text("Email Terkirim!")
                    .font(.title.bold())
                (Text("Link reset password telah dikirim ke ") + Text(email).bold() + Text(". Cek inbox kamu dan ikuti instruksi di dalamnya."))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: 12) {
                PrimaryButton(title: "Kembali ke Login") {
                    dismiss()
                }

                Button("Kirim Ulang") {
                    emailSent = false
                }
                .font(.subheadline)
                .foregroundStyle(Color.brandPrimary)
            }
            .padding(.top, 8)
            .padding(.bottom, 48)
        }
    }

    // MARK: Actions

    private func sendReset() {
        isEmailFocused = false
        Task {
            await auth.sendPasswordReset(email: email.trimmingCharacters(in: .whitespaces))
            if auth.errorMessage == nil {
                emailSent = true
            }
        }
    }
}
