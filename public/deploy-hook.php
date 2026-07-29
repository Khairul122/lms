<?php
/**
 * LMS Backend - Auto Extract Deploy Hook Script
 * Security: Accessible only with valid secret key token via GET parameter `key`
 */

define('SECRET_DEPLOY_KEY', getenv('DEPLOY_HOOK_KEY') ?: 'SYN_DEPLOY_SECRET_KEY_2026');

// 1. Validasi Token Keamanan
$providedKey = $_GET['key'] ?? '';
if (empty($providedKey) || !hash_equals(SECRET_DEPLOY_KEY, $providedKey)) {
    http_response_code(403);
    header('Content-Type: application/json');
    echo json_encode([
        'status' => 'error',
        'message' => 'Unauthorized: Invalid or missing deploy key.'
    ]);
    exit;
}

$baseDir = dirname(__DIR__); // Root folder backend-lms
$zipPath = $baseDir . '/vendor.zip';
$extractTo = $baseDir;

header('Content-Type: application/json');

// 2. Cek Keberadaan vendor.zip
if (!file_exists($zipPath)) {
    echo json_encode([
        'status' => 'info',
        'message' => 'vendor.zip not found. No extraction needed.'
    ]);
    exit;
}

// 3. Extract vendor.zip Menggunakan ZipArchive
$zip = new ZipArchive();
if ($zip->open($zipPath) === TRUE) {
    $zip->extractTo($extractTo);
    $zip->close();

    // 4. Hapus vendor.zip Setelah Selesai
    unlink($zipPath);

    // 5. Jalankan Perintah Clear Cache Laravel (Jika Artisan Tersedia)
    $artisanPath = $baseDir . '/artisan';
    if (file_exists($artisanPath)) {
        @exec("php {$artisanPath} config:clear");
        @exec("php {$artisanPath} cache:clear");
        @exec("php {$artisanPath} route:cache");
    }

    echo json_encode([
        'status' => 'success',
        'message' => 'vendor.zip extracted and removed successfully. Laravel cache cleared.'
    ]);
} else {
    http_response_code(500);
    echo json_encode([
        'status' => 'error',
        'message' => 'Failed to extract vendor.zip.'
    ]);
}
