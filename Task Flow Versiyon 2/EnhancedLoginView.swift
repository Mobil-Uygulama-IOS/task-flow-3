//
//  EnhancedLoginView.swift
//  Task Flow Versiyon 2
//
//  Created on 13 Ekim 2025.
//

import SwiftUI

// MARK: - EnhancedLoginView

struct EnhancedLoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isShowingSignUp = false
    @State private var isShowingForgotPassword = false
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // Header Section
                    headerSection
                        .frame(height: geometry.size.height * 0.4)
                    
                    // Login Form Section
                    loginFormSection
                        .padding(.horizontal, 32)
                        .padding(.top, 40)
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.2, blue: 0.45),
                    Color(red: 0.2, green: 0.3, blue: 0.6)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .ignoresSafeArea()
        .sheet(isPresented: $isShowingSignUp) {
            SignUpView()
        }
        .alert("Şifre Sıfırlama", isPresented: $isShowingForgotPassword) {
            TextField("E-posta adresiniz", text: $email)
            Button("Gönder") {
                Task {
                    await authViewModel.resetPassword(email: email)
                }
            }
            Button("İptal", role: .cancel) { }
        } message: {
            Text("Şifre sıfırlama bağlantısı e-posta adresinize gönderilecektir.")
        }
        .alert("Hata", isPresented: .constant(authViewModel.errorMessage != nil)) {
            Button("Tamam") {
                authViewModel.errorMessage = nil
            }
        } message: {
            Text(authViewModel.errorMessage ?? "")
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // App Logo/Icon
            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 100, height: 100)
                .overlay(
                    Image(systemName: "list.clipboard")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(.white)
                )
                .scaleEffect(authViewModel.isLoading ? 0.9 : 1.0)
                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: authViewModel.isLoading)
            
            // App Title
            VStack(spacing: 8) {
                Text("TaskFlow")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Proje yönetiminizi kolaylaştırın")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
    }
    
    // MARK: - Login Form Section
    private var loginFormSection: some View {
        VStack(spacing: 24) {
            // Welcome Text
            VStack(spacing: 8) {
                Text("Hoş Geldiniz")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Hesabınıza giriş yapın")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.bottom, 20)
            
            // Email Field
            CustomTextField(
                placeholder: "E-posta adresiniz",
                text: $email,
                keyboardType: .emailAddress,
                systemImage: "envelope"
            )
            
            // Password Field
            CustomSecureField(
                placeholder: "Şifreniz",
                text: $password,
                systemImage: "lock"
            )
            
            // Forgot Password Button
            HStack {
                Spacer()
                Button("Şifremi Unuttum?") {
                    isShowingForgotPassword = true
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
            }
            .padding(.top, -8)
            
            // Sign In Button
            Button(action: {
                Task {
                    await signIn()
                }
            }) {
                HStack {
                    if authViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Text("Giriş Yap")
                            .font(.system(size: 18, weight: .semibold))
                    }
                }
                .foregroundColor(Color(red: 0.1, green: 0.2, blue: 0.45))
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            }
            .disabled(authViewModel.isLoading || email.isEmpty || password.isEmpty)
            .opacity(authViewModel.isLoading || email.isEmpty || password.isEmpty ? 0.6 : 1.0)
            .padding(.top, 16)
            
            // Sign Up Option
            HStack(spacing: 4) {
                Text("Hesabınız yok mu?")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.8))
                
                Button("Kayıt Olun") {
                    isShowingSignUp = true
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            }
            .padding(.top, 20)
        }
    }
    
    // MARK: - Functions
    private func signIn() async {
        await authViewModel.signIn(email: email, password: password)
    }
}

// MARK: - Custom TextField
struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    let systemImage: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.system(size: 20))
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 24)
            
            TextField(placeholder, text: $text)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .keyboardType(keyboardType)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Custom SecureField
struct CustomSecureField: View {
    let placeholder: String
    @Binding var text: String
    let systemImage: String
    @State private var isSecured = true
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.system(size: 20))
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 24)
            
            Group {
                if isSecured {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .font(.system(size: 16))
            .foregroundColor(.white)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            
            Button(action: {
                isSecured.toggle()
            }) {
                Image(systemName: isSecured ? "eye.slash" : "eye")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Preview
#Preview {
    EnhancedLoginView()
        .environmentObject(AuthViewModel())
}

// MARK: - Temporary SignUpView
struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Text("Kayıt Ol Ekranı")
                .navigationTitle("Kayıt Ol")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Kapat") {
                            dismiss()
                        }
                    }
                }
        }
    }
}