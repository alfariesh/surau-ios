import SwiftUI

// MARK: - Screen

struct BookScreen: View {
    @State private var viewModel = BookViewModel()
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 4) {
                    DemoSection("Rasio") { RatiosShowcase() }
                    DemoSection("Variant") { VariantsShowcase() }
                    DemoSection("Tekstur") { TexturedShowcase() }
                    DemoSection("Ilustrasi Kustom") { IllustrationShowcase() }
                    DemoSection("RTL (Arab)") { RtlShowcase() }
                    DemoSection("Perpustakaan") {
                        LibraryGrid(books: viewModel.filteredBooks)
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
            .navigationTitle("Buku")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cari", systemImage: "magnifyingglass") {}
                }
            }
            .navigationDestination(for: BookDisplay.self) { book in
                BookDetailScreen(book: book)
            }
            .navigationDestination(for: AuthorDetail.self) { author in
                AuthorDetailScreen(author: author)
            }
        }
    }
}

// MARK: - Section wrapper

private struct DemoSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    init(_ title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.headline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            content()
        }
    }
}

// MARK: - Showcases

private struct RatiosShowcase: View {
    private let ratios: [(String, GeistBookRatio)] = [
        ("Geist 49:60", .geist),
        ("B5", .b5),
        ("A4", .a4),
        ("Novel 5:7", .novel),
        ("Trade 6:9", .tradePaperback),
        ("Kotak 1:1", .square),
    ]
    var body: some View {
        HorizontalScrollRow {
            ForEach(ratios, id: \.0) { label, ratio in
                LabeledBook(label) {
                    GeistBook(
                        title: "Pengalaman Pengguna Cloud",
                        color: .geistAmber600,
                        width: 110,
                        ratio: ratio
                    )
                }
            }
        }
    }
}

private struct VariantsShowcase: View {
    var body: some View {
        HorizontalScrollRow {
            LabeledBook("Stripe") {
                GeistBook(title: "Desain di Vercel", color: Color(red: 0.49, green: 0.76, blue: 0.76), variant: .stripe, width: 130)
            }
            LabeledBook("Simple") {
                GeistBook(title: "Desain di Vercel", color: Color(red: 0.49, green: 0.76, blue: 0.76), textColor: .white, variant: .simple, width: 130)
            }
            LabeledBook("Image") {
                GeistBook(
                    title: "Desain di Vercel",
                    textColor: .white,
                    variant: .image,
                    width: 130
                ) {
                    LinearGradient(
                        colors: [Color(red: 1.0, green: 0.60, blue: 0.55), Color(red: 0.61, green: 0.15, blue: 0.69), Color(red: 0.10, green: 0.10, blue: 0.18)],
                        startPoint: .top, endPoint: .bottom
                    )
                }
            }
        }
    }
}

private struct TexturedShowcase: View {
    var body: some View {
        HorizontalScrollRow {
            LabeledBook("Stripe biasa") {
                GeistBook(title: "Pengalaman Pengguna", color: Color(red: 0.996, green: 0.851, blue: 0.329), width: 130)
            }
            LabeledBook("Stripe bertekstur") {
                GeistBook(title: "Pengalaman Pengguna", color: Color(red: 0.996, green: 0.851, blue: 0.329), textured: true, width: 130)
            }
            LabeledBook("Simple bertekstur") {
                GeistBook(title: "Desain di Vercel", color: Color(red: 0.62, green: 0.13, blue: 0.15), textColor: .white, variant: .simple, textured: true, width: 130)
            }
        }
    }
}

private struct IllustrationShowcase: View {
    var body: some View {
        HorizontalScrollRow {
            LabeledBook("Garis") {
                GeistBook(title: "Pengalaman Pengguna", color: .geistAmber600, width: 130) {
                    Canvas { ctx, size in
                        ctx.stroke(
                            Path { p in
                                p.move(to: CGPoint(x: 0, y: size.height / 2))
                                p.addLine(to: CGPoint(x: size.width, y: size.height / 2))
                            },
                            with: .color(.black.opacity(0.7)),
                            lineWidth: 3
                        )
                    }
                    .frame(width: 48, height: 48)
                }
            }
            LabeledBook("Ikon bulat") {
                GeistBook(
                    title: "Desain di Vercel",
                    color: Color(red: 0.49, green: 0.76, blue: 0.76),
                    textColor: .white,
                    variant: .simple,
                    width: 130
                ) {
                    Circle()
                        .fill(.white.opacity(0.9))
                        .frame(width: 32, height: 32)
                }
            }
        }
    }
}

private struct RtlShowcase: View {
    var body: some View {
        HorizontalScrollRow {
            LabeledBook("Simple RTL") {
                GeistBook(
                    title: "القرآن الكريم",
                    color: Color(red: 0.11, green: 0.37, blue: 0.13),
                    textColor: .white,
                    variant: .simple,
                    textured: true,
                    width: 130,
                    rtl: true
                )
            }
            LabeledBook("Stripe RTL") {
                GeistBook(
                    title: "صحيح البخاري",
                    color: Color(red: 0.53, green: 0.06, blue: 0.31),
                    textColor: .white,
                    width: 130,
                    rtl: true
                )
            }
            LabeledBook("Image RTL") {
                GeistBook(
                    title: "رياض الصالحين",
                    textColor: .white,
                    variant: .image,
                    width: 130,
                    rtl: true
                ) {
                    LinearGradient(
                        colors: [Color(red: 0.05, green: 0.28, blue: 0.63), Color(red: 0.29, green: 0.08, blue: 0.55)],
                        startPoint: .top, endPoint: .bottom
                    )
                }
            }
        }
    }
}

// MARK: - Library

private struct LibraryGrid: View {
    let books: [BookDisplay]

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(books) { book in
                NavigationLink(value: book) {
                    BookCell(book: book)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 4)
    }
}

private struct BookCell: View {
    let book: BookDisplay

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
                    .lineLimit(2)
                Text(book.author)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
    }

    // Fill half the screen minus padding and gap
    @ScaledMetric private var bookWidth: CGFloat = 130
}

// MARK: - Shared layout helpers

private struct HorizontalScrollRow<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 16) {
                content()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}

private struct LabeledBook<Content: View>: View {
    let label: String
    @ViewBuilder let content: () -> Content

    init(_ label: String, @ViewBuilder content: @escaping () -> Content) {
        self.label = label
        self.content = content
    }

    var body: some View {
        VStack(spacing: 8) {
            content()
            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
        }
    }
}
