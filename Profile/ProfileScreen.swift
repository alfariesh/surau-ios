import SwiftUI

struct ProfileScreen: View {
    @Environment(AuthViewModel.self) private var auth

    var body: some View {
        NavigationStack {
            List {
                profileHeaderSection
                statsSection
                settingsSection
                signOutSection
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Sections

    private var profileHeaderSection: some View {
        Section {
            HStack(spacing: 16) {
                avatarView
                VStack(alignment: .leading, spacing: 4) {
                    Text("Pengguna Surau")
                        .font(.headline)
                    Text("demo@surau.app")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 8)
        }
    }

    private var statsSection: some View {
        Section {
            HStack(spacing: 0) {
                StatItem(value: "12", label: "Dibaca")
                Divider()
                StatItem(value: "3", label: "Bookmark")
                Divider()
                StatItem(value: "7", label: "Hari Aktif")
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
        }
    }

    private var settingsSection: some View {
        Section("Pengaturan") {
            SettingsRow(icon: "bell.fill", color: .brandPrimary, label: "Notifikasi")
            SettingsRow(icon: "globe", color: .brandSecondary, label: "Bahasa")
            SettingsRow(icon: "info.circle.fill", color: .brandPrimary, label: "Tentang Surau")
            SettingsRow(icon: "questionmark.circle.fill", color: .brandSecondary, label: "Bantuan & Dukungan")
        }
    }

    private var signOutSection: some View {
        Section {
            Button(role: .destructive) {
                auth.signOut()
            } label: {
                HStack {
                    Spacer()
                    Label("Keluar", systemImage: "rectangle.portrait.and.arrow.right")
                    Spacer()
                }
            }
        }
    }

    // MARK: - Avatar

    private var avatarView: some View {
        ZStack {
            Circle()
                .fill(LinearGradient.brand)
                .frame(width: 64, height: 64)
            Text("S")
                .font(.title.bold())
                .foregroundStyle(.white)
        }
    }
}

// MARK: - Subviews

private struct StatItem: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2.bold())
                .foregroundStyle(Color.brandPrimary)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct SettingsRow: View {
    let icon: String
    let color: Color
    let label: String

    var body: some View {
        Label {
            Text(label)
        } icon: {
            Image(systemName: icon)
                .foregroundStyle(.white)
                .frame(width: 28, height: 28)
                .background(color, in: .rect(cornerRadius: 6))
        }
    }
}
