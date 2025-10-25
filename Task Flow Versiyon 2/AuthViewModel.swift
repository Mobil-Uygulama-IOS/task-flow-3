//
//  AuthViewModel.swift
//  Task Flow Versiyon 2
//
//  Created on 13 Ekim 2025.
//

import SwiftUI
import Combine

// MARK: - AuthViewModel (Backend Entegre)

final class AuthViewModel: ObservableObject {
    @Published var userSession: MockUser?
    @Published var currentToken: String?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let networkManager = NetworkManager.shared
    
    init() {
        // Token'ı UserDefaults'tan yükle
        loadSavedSession()
    }
    
    // MARK: - Session Management
    
    private func loadSavedSession() {
        if let token = UserDefaults.standard.string(forKey: "auth_token"),
           let userData = UserDefaults.standard.data(forKey: "user_data"),
           let user = try? JSONDecoder().decode(MockUser.self, from: userData) {
            self.currentToken = token
            self.userSession = user
        }
    }
    
    private func saveSession(token: String, user: MockUser) {
        UserDefaults.standard.set(token, forKey: "auth_token")
        if let userData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(userData, forKey: "user_data")
        }
        self.currentToken = token
        self.userSession = user
    }
    
    private func clearSession() {
        UserDefaults.standard.removeObject(forKey: "auth_token")
        UserDefaults.standard.removeObject(forKey: "user_data")
        self.currentToken = nil
        self.userSession = nil
    }
    
    // MARK: - Sign In (Backend)
    @MainActor
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await networkManager.login(email: email, password: password)
            
            let user = MockUser(
                uid: response.data.uid,
                email: response.data.email,
                displayName: response.data.displayName ?? response.data.username ?? "Kullanıcı"
            )
            
            saveSession(token: response.token, user: user)
            
            
            print("✅ Giriş başarılı: \(user.displayName ?? "Kullanıcı")")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Giriş hatası: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Sign Up (Backend)
    @MainActor
    func signUp(email: String, password: String, fullName: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Username oluştur (fullName'den veya email'den)
            let username = fullName.lowercased().replacingOccurrences(of: " ", with: "")
            
            let response = try await networkManager.register(
                username: username,
                email: email,
                password: password,
                displayName: fullName
            )
            
            let user = MockUser(
                uid: response.data.uid,
                email: response.data.email,
                displayName: response.data.displayName ?? fullName
            )
            
            saveSession(token: response.token, user: user)
            
            print("✅ Kayıt başarılı: \(user.displayName ?? fullName)")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Kayıt hatası: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Sign Out
    func signOut() {
        clearSession()
        print("✅ Çıkış başarılı")
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
