# Task Flow - Backend Entegrasyon Rehberi

## 🎉 Backend başarıyla entegre edildi!

### ✅ Eklenen Dosyalar

1. **NetworkManager.swift** - Backend API ile iletişim katmanı
2. **APIModels.swift** - API request/response modelleri
3. **AuthViewModel.swift** - Backend ile entegre authentication

### 🚀 Kullanım

#### 1. Backend Sunucusunu Başlatın

```bash
cd project-auth-backend
node server.js
```

Sunucu `http://localhost:3000` adresinde çalışacak.

#### 2. iOS Simulator/Gerçek Cihaz için URL Ayarı

**NetworkManager.swift** dosyasındaki `baseURL` değişkenini güncelleyin:

```swift
// Simulator için:
private let baseURL = "http://localhost:3000/api"

// Gerçek iPhone için (Mac'inizin IP adresini bulun):
// Terminal'de: ifconfig | grep "inet " | grep -v 127.0.0.1
private let baseURL = "http://192.168.1.X:3000/api"  // X yerine IP'nizi yazın
```

#### 3. Giriş Yapma

```swift
// Kayıtlı bir kullanıcı ile giriş:
Email: testuser@mail.com
Password: 123456

// veya

Email: bilgehan@mail.com
Password: 123456
```

### 📱 Özellikler

#### ✅ Authentication
- ✅ Kayıt (Register)
- ✅ Giriş (Login) - Email veya username ile
- ✅ Otomatik token saklama (UserDefaults)
- ✅ Token ile korumalı endpoint'ler
- ✅ Çıkış (Logout)

#### 🔄 Otomatik İşlemler
- ✅ Token UserDefaults'ta saklanır
- ✅ Uygulama açıldığında otomatik giriş
- ✅ Network hatalarını gösterir
- ✅ Loading state'leri

### 🛠 API Endpoint'leri

Backend'de hazır endpoint'ler:

```
POST   /api/auth/register     - Yeni kullanıcı kaydı
POST   /api/auth/login        - Giriş
GET    /api/auth/me           - Mevcut kullanıcı (token gerekli)
PUT    /api/auth/update       - Profil güncelle (token gerekli)

GET    /api/users             - Tüm kullanıcıları listele
POST   /api/users             - Yeni kullanıcı oluştur

GET    /api/projects          - Tüm projeleri listele (token gerekli)
POST   /api/projects          - Yeni proje oluştur (token gerekli)
GET    /api/projects/:id      - Proje detayı (token gerekli)
PUT    /api/projects/:id      - Proje güncelle (token gerekli)
DELETE /api/projects/:id      - Proje sil (token gerekli)

GET    /api/tasks             - Görevleri listele (token gerekli)
POST   /api/tasks             - Yeni görev oluştur (token gerekli)
PUT    /api/tasks/:id         - Görev güncelle (token gerekli)
PUT    /api/tasks/:id/toggle  - Tamamlanma durumu değiştir (token gerekli)
DELETE /api/tasks/:id         - Görev sil (token gerekli)
```

### 💡 İleri Seviye Kullanım

#### Proje Listesi Çekme Örneği

```swift
class ProjectViewModel: ObservableObject {
    @Published var projects: [ProjectData] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let networkManager = NetworkManager.shared
    
    @MainActor
    func loadProjects(token: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await networkManager.getProjects(token: token)
            self.projects = response.data
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
```

#### Görev Oluşturma Örneği

```swift
@MainActor
func createTask(projectId: String, title: String, token: String) async {
    let taskRequest = CreateTaskRequest(
        projectId: projectId,
        title: title,
        description: nil,
        status: "todo",
        priority: "medium",
        assignedTo: nil,
        dueDate: nil
    )
    
    do {
        let response = try await networkManager.createTask(
            task: taskRequest,
            token: token
        )
        print("✅ Görev oluşturuldu: \(response.data.title)")
    } catch {
        print("❌ Hata: \(error)")
    }
}
```

### 🔐 Güvenlik

- ✅ Şifreler bcrypt ile hashlenmiş
- ✅ JWT token ile authentication
- ✅ Token 7 gün geçerli
- ✅ Korumalı endpoint'ler middleware ile güvenli

### 🐛 Hata Ayıklama

**Backend bağlantısı kurulamıyorsa:**

1. Backend sunucusunun çalıştığından emin olun
2. Port numarasını kontrol edin (3000)
3. Firewall/güvenlik duvarı ayarlarını kontrol edin
4. iOS Simulator kullanıyorsanız `localhost` çalışır
5. Gerçek cihaz kullanıyorsanız Mac'in IP adresini kullanın

**Console'da hataları görmek için:**

```swift
// NetworkManager'da detaylı log'lar var:
print("❌ Decode error: \(error)")
print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
```

### 📊 Database

- MongoDB Atlas (Cloud)
- Connection string: `.env` dosyasında
- 4 kullanıcı kayıtlı (testuser, bilgehan, vb.)

### 🎯 Sonraki Adımlar

1. ✅ ProjectListView'i backend ile entegre et
2. ✅ Task CRUD işlemlerini ekle
3. ✅ Real-time güncelleme ekle (WebSocket/Polling)
4. ✅ Profil fotoğrafı yükleme
5. ✅ Push notification entegrasyonu

### 📝 Test Kullanıcıları

```
Username: testuser
Email: testuser@mail.com
Password: 123456

Username: bilgehan
Email: bilgehan@mail.com  
Password: 123456

Username: yenikullanici
Email: yeni@mail.com
Password: 123456
```

---

**Not:** Backend sunucusu `localhost:3000` üzerinde çalışıyor. Gerçek cihazda test etmek için Mac'inizin local IP adresini kullanın!
