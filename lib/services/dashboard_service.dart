import 'package:guru/services/api_service.dart';

class DashboardService {

  static Future<Map<String, dynamic>> getDashboard() async {

    return await ApiService.get("/dashboard");

  }

}