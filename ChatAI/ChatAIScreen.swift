import SwiftUI

struct ChatAIScreen: View {
    @State private var viewModel = ChatAIViewModel()
    @FocusState private var isInputFocused: Bool

    private let fillColor = Color.gray.opacity(0.15)

    var body: some View {
        NavigationStack {
            messagesView
                .background { SurauBackground() }
                .safeAreaInset(edge: .bottom) {
                    AnimatedChatInput(
                        hint: "Tanya sesuatu...",
                        text: $viewModel.inputText,
                        isFocused: $isInputFocused
                    ) {
                        Button { } label: {
                            Image(systemName: "photo")
                                .foregroundStyle(Color.primary)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(fillColor, in: .circle)
                        }

                        Button { } label: {
                            Image(systemName: "camera")
                                .foregroundStyle(Color.primary)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(fillColor, in: .circle)
                        }

                        Button { } label: {
                            Image(systemName: "mic.fill")
                                .foregroundStyle(Color.primary)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(fillColor, in: .circle)
                        }
                    } trailingAction: {
                        Button {
                            if isInputFocused {
                                isInputFocused = false
                            }
                        } label: {
                            ZStack {
                                Image(systemName: "checkmark")
                                    .fontWeight(.medium)
                                    .foregroundStyle(Color.white)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(Color.brandPrimary.gradient, in: .circle)
                                    .blur(radius: isInputFocused ? 0 : 5)
                                    .opacity(isInputFocused ? 1 : 0)

                                Image(systemName: "mic.fill")
                                    .foregroundStyle(Color.primary)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(fillColor, in: .circle)
                                    .blur(radius: !isInputFocused ? 0 : 5)
                                    .opacity(!isInputFocused ? 1 : 0)
                            }
                        }
                    } mainAction: {
                        Button {
                            Task { await viewModel.sendMessage() }
                            isInputFocused = false
                        } label: {
                            Image(systemName: "paperplane.fill")
                                .font(.body)
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(LinearGradient.brand)
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, 10)
                }
                .navigationTitle("Chat AI")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    chatToolbarLeading
                    chatToolbarTrailing
                }
        }
    }

    // MARK: - Toolbar

    @ToolbarContentBuilder
    private var chatToolbarLeading: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                // TODO: show conversation history
            } label: {
                Label("Riwayat", systemImage: "clock.arrow.trianglepath.counterclockwise")
                    .labelStyle(.titleAndIcon)
                    .font(.subheadline.weight(.medium))
            }
        }
    }

    @ToolbarContentBuilder
    private var chatToolbarTrailing: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            if #available(iOS 26, *) {
                glassTrailingButtons
            } else {
                standardTrailingButtons
            }
        }
    }

    @available(iOS 26, *)
    private var glassTrailingButtons: some View {
        HStack(spacing: 4) {
            Button {
                // TODO: save conversation
            } label: {
                Image(systemName: "square.and.arrow.down")
            }
            .glassEffect(.regular.interactive(), in: .circle)

            Button {
                // TODO: star/bookmark conversation
            } label: {
                Image(systemName: "star")
            }
            .glassEffect(.regular.interactive(), in: .circle)

            Button {
                viewModel.reset()
            } label: {
                Image(systemName: "plus")
                    .fontWeight(.semibold)
            }
            .glassEffect(.regular.tint(Color.brandPrimary).interactive(), in: .circle)
        }
    }

    private var standardTrailingButtons: some View {
        HStack(spacing: 4) {
            Button {
                // TODO: save conversation
            } label: {
                Image(systemName: "square.and.arrow.down")
            }

            Button {
                // TODO: star/bookmark conversation
            } label: {
                Image(systemName: "star")
            }

            Button {
                viewModel.reset()
            } label: {
                Image(systemName: "plus")
                    .fontWeight(.semibold)
            }
        }
    }

    // MARK: - Messages

    private var messagesView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.messages) { message in
                        MessageBubble(message: message)
                            .id(message.id)
                    }
                    if viewModel.isTyping {
                        TypingIndicator()
                            .id("typing")
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 8)
            }
            .scrollDismissesKeyboard(.interactively)
            .transaction(value: isInputFocused) { $0.animation = nil }
            .onAppear {
                if let lastID = viewModel.messages.last?.id {
                    proxy.scrollTo(lastID, anchor: .bottom)
                }
            }
            .onChange(of: viewModel.messages.count) {
                if let lastID = viewModel.messages.last?.id {
                    withAnimation(.easeOut(duration: 0.25)) {
                        proxy.scrollTo(lastID, anchor: .bottom)
                    }
                }
            }
            .onChange(of: viewModel.isTyping) {
                guard viewModel.isTyping else { return }
                withAnimation(.easeOut(duration: 0.25)) {
                    proxy.scrollTo("typing", anchor: .bottom)
                }
            }
        }
    }
}

// MARK: - MessageBubble

private struct MessageBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isUser {
                Spacer(minLength: 64)
                bubbleContent
            } else {
                aiAvatarView
                bubbleContent
                Spacer(minLength: 64)
            }
        }
    }

    private var bubbleContent: some View {
        Text(message.content)
            .font(.callout)
            .foregroundStyle(message.isUser ? Color.white : Color.primary)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                message.isUser
                    ? AnyShapeStyle(LinearGradient.brand)
                    : AnyShapeStyle(Color(.secondarySystemBackground)),
                in: UnevenRoundedRectangle(
                    topLeadingRadius: message.isUser ? 18 : 4,
                    bottomLeadingRadius: 18,
                    bottomTrailingRadius: message.isUser ? 4 : 18,
                    topTrailingRadius: 18
                )
            )
    }

    private var aiAvatarView: some View {
        ZStack {
            Circle()
                .fill(LinearGradient.brand)
                .frame(width: 28, height: 28)
            Image(systemName: "sparkles")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.white)
        }
    }
}

// MARK: - TypingIndicator

private struct TypingIndicator: View {
    @State private var animating = false

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ZStack {
                Circle()
                    .fill(LinearGradient.brand)
                    .frame(width: 28, height: 28)
                Image(systemName: "sparkles")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.white)
            }
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .fill(Color.secondary.opacity(0.7))
                        .frame(width: 7, height: 7)
                        .offset(y: animating ? -4 : 0)
                        .animation(
                            .easeInOut(duration: 0.45)
                                .repeatForever(autoreverses: true)
                                .delay(Double(i) * 0.15),
                            value: animating
                        )
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 18, style: .continuous))
            Spacer(minLength: 64)
        }
        .onAppear { animating = true }
    }
}
