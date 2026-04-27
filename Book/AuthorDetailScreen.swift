import SwiftUI

struct AuthorDetailScreen: View {
    let author: AuthorDetail
    @State private var bookVM = BookViewModel()
    @ScaledMetric private var bookWidth: CGFloat = 130

    private var authorBooks: [BookDisplay] {
        bookVM.allBooks.filter { $0.author == author.name }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                authorHeader
                    .padding(.horizontal, 20)
                    .padding(.top, 32)

                if !authorBooks.isEmpty {
                    booksGrid
                        .padding(.top, 32)
                }
            }
            .padding(.bottom, 48)
        }
        .navigationTitle(author.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Header

    private var authorHeader: some View {
        VStack(spacing: 20) {
            avatarView

            VStack(spacing: 6) {
                Text(author.name)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)

                HStack(spacing: 6) {
                    Label(author.nationality, systemImage: "mappin.circle.fill")
                        .foregroundStyle(.secondary)

                    if let born = author.bornYear {
                        Text("·")
                            .foregroundStyle(.secondary)
                        Text(lifespan(born: born, died: author.diedYear))
                            .foregroundStyle(.secondary)
                    }
                }
                .font(.callout)
            }

            Text(author.bio)
                .font(.callout)
                .foregroundStyle(.secondary)
                .lineSpacing(5)
                .multilineTextAlignment(.center)
        }
    }

    private var avatarView: some View {
        ZStack {
            Circle()
                .fill(LinearGradient.brand)
                .frame(width: 100, height: 100)
                .shadow(color: Color.brandPrimary.opacity(0.35), radius: 20, x: 0, y: 8)
            Text(initials)
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
        }
    }

    // MARK: - Books grid

    private var booksGrid: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Karya")
                .font(.headline)
                .padding(.horizontal, 20)

            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                spacing: 16
            ) {
                ForEach(authorBooks) { book in
                    NavigationLink(value: book) {
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
                                Text(book.category)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Helpers

    private var initials: String {
        author.name
            .components(separatedBy: " ")
            .prefix(2)
            .compactMap { $0.first.map(String.init) }
            .joined()
    }

    private func lifespan(born: Int, died: Int?) -> String {
        if let died { return "\(born) – \(died) M" }
        return "L. \(born) M"
    }
}
