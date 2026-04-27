import SwiftUI

struct BookmarkScreen: View {
    @State private var viewModel = BookmarkViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.bookmarkedBooks.isEmpty {
                    emptyState
                } else {
                    bookGrid
                }
            }
            .navigationTitle("Bookmark")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: BookDisplay.self) { book in
                BookDetailScreen(book: book)
            }
            .navigationDestination(for: AuthorDetail.self) { author in
                AuthorDetailScreen(author: author)
            }
        }
    }

    private var bookGrid: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                spacing: 16
            ) {
                ForEach(viewModel.bookmarkedBooks) { book in
                    NavigationLink(value: book) {
                        BookmarkCell(book: book)
                    }
                    .contextMenu {
                        Button(role: .destructive) {
                            withAnimation(.spring(duration: 0.3)) {
                                viewModel.remove(book)
                            }
                        } label: {
                            Label("Hapus Bookmark", systemImage: "bookmark.slash")
                        }
                    }
                }
            }
            .padding(16)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "bookmark.slash")
                .font(.system(size: 56))
                .foregroundStyle(.secondary)
            Text("Belum Ada Bookmark")
                .font(.title3.weight(.semibold))
            Text("Tekan lama buku di mana saja\nuntuk menambahkan bookmark.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Cell

private struct BookmarkCell: View {
    let book: BookDisplay
    @ScaledMetric private var bookWidth: CGFloat = 130

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            GeistBook(
                title: book.title,
                color: book.coverColor,
                textColor: book.textColor,
                variant: book.variant,
                textured: book.isTextured,
                width: bookWidth,
                ratio: book.ratio,
                rtl: book.isRtl
            )
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: 2) {
                Text(book.title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                Text(book.author)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                Text(book.category)
                    .font(.caption2)
                    .foregroundStyle(Color.brandPrimary)
                    .lineLimit(1)
            }
        }
    }
}
