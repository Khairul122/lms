import 'package:guru/services/api_service.dart';

class ClassService {

  static Future<Map<String, dynamic>> getClasses() async {

    return await ApiService.get("/classes");

  }

}