# 🧪 Backend ve iOS Entegrasyonu Test Rehberi

## ✅ Adım 1: Backend Kontrolü

### Backend Çalışıyor mu?

Terminal'de şu komutu çalıştır:

```bash
curl http://localhost:3000/api/health
```

**Beklenen Sonuç:**
```json
{"status":"OK","message":"Task Flow API is running","timestamp":"2025-10-25T..."}
```

**Hata alırsan:**
```bash
cd /Users/bilgehankarakus/Documents/GitHub/task-flow-3/project-auth-backend
node server.js
```

Console'da göreceğin:
```
🚀 Server is running on port 3000
📝 Environment: development
MongoDB'ye bağlandı
```

---

## ✅ Adım 2: Kayıtlı Kullanıcıları Kontrol Et

```bash
curl http://localhost:3000/api/users
```

**Beklenen:** Kullanıcı listesi dönecek.

---

## ✅ Adım 3: Login Test Et

### Terminal ile test:

```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"testuser@mail.com","password":"123456"}'
```

**Beklenen Sonuç:**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "uid": "...",
    "username": "testuser",
    "email": "testuser@mail.com",
    "displayName": "testuser"
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

---

## ✅ Adım 4: iOS Uygulamasını Test Et

### 4.1. Xcode'da Projeyi Aç

```
Task Flow Versiyon 2.xcodeproj
```

### 4.2. NetworkManager URL'ini Kontrol Et

**NetworkManager.swift** dosyasını aç ve kontrol et:

```swift
private let baseURL = "http://localhost:3000/api"
```

✅ **Simulator için:** `localhost` kullan
⚠️ **Gerçek iPhone için:** Mac'in IP adresini kullan (aşağıda açıklandı)

### 4.3. Uygulamayı Çalıştır

1. Simulator seç (iPhone 15 Pro önerilirim)
2. **▶️ Run** butonuna bas (Cmd+R)

### 4.4. Giriş Yap

**Test Kullanıcıları:**

```
Email: testuser@mail.com
Password: 123456
```

veya

```
Email: bilgehan@mail.com
Password: 123456
```

### 4.5. Console'u İzle

Xcode'un alt kısmındaki **Console** alanında şunları göreceksin:

✅ **Başarılı Giriş:**
```
✅ Giriş başarılı: testuser
```

❌ **Hata varsa:**
```
❌ Giriş hatası: The Internet connection appears to be offline.
```

---

## 🐛 Sorun Giderme

### Problem 1: "Connection Failed" Hatası

**Sebep:** Backend çalışmıyor.

**Çözüm:**
```bash
cd project-auth-backend
node server.js
```

---

### Problem 2: "Invalid Credentials" Hatası

**Sebep:** Email/şifre yanlış veya kullanıcı yok.

**Çözüm:** Yeni kullanıcı oluştur:
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"test","email":"test@test.com","password":"123456"}'
```

---

### Problem 3: Gerçek iPhone'da Bağlanamıyor

**Sebep:** `localhost` sadece Simulator'de çalışır.

**Çözüm:** Mac'in IP adresini bul:

```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
```

Örnek çıktı:
```
inet 192.168.1.45 netmask 0xffffff00 broadcast 192.168.1.255
```

**NetworkManager.swift** dosyasını düzenle:
```swift
private let baseURL = "http://192.168.1.45:3000/api"  // IP'ni yaz
```

**Önemli:** iPhone ve Mac aynı WiFi ağında olmalı!

---

## 📱 iOS Uygulaması Test Checklist

### ✅ Giriş Ekranı (EnhancedLoginView)
- [ ] Email ve şifre girişi
- [ ] "Giriş Yap" butonu çalışıyor
- [ ] Loading indicator gösteriliyor
- [ ] Hata mesajları gösteriliyor
- [ ] Başarılı girişte ana ekrana yönlendiriyor

### ✅ Ana Ekran (CustomTabView)
- [ ] Tab bar görünüyor
- [ ] Kullanıcı adı gösteriliyor
- [ ] Profil fotoğrafı gösteriliyor (varsa)

### ✅ Çıkış
- [ ] Profil sekmesinden "Çıkış" yapılıyor
- [ ] Token siliniyor
- [ ] Login ekranına dönüyor

---

## 🔍 Debug İpuçları

### Console'da Network İsteklerini İzle

**NetworkManager.swift**'te zaten log var:

```swift
print("❌ Decode error: \(error)")
print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
```

### Xcode Console'da Görmek İstediğin:

✅ **Başarılı:**
```
✅ Giriş başarılı: testuser
```

❌ **Hata:**
```
❌ Giriş hatası: HTTP Hatası: 401
❌ Decode error: ...
Response data: {"success":false,"message":"Invalid credentials"}
```

---

## 🧪 Hızlı Test Komutları

```bash
# 1. Backend çalışıyor mu?
curl http://localhost:3000/api/health

# 2. Kullanıcılar listesi
curl http://localhost:3000/api/users

# 3. Giriş yap
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"testuser@mail.com","password":"123456"}'

# 4. Kayıt ol
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"yeniuser","email":"yeni@test.com","password":"123456"}'

# 5. Backend'i durdur
pkill -f "node.*server.js"

# 6. Backend'i başlat
cd project-auth-backend && node server.js
```

---

## 📊 Test Sonuçları

### ✅ Backend Hazır
- [x] Server çalışıyor (port 3000)
- [x] MongoDB bağlı
- [x] 4 kullanıcı kayıtlı
- [x] Authentication çalışıyor
- [x] JWT token üretiliyor

### ✅ iOS Entegrasyonu Hazır
- [x] NetworkManager eklendi
- [x] APIModels eklendi
- [x] AuthViewModel backend'e bağlı
- [x] Token yönetimi (UserDefaults)
- [x] Otomatik giriş

### 🔄 Sonraki Adımlar
- [ ] ProjectListView backend'e bağla
- [ ] CreateProjectView backend'e bağla
- [ ] TaskDetailView backend'e bağla
- [ ] AddTaskView backend'e bağla

---

## 💡 Önemli Notlar

1. **Backend her zaman çalışmalı**: iOS uygulamasını test ederken backend sunucusunun çalışıyor olması gerekir.

2. **Simulator vs Gerçek Cihaz**: 
   - Simulator → `localhost` kullan
   - iPhone → Mac'in IP adresini kullan

3. **Token Süresi**: Token 7 gün geçerli. Sonra tekrar giriş yapman gerekir.

4. **UserDefaults**: Token ve kullanıcı bilgileri UserDefaults'ta saklanıyor. Temizlemek için:
   ```swift
   UserDefaults.standard.removeObject(forKey: "auth_token")
   UserDefaults.standard.removeObject(forKey: "user_data")
   ```

---

## 🎉 Test Başarılı!

Eğer yukarıdaki adımları tamamladıysan, backend iOS uygulaması ile başarıyla entegre olmuştur!

**Sorun yaşarsan:**
- Console log'larını kontrol et
- Backend terminal output'unu kontrol et
- Network bağlantısını kontrol et
- Bu rehberdeki sorun giderme bölümüne bak
