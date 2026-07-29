import 'package:guru/services/api_service.dart';

class MeetingService {

  static Future<Map<String, dynamic>> getMeetings() async {

    return await ApiService.get("/meetings");

  }

}