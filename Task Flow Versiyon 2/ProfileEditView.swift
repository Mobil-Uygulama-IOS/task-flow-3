import SwiftUI

struct ProfileEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var displayName: String = ""
    @State private var email: String = ""
    @State private var bio: String = ""
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        ZStack {
            // Dark background
            Color(red: 0.11, green: 0.13, blue: 0.16)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("Profil Bilgileri")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        saveProfile()
                    }) {
                        Text("Düzenle")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(isLoading ? .gray : .blue)
                    }
                    .disabled(isLoading)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                // Content
                ScrollView {
                    VStack(spacing: 24) {
                        // Profile Avatar
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.3))
                                    .frame(width: 120, height: 120)
                                
                                Text(displayName.prefix(1).uppercased())
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(.blue)
                            }
                            
                            Text(displayName.isEmpty ? "Test" : displayName)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(email)
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 20)
                        
                        // Form Fields
                        VStack(spacing: 20) {
                            // Ad Soyad
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Ad Soyad")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                
                                TextField("Ad Soyad", text: $displayName)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(red: 0.15, green: 0.17, blue: 0.21))
                                    )
                            }
                            
                            // E-posta
                            VStack(alignment: .leading, spacing: 8) {
                                Text("E-posta")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                
                                TextField("E-posta", text: $email)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(red: 0.15, green: 0.17, blue: 0.21))
                                    )
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .disabled(true) // Email cannot be changed
                                    .opacity(0.7)
                            }
                            
                            // Hakkımda
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Hakkımda")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                
                                TextEditor(text: $bio)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .frame(minHeight: 100)
                                    .padding(12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(red: 0.15, green: 0.17, blue: 0.21))
                                    )
                                    .scrollContentBackground(.hidden)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Action Buttons
                        VStack(spacing: 16) {
                            // Şifre Değiştir
                            Button(action: {
                                changePassword()
                            }) {
                                HStack {
                                    Image(systemName: "lock.rotation")
                                        .font(.system(size: 20))
                                    
                                    Text("Şifre Değiştir")
                                        .font(.system(size: 16, weight: .medium))
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14))
                                }
                                .foregroundColor(.white)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(red: 0.15, green: 0.17, blue: 0.21))
                                )
                            }
                            
                            // Hesabı Sil
                            Button(action: {
                                showDeleteConfirmation = true
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                        .font(.system(size: 20))
                                    
                                    Text("Hesabı Sil")
                                        .font(.system(size: 16, weight: .medium))
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14))
                                }
                                .foregroundColor(.red)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(red: 0.15, green: 0.17, blue: 0.21))
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                    .padding(.bottom, 40)
                }
            }
            
            // Loading overlay
            if isLoading {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            loadUserData()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Bilgi"),
                message: Text(alertMessage),
                dismissButton: .default(Text("Tamam"))
            )
        }
        .alert("Hesabı Sil", isPresented: $showDeleteConfirmation) {
            Button("İptal", role: .cancel) { }
            Button("Sil", role: .destructive) {
                deleteAccount()
            }
        } message: {
            Text("Hesabınızı silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.")
        }
    }
    
    // MARK: - Functions
    
    private func loadUserData() {
        if let user = authViewModel.userSession {
            displayName = user.displayName ?? ""
            email = user.email ?? ""
            // bio can be loaded from a custom user profile if implemented
        }
    }
    
    private func saveProfile() {
        guard !displayName.isEmpty else {
            alertMessage = "Lütfen ad soyad alanını doldurun."
            showAlert = true
            return
        }
        
        isLoading = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Here you would update the user profile in Firebase
            // For now, we'll just show a success message
            
            isLoading = false
            alertMessage = "Profil bilgileriniz başarıyla güncellendi."
            showAlert = true
            
            // Update display name in Firebase Auth
            authViewModel.updateDisplayName(displayName)
        }
    }
    
    private func changePassword() {
        // Send password reset email
        guard let email = authViewModel.userSession?.email else { return }
        
        isLoading = true
        authViewModel.sendPasswordReset(email: email) { success in
            isLoading = false
            if success {
                alertMessage = "Şifre sıfırlama bağlantısı e-posta adresinize gönderildi."
            } else {
                alertMessage = "Şifre sıfırlama bağlantısı gönderilemedi."
            }
            showAlert = true
        }
    }
    
    private func deleteAccount() {
        isLoading = true
        
        // Simulate account deletion
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            // Here you would delete the account from Firebase
            authViewModel.signOut()
            presentationMode.wrappedValue.dismiss()
        }
    }
}

// MARK: - Preview
struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditView()
            .environmentObject(AuthViewModel())
            .preferredColorScheme(.dark)
    }
}
