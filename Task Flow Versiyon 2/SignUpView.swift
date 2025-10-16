//
//  SignUpView.swift
//  Raptiye
//
//  Created on 16 Ekim 2025.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPasswordMismatchAlert = false
    
    // Yeşil raptiye rengi
    let greenAccent = Color(red: 0.40, green: 0.84, blue: 0.55)
    let darkBackground = Color(red: 0.11, green: 0.13, blue: 0.16)
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 0) {
                        // Header Section
                        headerSection
                            .frame(height: geometry.size.height * 0.25)
                        
                        // Sign Up Form Section
                        signUpFormSection
                            .padding(.horizontal, 32)
                            .padding(.top, 40)
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .background(darkBackground)
            .ignoresSafeArea()
            .navigationBarHidden(true)
            .alert("Şifreler Eşleşmiyor", isPresented: $showPasswordMismatchAlert) {
                Button("Tamam", role: .cancel) { }
            } message: {
                Text("Lütfen şifrelerin aynı olduğundan emin olun.")
            }
            .alert("Hata", isPresented: .constant(authViewModel.errorMessage != nil)) {
                Button("Tamam") {
                    authViewModel.errorMessage = nil
                }
            } message: {
                Text(authViewModel.errorMessage ?? "")
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Circle())
                }
                .padding(.leading, 20)
                
                Spacer()
            }
            .padding(.top, 20)
            
            Spacer()
            
            // Yeşil Raptiye İkonu
            ZStack {
                Circle()
                    .fill(greenAccent.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "pin.fill")
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundColor(greenAccent)
                    .rotationEffect(.degrees(45))
            }
            
            // Title
            Text("Hesap Oluştur")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Spacer()
        }
    }
    
    // MARK: - Sign Up Form Section
    private var signUpFormSection: some View {
        VStack(spacing: 24) {
            // Welcome Text
            VStack(spacing: 8) {
                Text("Raptiye'ye Katılın")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("Hesabınızı oluşturarak başlayın")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.bottom, 20)
            
            // Name Field
            CustomTextField(
                placeholder: "Ad Soyad",
                text: $name,
                keyboardType: .default,
                systemImage: "person"
            )
            
            // Email Field
            CustomTextField(
                placeholder: "E-posta",
                text: $email,
                keyboardType: .emailAddress,
                systemImage: "envelope"
            )
            
            // Password Field
            CustomSecureField(
                placeholder: "Şifre",
                text: $password,
                systemImage: "lock"
            )
            
            // Confirm Password Field
            CustomSecureField(
                placeholder: "Şifre Tekrar",
                text: $confirmPassword,
                systemImage: "lock"
            )
            
            // Sign Up Button - Yeşil
            Button(action: {
                Task {
                    await signUp()
                }
            }) {
                HStack {
                    if authViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Text("Kayıt Ol")
                            .font(.system(size: 18, weight: .semibold))
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(greenAccent)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: greenAccent.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .disabled(authViewModel.isLoading || name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
            .opacity(authViewModel.isLoading || name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty ? 0.6 : 1.0)
            .padding(.top, 16)
            
            // Sign In Option
            HStack(spacing: 4) {
                Text("Zaten hesabınız var mı?")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.8))
                
                Button("Giriş Yap") {
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(greenAccent)
            }
            .padding(.top, 20)
        }
    }
    
    // MARK: - Functions
    private func signUp() async {
        // Şifrelerin eşleşip eşleşmediğini kontrol et
        guard password == confirmPassword else {
            showPasswordMismatchAlert = true
            return
        }
        
        // Firebase sign up
        await authViewModel.signUp(email: email, password: password, fullName: name)
        
        // Başarılı olursa sayfayı kapat
        if authViewModel.userSession != nil {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

// MARK: - Preview
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(AuthViewModel())
    }
}
