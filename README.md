# 👨‍🏫 EduSmart LMS - Aplikasi Mobile Guru (Pengajar)

![Flutter](https://img.shields.io/badge/Flutter-3.24.x-02569B?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.5.x-0175C2?style=for-the-badge&logo=dart)
![Android](https://img.shields.io/badge/Android-Min_SDK_23-3DDC84?style=for-the-badge&logo=android)

Aplikasi Mobile Flutter **EduSmart LMS Guru** dirancang khusus untuk Pengajar (Guru) dalam mengelola kelas pembelajaran, membuat pertemuan, mengunggah materi pelajaran, memberikan tugas, menilai hasil pengumpulan siswa, serta berinteraksi via diskusi kelas.

---

## 📱 Spesifikasi Aplikasi

- **Application ID / Package Name**: `com.example.guru`
- **Min SDK Version**: Android 23 (Android 6.0 Marshmallow+)
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

### 1. Masuk ke Folder Project Guru
```bash
cd guru
```

### 2. Download Dependensi Package Flutter
```bash
flutter pub get
```

### 3. Konfigurasi Alamat API (`api_config.dart`)
Buka berkas [`lib/config/api_config.dart`](file:///d:/ProjekFullStack/lms/guru/lib/config/api_config.dart):

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

## ✨ Fitur Utama Aplikasi Guru

1. **Dashboard & Statistik Kelas**: Ringkasan jumlah murid, kelas, dan tugas aktif.
2. **Manajemen Kelas (Classroom)**: Membuat kelas baru & memperoleh kode unik 6 karakter.
3. **Manajemen Pertemuan (Meetings)**: Menambah agenda pertemuan & absensi.
4. **Unggah Materi (Materials)**: Mengunggah modul berkas PDF/dokumen ke siswa.
5. **Penugasan & Penilaian (Submissions)**: Membuat tugas baru & memberikan nilai (0-100) serta catatan ke siswa.
6. **Diskusi Kelas 2-Arah**: Komunikasi real-time dengan siswa per mata pelajaran.
7. **Profil & Foto Guru**: Pengeditan profil & unggah foto profil.

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
Workflow GitHub Actions di `.github/workflows/build-release.yml` akan mem-build APK secara otomatis dan mempublikasikannya ke menu **GitHub Releases** dengan nama `lms-guru-v1.0.0.apk`.
