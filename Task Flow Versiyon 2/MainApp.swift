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

// MARK: - Preview
#Preview {
    MainAppView()
}