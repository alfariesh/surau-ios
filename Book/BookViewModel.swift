import SwiftUI

// MARK: - AuthorDetail

struct AuthorDetail: Hashable, Identifiable {
    var id: String { name }
    let name: String
    let nationality: String
    let bornYear: Int?
    let diedYear: Int?
    let bio: String
}

// MARK: - BookDisplay

struct BookDisplay: Identifiable, Hashable {
    let id: Int
    let title: String
    let author: String
    let category: String
    let coverColor: Color
    let textColor: Color
    let variant: GeistBookVariant
    let ratio: GeistBookRatio
    let isRtl: Bool
    let isTextured: Bool
    let synopsis: String
    let pages: Int
    let publishYear: Int
    let language: String
}

// MARK: - ViewModel

@Observable
@MainActor
final class BookViewModel {
    private(set) var allBooks: [BookDisplay] = []
    private(set) var categories: [String] = []
    var selectedCategory = "Semua"

    var filteredBooks: [BookDisplay] {
        selectedCategory == "Semua" ? allBooks : allBooks.filter { $0.category == selectedCategory }
    }

    init() {
        allBooks = Self.sampleBooks
        categories = ["Semua"] + Array(Set(allBooks.map(\.category))).sorted()
    }

    func selectCategory(_ category: String) {
        selectedCategory = category
    }

    func books(by authorName: String) -> [BookDisplay] {
        allBooks.filter { $0.author == authorName }
    }

    // MARK: - Author Details

    static let authorDetails: [String: AuthorDetail] = [
        "Imam Nawawi": AuthorDetail(
            name: "Imam Nawawi",
            nationality: "Suriah",
            bornYear: 1233,
            diedYear: 1277,
            bio: "Yahya ibn Sharaf al-Nawawi adalah ulama besar mazhab Syafi'i. Beliau menguasai hadis, fiqh, dan bahasa Arab sejak usia muda. Seluruh hidupnya didedikasikan untuk ilmu dan ibadah, tidak menikah, dan menghasilkan puluhan karya monumental yang masih dipelajari hingga hari ini."
        ),
        "Sayyid Sabiq": AuthorDetail(
            name: "Sayyid Sabiq",
            nationality: "Mesir",
            bornYear: 1915,
            diedYear: 2000,
            bio: "Muhammad Sayyid Sabiq adalah ulama Mesir yang dikenal lewat karyanya Fiqh al-Sunnah. Beliau menempuh pendidikan di Al-Azhar dan menjadi salah satu ulama terkemuka di abad ke-20, dengan pendekatan fiqh yang mudah dipahami oleh kalangan luas."
        ),
        "Ibnu Katsir": AuthorDetail(
            name: "Ibnu Katsir",
            nationality: "Suriah",
            bornYear: 1301,
            diedYear: 1373,
            bio: "Ismail ibn Umar ibn Kathir adalah seorang mufassir, muhaddis, dan sejarawan Islam. Murid langsung Ibnu Taimiyah ini menghasilkan tafsir Al-Quran paling terkenal dalam sejarah, yang merupakan referensi utama para ulama hingga saat ini."
        ),
        "Ibnu Hisyam": AuthorDetail(
            name: "Ibnu Hisyam",
            nationality: "Mesir",
            bornYear: nil,
            diedYear: 833,
            bio: "Abu Muhammad Abdul Malik ibn Hisyam adalah seorang ulama dan ahli bahasa Arab dari Basra. Beliau dikenal karena menyempurnakan dan mengedit biografi Nabi Muhammad SAW karya Ibnu Ishaq, yang kemudian dikenal sebagai Sirah Ibnu Hisyam."
        ),
        "Imam Bukhari": AuthorDetail(
            name: "Imam Bukhari",
            nationality: "Uzbekistan",
            bornYear: 810,
            diedYear: 870,
            bio: "Muhammad ibn Ismail al-Bukhari adalah imam hadis terbesar sepanjang masa. Lahir di Bukhara, beliau menghabiskan 16 tahun untuk mengumpulkan dan memverifikasi 600.000 hadis, lalu memilih 7.275 hadis paling sahih dalam Shahih al-Bukhari."
        ),
        "Imam Al-Ghazali": AuthorDetail(
            name: "Imam Al-Ghazali",
            nationality: "Persia",
            bornYear: 1058,
            diedYear: 1111,
            bio: "Abu Hamid Muhammad al-Ghazali, digelari Hujjatul Islam (Bukti Kebenaran Islam), adalah filsuf, teolog, dan sufi terbesar Islam. Beliau mengajar di Nizamiyah Baghdad sebelum meninggalkan jabatan untuk bertafakur dan menulis Ihya Ulumuddin yang monumental."
        ),
    ]

