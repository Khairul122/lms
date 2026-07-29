class ApiConfig {
  // 🔥 BASE URL BACKEND LARAVEL (Dapat disesuaikan ke HTTP/HTTPS & IP/Domain)
  static String customBaseUrl = '';

  static String get baseUrl {
    if (customBaseUrl.isNotEmpty) return customBaseUrl;
    // Default URL (Fallback ke HTTP/HTTPS dinamis)
    return 'http://192.168.18.125:8000/api';
  }

  static String get rootUrl => baseUrl.replaceAll('/api', '');

  // Header dasar request
  static Map<String, String> get headers => {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "ngrok-skip-browser-warning": "true",
      };
}