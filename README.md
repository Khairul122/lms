# 🖥️ EduSmart LMS - Backend REST API & Admin Panel

![Laravel](https://img.shields.io/badge/Laravel-11.x-FF2D20?style=for-the-badge&logo=laravel)
![AdminLTE](https://img.shields.io/badge/AdminLTE-3.2-367FA9?style=for-the-badge&logo=bootstrap)
![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql)
![PHP](https://img.shields.io/badge/PHP-8.2%2B-777BB4?style=for-the-badge&logo=php)

Modul **EduSmart LMS Backend** adalah pusat mesin data (*Core Engine*) yang menyediakan layanan **REST API** untuk aplikasi mobile Flutter (Guru & Siswa) serta **Dashboard Web AdminLTE** untuk manajemen pengguna, kelas, dan konten akademik.

---

## 🛠️ Persyaratan Sistem (Prerequisites)

- **PHP**: Versi `>= 8.2` (dengan ekstensi `mbstring`, `xml`, `bcmath`, `curl`, `zip`, `pdo_mysql`)
- **Composer**: Versi `>= 2.x`
- **Database**: MySQL Server `>= 8.0` / MariaDB
- **Node.js & npm**: Node.js `>= 18.x`

---

## 🚀 Panduan Installation & Setup Localhost

### 1. Buka Terminal & Masuk ke Folder Backend
```bash
cd edusmart-backend
```

### 2. Install Dependensi Composer
```bash
composer install
```

### 3. Konfigurasi Berkas `.env`
Duplikasi file `.env.example` menjadi `.env`:
```bash
cp .env.example .env
```
Sesuaikan konfigurasi database dan URL lokal pada `.env`:
```env
APP_NAME=EduSmart
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost:8000

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=edusmart_lms
DB_USERNAME=root
DB_PASSWORD=
```

### 4. Generate Application Key
```bash
php artisan key:generate
```

### 5. Jalankan Migration & Database Seeder
Buat database bernama `edusmart_lms` di MySQL, lalu jalankan:
```bash
php artisan migrate --seed
```

### 6. Buat Symbolic Link Storage
```bash
php artisan storage:link
```

### 7. Install Aset Vite Frontend
```bash
npm install
npm run dev
```

### 8. Jalankan Dev Server Laravel
```bash
php artisan serve --host=0.0.0.0 --port=8000
```
Akses Dashboard Web di browser: `http://localhost:8000`

---

## 🔑 Kredensial Default Login

| Role | Email Login | Password |
|:---|:---|:---|
| **Administrator** | `admin@edusmart.id` | `password` |
| **Guru** | `guru@edusmart.id` | `password` |
| **Siswa** | `siswa@edusmart.id` | `password` |

---

## 📡 Ringkasan Endpoint REST API

Semua endpoint API mengembalikan format JSON standar:
```json
{
  "success": true,
  "message": "Pesan deskripsi",
  "data": {}
}
```

* `POST /api/login` - Authenticate User
* `GET /api/profile` - Fetch Profile Data
* `POST /api/profile` - Update Profile & Photo
* `GET /api/classes` - Get Class Rooms List
* `POST /api/classes` - Create Class Room (Guru)
* `POST /api/classes/join` - Join Class Code (Siswa)
* `GET /api/meetings` - Get Class Meetings
* `GET /api/materials` - Access Learning Materials
* `GET /api/tasks` - List Class Tasks
* `POST /api/submissions` - Submit Task Answer (Siswa)
* `POST /api/submissions/grade/{id}` - Grade Student Task (Guru)
* `GET /api/discussions` - List Discussion Messages
* `POST /api/discussions` - Post Discussion Message
* `GET /api/notifications` - Get Real-time User Notifications

---

## 🚢 Production Deployment (Rumahweb FTP CI/CD)

Deploy otomatis ke server hosting `backend-lms.synectra.xyz` berjalan setiap kali ada push ke branch `backend`:
```bash
git add .
git commit -m "feat: perbarui backend"
git push origin backend
```
CI/CD GitHub Actions akan otomatis mengompres dependensi `vendor.zip`, mengunggah file via FTP, dan menjalankan `deploy-hook.php` untuk ekstrasi otomatis di server.
