import SwiftUI

@Observable
@MainActor
final class BookmarkViewModel {
    var bookmarkedBooks: [BookDisplay] = [
        .init(
            id: 0,
            title: "Al-Quran Al-Karim",
            author: "Wahyu Ilahi",
            category: "Quran",
            coverColor: Color(red: 0.05, green: 0.36, blue: 0.09),
            textColor: .white,
            variant: .simple,
            ratio: .b5,
            isRtl: false,
            isTextured: true,
            synopsis: "Al-Quran adalah kitab suci umat Islam yang diturunkan kepada Nabi Muhammad SAW melalui malaikat Jibril selama 23 tahun. Terdiri dari 114 surah dan 6.236 ayat, Al-Quran mencakup petunjuk hidup, hukum syariat, kisah para nabi, dan akidah Islam.",
            pages: 604,
            publishYear: 610,
            language: "Arab"
        ),
        .init(
            id: 3,
            title: "Hadis Arbain Nawawi",
            author: "Imam Nawawi",
            category: "Hadis",
            coverColor: Color(red: 0.29, green: 0.12, blue: 0.55),
            textColor: .white,
            variant: .simple,
            ratio: .novel,
            isRtl: false,
            isTextured: true,
            synopsis: "Kitab Al-Arba'in Al-Nawawiyah memuat 42 hadis yang dipilih dengan cermat oleh Imam Nawawi sebagai fondasi ajaran Islam. Setiap hadis merupakan kaidah penting dalam agama, mencakup niat, keimanan, halal-haram, hingga etika bermasyarakat.",
            pages: 88,
            publishYear: 1260,
            language: "Arab"
        ),
        .init(
            id: 5,
            title: "Tafsir Ibnu Katsir",
            author: "Ibnu Katsir",
            category: "Tafsir",
            coverColor: Color(red: 0.06, green: 0.35, blue: 0.25),
            textColor: .white,
            variant: .simple,
            ratio: .a4,
            isRtl: false,
            isTextured: true,
            synopsis: "Tafsir Al-Quran Al-Azim karya Ibnu Katsir adalah salah satu tafsir paling otoritatif dalam tradisi Islam. Menggunakan metode tafsir bil-ma'tsur, beliau menjelaskan setiap ayat dengan ayat lain, hadis sahih, dan pendapat sahabat.",
            pages: 2400,
            publishYear: 1370,
            language: "Arab"
        ),
    ]

    func remove(_ book: BookDisplay) {
        bookmarkedBooks.removeAll { $0.id == book.id }
    }
}
