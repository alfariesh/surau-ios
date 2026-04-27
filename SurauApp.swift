import SwiftUI

@main
struct SurauApp: App {
    @State private var auth = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(auth)
        }
    }
}
