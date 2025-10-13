//
//  MainAppView.swift
//  Task Flow Versiyon 2
//
//  Created on 13 Ekim 2025.
//

import SwiftUI

// MARK: - MainAppView

struct MainAppView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        Group {
            if authViewModel.userSession != nil {
                // User is logged in - show main app
                CustomTabView()
                    .environmentObject(authViewModel)
            } else {
                // User is not logged in - show login
                EnhancedLoginView()
                    .environmentObject(authViewModel)
            }
        }
    }
}

// MARK: - ProfileView (Temporary)
struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // User Info
                if let user = authViewModel.userSession {
                    VStack(spacing: 8) {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Text(user.displayName?.prefix(1).uppercased() ?? "U")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.blue)
                            )
                        
                        Text(user.displayName ?? "Kullanıcı")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text(user.email ?? "")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Sign Out butonu
                Button("Çıkış Yap") {
                    authViewModel.signOut()
                }
                .foregroundColor(.red)
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Profil")
        }
    }
}

// MARK: - Preview
#Preview {
    MainAppView()
}