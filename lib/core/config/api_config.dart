class ApiConfig {
  static String customBaseUrl = '';

  static String get baseUrl {
    if (customBaseUrl.isNotEmpty) return customBaseUrl;
    return 'http://192.168.18.125:8000/api';
  }

  static String get rootUrl => baseUrl.replaceAll('/api', '');

  static Map<String, String> get headers => {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "ngrok-skip-browser-warning": "true",
      };
}
