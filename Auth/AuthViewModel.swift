import SwiftUI

@Observable
@MainActor
final class AuthViewModel {
    var isAuthenticated = false
    var isLoading = false
    var errorMessage: String?

    func login(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        try? await Task.sleep(for: .seconds(1.5))

        // Replace with real auth service (Firebase, Supabase, etc.)
        if email.lowercased() == "demo@surau.app" && password == "password123" {
            isAuthenticated = true
        } else {
            errorMessage = "Email atau password salah. Coba lagi."
        }
    }

    func signUp(name: String, email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        try? await Task.sleep(for: .seconds(1.5))

        // Replace with real registration logic
        isAuthenticated = true
    }

    func sendPasswordReset(email: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        try? await Task.sleep(for: .seconds(1.5))

        // Replace with real password reset logic.
        // Set errorMessage here if the request fails.
    }

    func signInWithApple() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        try? await Task.sleep(for: .seconds(1))
        // Replace with ASAuthorizationAppleIDRequest
        isAuthenticated = true
    }

    func signInWithGoogle() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        try? await Task.sleep(for: .seconds(1))
        // Replace with Google Sign-In SDK
        isAuthenticated = true
    }

    func signOut() {
        isAuthenticated = false
        errorMessage = nil
    }
}
