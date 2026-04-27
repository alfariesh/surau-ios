import SwiftUI

struct BookDetailScreen: View {
    let book: BookDisplay
    @State private var bookVM = BookViewModel()
    @State private var isBookmarked = false

    private var relatedBooks: [BookDisplay] {
        bookVM.allBooks.filter { $0.author == book.author && $0.id != book.id }
    }

    private var authorDetail: AuthorDetail? {
        BookViewModel.authorDetails[book.author]
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                coverHeader
                detailContent
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isBookmarked.toggle()
                } label: {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }
                .sensoryFeedback(.selection, trigger: isBookmarked)
            }
        }
    }

    // MARK: - Cover header

    private var coverHeader: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(
                colors: [book.coverColor, book.coverColor.opacity(0.85)],
                startPoint: .top,
                endPoint: .bottom
            )

            GeistBook(
                title: book.title,
                color: book.coverColor,
                textColor: book.textColor,
                variant: book.variant,
                textured: book.isTextured,
                width: 164,
                ratio: book.ratio,
                rtl: book.isRtl
            )
            .shadow(color: .black.opacity(0.3), radius: 28, x: 0, y: 14)
            .padding(.top, 80)
            .padding(.bottom, 36)
        }
        .frame(minHeight: 340)
    }

    // MARK: - Detail content

    private var detailContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            titleSection
                .padding(.horizontal, 20)
                .padding(.top, 24)

            metadataRow
                .padding(.horizontal, 20)
                .padding(.top, 20)

            synopsisSection
                .padding(.horizontal, 20)
                .padding(.top, 24)

            if !relatedBooks.isEmpty {
                relatedSection
                    .padding(.top, 28)
            }
        }
        .padding(.bottom, 48)
        .background(Color(.systemBackground))
    }

    // MARK: - Title & author

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(book.title)
                .font(.title2.bold())
                .environment(\.layoutDirection, book.isRtl ? .rightToLeft : .leftToRight)

            if let author = authorDetail {
                NavigationLink(value: author) {
                    HStack(spacing: 4) {
                        Text(book.author)
                            .font(.callout.weight(.medium))
                            .foregroundStyle(Color.brandPrimary)
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color.brandPrimary)
                    }
                }
            } else {
                Text(book.author)
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }

            Text(book.category)
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.brandPrimary)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.brandPrimary.opacity(0.12), in: .capsule)
        }
    }

    // MARK: - Metadata row

    private var metadataRow: some View {
        HStack(spacing: 12) {
            MetaCard(icon: "doc.text.fill", value: "\(book.pages)", label: "Halaman")
            MetaCard(icon: "calendar", value: "\(book.publishYear)", label: "Terbit")
            MetaCard(icon: "globe", value: book.language, label: "Bahasa")
        }
    }

    // MARK: - Synopsis

    private var synopsisSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Sinopsis")
                .font(.headline)
            Text(book.synopsis)
                .font(.callout)
                .foregroundStyle(.secondary)
                .lineSpacing(5)
        }
    }

    // MARK: - Related books

    private var relatedSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Karya Lain dari Penulis")
                .font(.headline)
                .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(relatedBooks) { related in
                        NavigationLink(value: related) {
                            VStack(alignment: .leading, spacing: 6) {
                                GeistBook(
                                    title: related.title,
                                    color: related.coverColor,
                                    textColor: related.textColor,
                                    variant: related.variant,
                                    textured: related.isTextured,
                                    width: 96,
                                    ratio: related.ratio,
                                    rtl: related.isRtl
                                )
                                Text(related.title)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.primary)
                                    .lineLimit(2)
                                    .frame(width: 96, alignment: .leading)
                                Text(related.category)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 4)
            }
        }
    }
}

// MARK: - MetaCard

private struct MetaCard: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Color.brandPrimary)
            Text(value)
                .font(.callout.weight(.bold))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 14, style: .continuous))
    }
}
