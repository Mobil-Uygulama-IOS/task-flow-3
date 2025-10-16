import SwiftUI

struct CustomTabView: View {
    @State private var selectedTab = 0
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        ZStack {
            // Background - Tema desteği
            themeManager.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
            // Main content based on selected tab
            Group {
                switch selectedTab {
                case 0:
                    ProjectListView()
                        .environmentObject(themeManager)
                case 1:
                    NotificationsView()
                        .environmentObject(themeManager)
                case 2:
                    SettingsView()
                        .environmentObject(themeManager)
                default:
                    ProjectListView()
                        .environmentObject(themeManager)
                }
            }                // Custom Tab Bar
                HStack {
                    // Projeler tab
                    TabBarItem(
                        icon: "list.clipboard.fill",
                        title: "Projeler",
                        isSelected: selectedTab == 0
                    ) {
                        selectedTab = 0
                    }
                    .environmentObject(themeManager)
                    
                    Spacer()
                    
                    // Bildirimler tab
                    TabBarItem(
                        icon: "bell",
                        title: "Bildirimler",
                        isSelected: selectedTab == 1
                    ) {
                        selectedTab = 1
                    }
                    .environmentObject(themeManager)
                    
                    Spacer()
                    
                    // Ayarlar tab
                    TabBarItem(
                        icon: "gearshape",
                        title: "Ayarlar",
                        isSelected: selectedTab == 2
                    ) {
                        selectedTab = 2
                    }
                    .environmentObject(themeManager)
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 16)
                .background(themeManager.cardBackground)
                .overlay(
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundColor(Color.gray.opacity(0.3)),
                    alignment: .top
                )
            }
        }
    }
}

struct TabBarItem: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(isSelected ? .blue : themeManager.secondaryTextColor)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(isSelected ? .blue : themeManager.secondaryTextColor)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Temporary Views
struct NotificationsView: View {
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "bell.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.gray)
                    .padding()
                
                Text("Bildirimler")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(themeManager.textColor)
                
                Text("Henüz bildiriminiz bulunmuyor.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(themeManager.backgroundColor)
            .navigationTitle("Bildirimler")
            .navigationBarHidden(true)
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Ayarlar")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(themeManager.textColor)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                // Settings list
                ScrollView {
                    VStack(spacing: 16) {
                        // User Profile Section
                        if let user = authViewModel.userSession {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Profil Bilgileri")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(themeManager.textColor)
                                    .padding(.horizontal, 20)
                                
                                HStack(spacing: 16) {
                                    Circle()
                                        .fill(Color.blue.opacity(0.2))
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Text(user.displayName?.prefix(1).uppercased() ?? "U")
                                                .font(.title2)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.blue)
                                        )
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(user.displayName ?? "Kullanıcı")
                                            .font(.headline)
                                            .foregroundColor(themeManager.textColor)
                                        
                                        Text(user.email ?? "")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .padding(16)
                                .background(themeManager.cardBackground)
                                .cornerRadius(12)
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // Settings Options
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Uygulama Ayarları")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(themeManager.textColor)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 1) {
                                SettingsRow(icon: "bell", title: "Bildirimler", color: .orange)
                                
                                // Koyu Tema Toggle
                                SettingsToggleRow(
                                    icon: "moon.fill",
                                    title: "Koyu Tema",
                                    color: .purple,
                                    isOn: $themeManager.isDarkMode
                                )
                                
                                SettingsRow(icon: "globe", title: "Dil Ayarları", color: .blue)
                                SettingsRow(icon: "questionmark.circle", title: "Yardım", color: .green)
                                SettingsRow(icon: "info.circle", title: "Hakkında", color: .gray)
                            }
                            .background(themeManager.cardBackground)
                            .cornerRadius(12)
                            .padding(.horizontal, 20)
                        }
                        
                        // Sign out section
                        VStack(spacing: 16) {
                            Button(action: {
                                authViewModel.signOut()
                            }) {
                                HStack {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .font(.title3)
                                        .foregroundColor(.red)
                                    
                                    Text("Çıkış Yap")
                                        .font(.headline)
                                        .foregroundColor(.red)
                                    
                                    Spacer()
                                }
                                .padding(16)
                                .background(themeManager.cardBackground)
                                .cornerRadius(12)
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.top, 20)
                    }
                }
                
                Spacer()
            }
            .background(themeManager.backgroundColor)
        }
        .navigationBarHidden(true)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let color: Color
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        Button(action: {
            // Settings row action
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .frame(width: 24)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(themeManager.textColor)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Settings Toggle Row (Tema için)
struct SettingsToggleRow: View {
    let icon: String
    let title: String
    let color: Color
    @Binding var isOn: Bool
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(title)
                .font(.body)
                .foregroundColor(themeManager.textColor)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.purple)
        }
        .padding(16)
    }
}

// MARK: - Preview
struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView()
            .environmentObject(AuthViewModel())
    }
}