# 📱 EduSmart LMS - Aplikasi Mobile Siswa (Pelajar)

![Flutter](https://img.shields.io/badge/Flutter-3.24.x-02569B?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.5.x-0175C2?style=for-the-badge&logo=dart)
![Android](https://img.shields.io/badge/Android-Min_SDK_21-3DDC84?style=for-the-badge&logo=android)

Aplikasi Mobile Flutter **EduSmart LMS Siswa** dirancang khusus untuk Pelajar (Siswa) untuk mengakses kelas pembelajaran, membaca materi pelajaran, mengumpulkan tugas, menerima notifikasi nilai, serta berdiskusi langsung dengan Guru dan rekan sekelas.

---

## 📱 Spesifikasi Aplikasi

- **Application ID / Package Name**: `com.lms.siswa`
- **Min SDK Version**: Android 21 (Android 5.0 Lollipop+)
- **Target SDK Version**: Android 34 (Android 14)
- **Framework**: Flutter `3.24.x` / Dart `3.5.x`

---

## 🛠️ Persyaratan Setup Localhost

- **Flutter SDK**: Versi `>= 3.24.x`
- **Android Studio / VS Code**: Ter-install ekstensi Flutter & Dart
- **Java JDK**: Version 17 (Temurin / OpenJDK)
- **Backend Running**: Server `edusmart-backend` telah berjalan di `http://localhost:8000`

---

## 🚀 Langkah Instalasi & Penggunaan Localhost

### 1. Masuk ke Folder Project Siswa
```bash
cd siswa
```

### 2. Download Dependensi Package Flutter
```bash
flutter pub get
```

### 3. Konfigurasi Alamat API (`api_config.dart`)
Buka berkas [`lib/core/config/api_config.dart`](file:///d:/ProjekFullStack/lms/siswa/lib/core/config/api_config.dart):

* **Untuk Android Emulator**:
  ```dart
  class ApiConfig {
    static String customBaseUrl = '';
    static String get baseUrl => 'http://10.0.2.2:8000/api';
  }
  ```
* **Untuk HP Android Fisik (WiFi Sama)**:
  ```dart
  class ApiConfig {
    static String customBaseUrl = '';
    static String get baseUrl => 'http://192.168.1.XX:8000/api'; // Sesuaikan IP Laptop
  }
  ```
* **Untuk Production (Live Domain)**:
  ```dart
  class ApiConfig {
    static String customBaseUrl = '';
    static String get baseUrl => 'https://backend-lms.synectra.xyz/api';
  }
  ```

### 4. Jalankan Aplikasi
```bash
flutter run
```

---

## ✨ Fitur Utama Aplikasi Siswa

1. **Beranda & Pengingat Tugas**: Kartu pengingat batas waktu tugas paling mendesak.
2. **Gabung Kelas Unik**: Fitur bergabung ke kelas guru menggunakan kode 6 karakter.
3. **Materi & Pertemuan**: Membaca modul pelajaran & membuka dokumen PDF.
4. **Pengumpulan Tugas (Submissions)**: Mengunggah berkas jawaban/tugas ke server.
5. **Notifikasi Real-time**: Notifikasi otomatis saat nilai keluar, ada tugas baru, atau diskusi baru.
6. **Diskusi Kelas Interactive**: Mengirim pesan & berdiskusi dalam thread kelas.
7. **Edit Profil & Foto**: Mengubah data nama, telepon, dan foto profil.

---

## 📦 Build Release APK

Untuk menghasilkan berkas APK release secara lokal:
```bash
flutter build apk --release
```
Berkas APK hasil kompilasi tersimpan pada:
`build/app/outputs/flutter-apk/app-release.apk`

---

## 🚀 CI/CD Build & GitHub Release

Setiap kali Git Tag `v*` di-push ke repository:
```bash
git tag v1.0.0
git push origin v1.0.0
```
Workflow GitHub Actions di `.github/workflows/build-release.yml` akan mem-build APK secara otomatis dan mempublikasikannya ke menu **GitHub Releases** dengan nama `lms-siswa-v1.0.0.apk`.
