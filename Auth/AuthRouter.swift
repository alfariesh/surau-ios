import SwiftUI

enum AuthRoute: Hashable {
    case signUp
    case forgotPassword
}

struct AuthRouter: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            LoginView(path: $path)
                .navigationDestination(for: AuthRoute.self) { route in
                    switch route {
                    case .signUp:
                        SignUpView(path: $path)
                    case .forgotPassword:
                        ForgotPasswordView()
                    }
                }
        }
    }
}
