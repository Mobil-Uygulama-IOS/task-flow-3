import SwiftUI

struct CustomTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            // Background
            Color(.systemGray6)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Main content based on selected tab
                Group {
                    switch selectedTab {
                    case 0:
                        ProjectDashboardView()
                    case 1:
                        NotificationsView()
                    case 2:
                        SettingsView()
                    default:
                        ProjectDashboardView()
                    }
                }
                
                // Custom Tab Bar
                HStack {
                    // Projeler tab
                    TabBarItem(
                        icon: "list.clipboard.fill",
                        title: "Projeler",
                        isSelected: selectedTab == 0
                    ) {
                        selectedTab = 0
                    }
                    
                    Spacer()
                    
                    // Bildirimler tab
                    TabBarItem(
                        icon: "bell",
                        title: "Bildirimler",
                        isSelected: selectedTab == 1
                    ) {
                        selectedTab = 1
                    }
                    
                    Spacer()
                    
                    // Ayarlar tab
                    TabBarItem(
                        icon: "gearshape",
                        title: "Ayarlar",
                        isSelected: selectedTab == 2
                    ) {
                        selectedTab = 2
                    }
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 16)
                .background(Color(.systemBackground))
                .overlay(
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundColor(Color(.separator)),
                    alignment: .top
                )
            }
        }
    }
}

struct TabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(isSelected ? .blue : .gray)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(isSelected ? .blue : .gray)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Temporary Views
struct NotificationsView: View {
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
                
                Text("Henüz bildiriminiz bulunmuyor.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Bildirimler")
            .navigationBarHidden(true)
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Ayarlar")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
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
                                            .foregroundColor(.primary)
                                        
                                        Text(user.email ?? "")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .padding(16)
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // Settings Options
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Uygulama Ayarları")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 1) {
                                SettingsRow(icon: "bell", title: "Bildirimler", color: .orange)
                                SettingsRow(icon: "moon", title: "Koyu Tema", color: .purple)
                                SettingsRow(icon: "globe", title: "Dil Ayarları", color: .blue)
                                SettingsRow(icon: "questionmark.circle", title: "Yardım", color: .green)
                                SettingsRow(icon: "info.circle", title: "Hakkında", color: .gray)
                            }
                            .background(Color(.systemBackground))
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
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.top, 20)
                    }
                }
                
                Spacer()
            }
            .background(Color(.systemGray6))
        }
        .navigationBarHidden(true)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let color: Color
    
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
                    .foregroundColor(.primary)
                
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

// MARK: - Preview
struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView()
            .environmentObject(AuthViewModel())
    }
}