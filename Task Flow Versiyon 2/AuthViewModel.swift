//
//  AuthViewModel.swift
//  Task Flow Versiyon 2
//
//  Created on 13 Ekim 2025.
//

import SwiftUI
import Combine
// import FirebaseAuth // Will be enabled after Firebase installation

// MARK: - AuthViewModel (Mock Implementation)

final class AuthViewModel: ObservableObject {
    @Published var userSession: MockUser?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    init() {
        // Mock user session for testing
        setupMockAuthState()
    }
    
    // MARK: - Mock Auth State
    private func setupMockAuthState() {
        // Test için otomatik giriş - istediğinizde kapatabilirsiniz
        // userSession = nil // Bu satırı uncomment edip alt satırı comment edin
        
        // Otomatik mock giriş
        userSession = MockUser(
            uid: "test-user-123",
            email: "test@example.com",
            displayName: "Test Kullanıcı"
        )
    }
    
    // MARK: - Sign In (Mock Implementation)
    @MainActor
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        
        // Mock authentication logic
        if email.contains("@") && password.count >= 6 {
            userSession = MockUser(
                uid: "mock-\(UUID().uuidString)",
                email: email,
                displayName: email.components(separatedBy: "@").first?.capitalized
            )
            print("✅ Mock Sign In Successful: \(email)")
        } else {
            if !email.contains("@") {
                errorMessage = "Geçersiz e-posta adresi."
            } else if password.count < 6 {
                errorMessage = "Şifre en az 6 karakter olmalıdır."
            }
        }
        
        isLoading = false
    }
    
    // MARK: - Sign Up (Mock Implementation)
    @MainActor
    func signUp(email: String, password: String, fullName: String) async {
        isLoading = true
        errorMessage = nil
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        // Mock sign up logic
        if email.contains("@") && password.count >= 6 && !fullName.isEmpty {
            userSession = MockUser(
                uid: "mock-\(UUID().uuidString)",
                email: email,
                displayName: fullName
            )
            print("✅ Mock Sign Up Successful: \(fullName) (\(email))")
        } else {
            if !email.contains("@") {
                errorMessage = "Geçersiz e-posta adresi."
            } else if password.count < 6 {
                errorMessage = "Şifre en az 6 karakter olmalıdır."
            } else if fullName.isEmpty {
                errorMessage = "Ad Soyad boş bırakılamaz."
            }
        }
        
        isLoading = false
    }
    
    // MARK: - Sign Out
    func signOut() {
        userSession = nil
        print("✅ Mock Sign Out Successful")
    }
    
        
    // MARK: - Reset Password (Mock Implementation)
    @MainActor
    func resetPassword(email: String) async {
        isLoading = true
        errorMessage = nil
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        if email.contains("@") {
            print("✅ Mock Password Reset Email Sent to: \(email)")
            // Success - no error message means success
        } else {
            errorMessage = "Geçersiz e-posta adresi."
        }
        
        isLoading = false
    }
    
    // MARK: - Update Display Name
    func updateDisplayName(_ name: String) {
        if var user = userSession {
            user.displayName = name
            userSession = user
            print("✅ Display Name Updated: \(name)")
        }
    }
    
    // MARK: - Send Password Reset (with callback)
    func sendPasswordReset(email: String, completion: @escaping (Bool) -> Void) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if email.contains("@") {
                print("✅ Password Reset Email Sent to: \(email)")
                completion(true)
            } else {
                print("❌ Invalid email for password reset")
                completion(false)
            }
        }
    }
}

}