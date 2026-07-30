class ApiConfig {
  // 🔥 BASE URL BACKEND LARAVEL (Dapat disesuaikan ke HTTP/HTTPS & IP/Domain / LocalToNet)
  static String customBaseUrl = '';

  static String get baseUrl {
    if (customBaseUrl.isNotEmpty) return customBaseUrl;
    // Default URL (Fallback ke Backend Hosting HTTPS)
    return 'https://backend-lms.synectra.xyz/api';
  }

  static String get rootUrl => baseUrl.replaceAll('/api', '');

  // Header dasar request
  static Map<String, String> get headers => {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "ngrok-skip-browser-warning": "true",
        "localtonet-skip-warning": "true",
      };
}
