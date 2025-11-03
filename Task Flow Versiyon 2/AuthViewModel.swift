//
//  AuthViewModel.swift
//  Task Flow Versiyon 2
//
//  Created on 13 Ekim 2025.
//

import SwiftUI
import Combine
import FirebaseAuth

// MARK: - AuthViewModel (Firebase)

final class AuthViewModel: ObservableObject {
    @Published var userSession: MockUser?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    init() {
        // Firebase'den mevcut kullanıcıyı yükle
        loadCurrentUser()
    }
    
    // MARK: - Session Management
    
    private func loadCurrentUser() {
        if let firebaseUser = Auth.auth().currentUser {
            self.userSession = MockUser(
                uid: firebaseUser.uid,
                email: firebaseUser.email,
                displayName: firebaseUser.displayName ?? "Kullanıcı"
            )
        }
    }
    
    // MARK: - Sign In (Firebase)
    @MainActor
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        print("🔐 Giriş denemesi - Email: \(email)")
        
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            
            let user = MockUser(
                uid: authResult.user.uid,
                email: authResult.user.email,
                displayName: authResult.user.displayName ?? "Kullanıcı"
            )
            
            self.userSession = user
            
            print("✅ Giriş başarılı: \(user.displayName ?? "Kullanıcı")")
            print("✅ User ID: \(user.uid)")
            print("✅ Email: \(user.email ?? "N/A")")
            
            // NOT: ProjectManager listener'ı MainAppView'de başlatılacak
        } catch let error as NSError {
            let errorCode = error.code
            let errorDomain = error.domain
            errorMessage = error.localizedDescription
            
            print("❌ Giriş hatası")
            print("   - Domain: \(errorDomain)")
            print("   - Code: \(errorCode)")
            print("   - Message: \(error.localizedDescription)")
            print("   - Debug: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Sign Up (Firebase)
    @MainActor
    func signUp(email: String, password: String, fullName: String) async {
        isLoading = true
        errorMessage = nil
        
        print("📝 Kayıt denemesi")
        print("   - Email: \(email)")
        print("   - İsim: \(fullName)")
        print("   - Şifre uzunluğu: \(password.count)")
        
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            
            print("✅ Firebase kullanıcı oluşturuldu: \(authResult.user.uid)")
            
            // Display name güncelle
            let changeRequest = authResult.user.createProfileChangeRequest()
            changeRequest.displayName = fullName
            try await changeRequest.commitChanges()
            
            print("✅ Display name güncellendi: \(fullName)")
            
            let user = MockUser(
                uid: authResult.user.uid,
                email: authResult.user.email,
                displayName: fullName
            )
            
            self.userSession = user
            
            print("✅ Kayıt başarılı: \(fullName)")
            print("✅ User ID: \(user.uid)")
        } catch let error as NSError {
            let errorCode = error.code
            let errorDomain = error.domain
            errorMessage = error.localizedDescription
            
            print("❌ Kayıt hatası")
            print("   - Domain: \(errorDomain)")
            print("   - Code: \(errorCode)")
            print("   - Message: \(error.localizedDescription)")
            print("   - Debug: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Sign Out
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            print("✅ Çıkış başarılı")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Çıkış hatası: \(error)")
        }
    }
    
    // MARK: - Reset Password (Firebase)
    @MainActor
    func resetPassword(email: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            print("✅ Şifre sıfırlama e-postası gönderildi: \(email)")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Şifre sıfırlama hatası: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Update Display Name (Firebase)
    @MainActor
    func updateDisplayName(_ name: String) async {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        do {
            let changeRequest = currentUser.createProfileChangeRequest()
            changeRequest.displayName = name
            try await changeRequest.commitChanges()
            
            if var user = userSession {
                user.displayName = name
                userSession = user
            }
            
            print("✅ Display Name güncellendi: \(name)")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Display Name güncelleme hatası: \(error)")
        }
    }
    
    // MARK: - Send Password Reset (with callback) - Firebase
    func sendPasswordReset(email: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("❌ Şifre sıfırlama hatası: \(error)")
                completion(false)
            } else {
                print("✅ Şifre sıfırlama e-postası gönderildi: \(email)")
                completion(true)
            }
        }
    }
}
