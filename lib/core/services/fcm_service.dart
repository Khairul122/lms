import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/foundation.dart';

class FCMService {
  static const _scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

  static Future<String> getAccessToken() async {
    try {
      final serviceAccountJson = await rootBundle.loadString('assets/service_account.json');
      final accountCredentials = ServiceAccountCredentials.fromJson(serviceAccountJson);
      final client = await clientViaServiceAccount(accountCredentials, _scopes);
      return client.credentials.accessToken.data;
    } catch (e) {
      debugPrint('❌ Gagal mendapatkan Access Token: $e');
      return '';
    }
  }

  static Future<void> _sendRawNotification({
    required String topic,
    required String title,
    required String body,
    required String channelId,
    required Map<String, String> data,
  }) async {
    try {
      final token = await getAccessToken();
      if (token.isEmpty) return;

      final url = Uri.parse('https://fcm.googleapis.com/v1/projects/project-lms-d7bb0/messages:send');

      // 🔥 GUNAKAN FORMAT HURUF BESAR UNTUK PRIORITAS
      final payload = {
        'message': {
          'topic': topic,
          'notification': {'title': title, 'body': body},
          'android': {
            'priority': 'HIGH', // 🔥 Diubah dari 'high'
            'notification': {
              'channel_id': channelId,
              'notification_priority': 'PRIORITY_MAX',
              'sound': 'default',
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            },
          },
          'data': data,
        }
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ [FCM GURU] Sukses Kirim ke Topik: $topic');
      } else {
        debugPrint('❌ [FCM GURU] Error (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ [FCM GURU] Catch Error: $e');
    }
  }

  static Future<void> sendNotification({
    required String classCode,
    required String title,
    required String body,
  }) async {
    await _sendRawNotification(
      topic: 'kelas_$classCode',
      title: title,
      body: body,
      channelId: 'high_importance_channel',
      data: {'type': 'general', 'classCode': classCode},
    );
  }

  static Future<void> sendNotificationToStudent({
    required String studentId,
    required String taskTitle,
    required String grade,
  }) async {
    await _sendRawNotification(
      topic: 'siswa_$studentId',
      title: 'Tugas Telah Dinilai',
      body: 'Tugas "$taskTitle" Anda mendapatkan nilai: $grade',
      channelId: 'high_importance_channel',
      data: {'type': 'grade'},
    );
  }

  static Future<void> sendChatNotification({
    required String classCode,
    required String className,
    required String senderName,
    required String message,
  }) async {
    await _sendRawNotification(
      topic: 'chat_$classCode',
      title: 'Pesan Baru di $className',
      body: '$senderName (Guru): $message',
      channelId: 'high_importance_channel',
      data: {'type': 'chat', 'classCode': classCode},
    );
  }
}
