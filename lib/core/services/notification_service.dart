import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("📩 Guru Background Message: ${message.messageId}");
}

class NotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'guru_high_importance_channel',
    'Guru High Importance Notifications',
    description: 'Channel for important guru notifications.',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  static Future<void> initialize() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('🔔 Guru Izin Notifikasi: ${settings.authorizationStatus}');

    // 🔥 CEK TOKEN FCM (Jika ini kosong, masalah ada di Google Play Services/Koneksi)
    String? token = await _fcm.getToken();
    debugPrint('🔑 FCM TOKEN GURU: $token');

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await _localNotifications.initialize(initializationSettings);

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📩 Guru Pesan Masuk (Foreground): ${message.notification?.title}');
      
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _channel.id,
              _channel.name,
              channelDescription: _channel.description,
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });

    await syncTeacherTopic();
  }

  static Future<void> syncTeacherTopic() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      debugPrint('📡 Guru mencoba subscribe ke: guru_${user.uid}');
      await _fcm.subscribeToTopic('guru_${user.uid}');
      debugPrint('✅ Guru Berhasil Subscribed: guru_${user.uid}');
      
      final snapshot = await FirebaseFirestore.instance
          .collection('classes')
          .where('teacher_id', isEqualTo: user.uid)
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final classCode = data['class_code'];
        if (classCode != null) {
          await _fcm.subscribeToTopic('chat_$classCode');
          await _fcm.subscribeToTopic('kelas_$classCode');
          debugPrint('✅ [GURU SYNC] Subscribed ke: chat_$classCode & kelas_$classCode');
        } else {
          debugPrint('⚠️ [GURU SYNC] Ada dokumen kelas tanpa class_code: ${doc.id}');
        }
      }
    } catch (e) {
      debugPrint('❌ Guru Gagal syncTeacherTopic: $e');
    }
  }
}
