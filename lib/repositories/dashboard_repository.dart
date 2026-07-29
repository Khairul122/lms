import 'package:guru/services/api_service.dart';

class DashboardRepository {
  Future<Map<String, dynamic>> getDashboard() async {
    return await ApiService.get(
      "/dashboard",
    );
  }
}