import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("Chat AI", systemImage: "bubble.left.and.bubble.right.fill") {
                ChatAIScreen()
            }
            Tab("Buku", systemImage: "books.vertical.fill") {
                BookScreen()
            }
            Tab("Bookmark", systemImage: "bookmark.fill") {
                BookmarkScreen()
            }
            Tab("Profil", systemImage: "person.fill") {
                ProfileScreen()
            }
        }
        .tint(.brandPrimary)
    }
}
