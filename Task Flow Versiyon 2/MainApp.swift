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
    @StateObject private var projectManager = ProjectManager()
    
    init() {
        print("🚀 MainAppView initialized")
    }
    
    var body: some View {
        let _ = print("🎨 MainAppView body called - User: \(authViewModel.userSession != nil ? "Logged in" : "Not logged in")")
        
        return Group {
            if authViewModel.userSession != nil {
                // User is logged in - show main app
                CustomTabView()
                    .environmentObject(authViewModel)
                    .environmentObject(projectManager)
                    .onAppear {
                        print("✅ CustomTabView appeared")
                        // Kullanıcı giriş yaptı, listener'ı başlat
                        projectManager.setupListener()
                    }
            } else {
                // User is not logged in - show login
                EnhancedLoginView()
                    .environmentObject(authViewModel)
                    .onAppear {
                        print("✅ EnhancedLoginView appeared")
                    }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    MainAppView()
}