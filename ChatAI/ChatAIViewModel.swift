import SwiftUI

struct ChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp: Date
}

@Observable
@MainActor
final class ChatAIViewModel {
    var messages: [ChatMessage] = [
        ChatMessage(
            content: "Assalamu'alaikum warahmatullahi wabarakatuh 🌙\n\nSaya asisten AI Surau. Silakan tanyakan seputar Islam, Al-Qur'an, hadis, fiqh, atau ilmu agama lainnya.",
            isUser: false,
            timestamp: .now
        )
    ]
    var inputText = ""
    var isTyping = false

    func sendMessage() async {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        inputText = ""
        messages.append(ChatMessage(content: text, isUser: true, timestamp: .now))

        isTyping = true
        try? await Task.sleep(for: .seconds(1.5))
        isTyping = false

        messages.append(ChatMessage(
            content: "Barakallahu fiik atas pertanyaannya. Fitur AI sedang dalam pengembangan dan akan segera terhubung ke model bahasa besar untuk memberikan jawaban berdasarkan Al-Qur'an dan hadis sahih. Insya Allah segera hadir! 🤲",
            isUser: false,
            timestamp: .now
        ))
    }

    func reset() {
        inputText = ""
        messages = [
            ChatMessage(
                content: "Assalamu'alaikum warahmatullahi wabarakatuh 🌙\n\nSaya asisten AI Surau. Silakan tanyakan seputar Islam, Al-Qur'an, hadis, fiqh, atau ilmu agama lainnya.",
                isUser: false,
                timestamp: .now
            )
        ]
    }
}