    // MARK: - Sample Data

    private static let sampleBooks: [BookDisplay] = [
        .init(
            id: 0,
            title: "Al-Quran Al-Karim",
            author: "Wahyu Ilahi",
            category: "Quran",
            coverColor: Color(red: 0.05, green: 0.36, blue: 0.09),
            textColor: .white,
            variant: .simple, ratio: .b5, isRtl: false, isTextured: true,
            synopsis: "Al-Quran adalah kitab suci umat Islam yang diturunkan kepada Nabi Muhammad SAW melalui malaikat Jibril selama 23 tahun. Terdiri dari 114 surah dan 6.236 ayat, Al-Quran mencakup petunjuk hidup, hukum syariat, kisah para nabi, dan akidah Islam. Ia menjadi sumber utama hukum Islam dan panduan moral bagi seluruh umat manusia.",
            pages: 604,
            publishYear: 610,
            language: "Arab"
        ),
        .init(
            id: 1,
            title: "القرآن الكريم",
            author: "المصحف الشريف",
            category: "Quran",
            coverColor: Color(red: 0.85, green: 0.69, blue: 0.05),
            textColor: Color(white: 0.1),
            variant: .simple, ratio: .b5, isRtl: true, isTextured: true,
            synopsis: "القرآن الكريم هو كلام الله المنزَّل على النبي محمد ﷺ بواسطة جبريل عليه السلام، المتعبَّد بتلاوته، المنقول بالتواتر، المبدوء بسورة الفاتحة والمختوم بسورة الناس. يشتمل على مئة وأربع عشرة سورة وستة آلاف ومئتين وست وثلاثين آية.",
            pages: 604,
            publishYear: 610,
            language: "العربية"
        ),
        .init(
            id: 2,
            title: "Riyadhus Shalihin",
            author: "Imam Nawawi",
            category: "Hadis",
            coverColor: Color(red: 0.49, green: 0.07, blue: 0.12),
            textColor: .white,
            variant: .stripe, ratio: .b5, isRtl: false, isTextured: false,
            synopsis: "Riyadhus Shalihin (Taman Orang-orang Saleh) adalah kitab hadis yang memuat sekitar 1.900 hadis sahih pilihan Imam Nawawi. Disusun secara tematik meliputi akhlak, ibadah, muamalah, dan adab kehidupan sehari-hari Muslim. Kitab ini menjadi salah satu rujukan hadis paling populer dan mudah dipahami di seluruh dunia.",
            pages: 596,
            publishYear: 1272,
            language: "Arab"
        ),
        .init(
            id: 3,
            title: "Hadis Arbain Nawawi",
            author: "Imam Nawawi",
            category: "Hadis",
            coverColor: Color(red: 0.29, green: 0.12, blue: 0.55),
            textColor: .white,
            variant: .simple, ratio: .novel, isRtl: false, isTextured: true,
            synopsis: "Kitab Al-Arba'in Al-Nawawiyah memuat 42 hadis yang dipilih dengan cermat oleh Imam Nawawi sebagai fondasi ajaran Islam. Setiap hadis merupakan kaidah penting dalam agama, mencakup niat, keimanan, halal-haram, hingga etika bermasyarakat. Menjadi materi wajib kajian dasar Islam di seluruh dunia.",
            pages: 88,
            publishYear: 1260,
            language: "Arab"
        ),
        .init(
            id: 4,
            title: "Fiqh Sunnah",
            author: "Sayyid Sabiq",
            category: "Fiqh",
            coverColor: Color(red: 0.04, green: 0.25, blue: 0.57),
            textColor: .white,
            variant: .stripe, ratio: .b5, isRtl: false, isTextured: false,
            synopsis: "Fiqh al-Sunnah adalah ensiklopedia fiqh Islam yang komprehensif karya Sayyid Sabiq. Membahas seluruh aspek ibadah dan muamalah berdasarkan dalil Al-Quran dan hadis sahih, dengan bahasa yang mudah dipahami. Buku ini menjadi referensi standar fiqh modern yang diakui oleh para ulama dari berbagai mazhab.",
            pages: 1200,
            publishYear: 1945,
            language: "Arab"
        ),
        .init(
            id: 5,
            title: "Tafsir Ibnu Katsir",
            author: "Ibnu Katsir",
            category: "Tafsir",
            coverColor: Color(red: 0.06, green: 0.35, blue: 0.25),
            textColor: .white,
            variant: .simple, ratio: .a4, isRtl: false, isTextured: true,
            synopsis: "Tafsir Al-Quran Al-Azim karya Ibnu Katsir adalah salah satu tafsir paling otoritatif dalam tradisi Islam. Menggunakan metode tafsir bil-ma'tsur (berdasarkan riwayat), beliau menjelaskan setiap ayat dengan ayat lain, hadis sahih, dan pendapat sahabat. Hingga kini menjadi rujukan utama para mufassir dan pelajar ilmu Al-Quran.",
            pages: 2400,
            publishYear: 1370,
            language: "Arab"
        ),
        .init(
            id: 6,
            title: "Sirah Nabawiyah",
            author: "Ibnu Hisyam",
            category: "Sirah",
            coverColor: Color(red: 0.55, green: 0.27, blue: 0.07),
            textColor: .white,
            variant: .stripe, ratio: .tradePaperback, isRtl: false, isTextured: false,
            synopsis: "Sirah Nabawiyah Ibnu Hisyam adalah biografi Nabi Muhammad SAW yang paling lengkap dan terpercaya. Bersumber dari karya Ibnu Ishaq yang disempurnakan, kitab ini menceritakan kehidupan Rasulullah dari kelahiran hingga wafat, meliputi peperangan, dakwah, dan pembentukan masyarakat Islam pertama.",
            pages: 880,
            publishYear: 828,
            language: "Arab"
        ),
        .init(
            id: 7,
            title: "صحيح البخاري",
            author: "Imam Bukhari",
            category: "Hadis",
            coverColor: Color(red: 0.40, green: 0.12, blue: 0.22),
            textColor: .white,
            variant: .simple, ratio: .b5, isRtl: true, isTextured: true,
            synopsis: "الجامع المسند الصحيح المختصر من أمور رسول الله ﷺ وسننه وأيامه، المعروف بصحيح البخاري، هو أصح كتب الحديث وأعظمها. جمعه الإمام البخاري من ستمئة ألف حديث واختار منها سبعة آلاف ومئتين وخمسة وسبعين حديثاً بعد ستة عشر عاماً من البحث والتمحيص.",
            pages: 1560,
            publishYear: 846,
            language: "العربية"
        ),
        .init(
            id: 8,
            title: "Aqidah Ahlussunnah",
            author: "Imam Al-Ghazali",
            category: "Aqidah",
            coverColor: Color(red: 0.12, green: 0.22, blue: 0.45),
            textColor: .white,
            variant: .stripe, ratio: .b5, isRtl: false, isTextured: false,
            synopsis: "Kitab ini memaparkan pokok-pokok akidah Ahlussunnah wal Jamaah secara sistematis dan argumentatif. Imam Al-Ghazali menjelaskan sifat-sifat Allah, kenabian, dan hari akhir dengan dalil naqli dan aqli yang kuat, membantah berbagai aliran sesat, dan memperkuat fondasi keimanan umat Islam.",
            pages: 240,
            publishYear: 1095,
            language: "Arab"
        ),
        .init(
            id: 9,
            title: "Ihya Ulumuddin",
            author: "Imam Al-Ghazali",
            category: "Tasawuf",
            coverColor: Color(red: 0.35, green: 0.20, blue: 0.08),
            textColor: .white,
            variant: .simple, ratio: .novel, isRtl: false, isTextured: true,
            synopsis: "Ihya Ulumuddin (Menghidupkan Ilmu Agama) adalah mahakarya Al-Ghazali yang memadukan fiqh, akidah, dan tasawuf secara harmonis. Dibagi dalam empat bagian — ibadah, adat, perkara yang membinasakan, dan perkara yang menyelamatkan — kitab ini membimbing Muslim menuju kesempurnaan spiritual dan moral.",
            pages: 1770,
            publishYear: 1097,
            language: "Arab"
        ),
    ]
}
