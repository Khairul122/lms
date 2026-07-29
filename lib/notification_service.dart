import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("📩 Background Message: ${message.messageId}");
}

class NotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
    showBadge: true,
  );

  static Future<void> initialize() async {
    // 1. Minta Izin Notifikasi (Sangat penting untuk Android 13+)
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    debugPrint('🔔 Izin Notifikasi Status: ${settings.authorizationStatus}');

    // 2. Inisialisasi Notifikasi Lokal (Untuk Foreground)
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint("🔔 Notifikasi diklik: ${response.payload}");
      },
    );

    // 3. Buat Channel Notifikasi di Sistem Android
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // 4. Set Foreground Notification Options agar muncul pop-up saat aplikasi terbuka
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 5. Handle pesan saat aplikasi sedang terbuka (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📩 Pesan Masuk (Foreground): ${message.notification?.title}');
      
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
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
              fullScreenIntent: true, // Memaksa agar muncul melayang (Heads-up)
            ),
          ),
          payload: message.data.toString(),
        );
      }
    });

    // 6. Handle Background Message
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 7. Sinkronisasi Topik (Subscribe ke kelas yang diikuti)
    await syncTopics();
  }

  static Future<void> syncTopics() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint('⚠️ Gagal Sinkronisasi: User belum login');
      return;
    }

    try {
      // Subscribe ke topik personal siswa
      await _fcm.subscribeToTopic('siswa_${user.uid}');
      
      // Ambil semua kelas yang diikuti siswa ini
      final snapshot = await FirebaseFirestore.instance
          .collection('classes')
          .where('students', arrayContains: user.uid)
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final classCode = data['class_code'];
        if (classCode != null) {
          // Subscribe ke topik kelas dan chat
          await _fcm.subscribeToTopic('kelas_$classCode');
          await _fcm.subscribeToTopic('chat_$classCode');
          debugPrint('✅ [SYNC] Terdaftar di: kelas_$classCode');
        }
      }
    } catch (e) {
      debugPrint('❌ Error syncTopics: $e');
    }
  }
}
