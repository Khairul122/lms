import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Pembungkus tipis untuk menampilkan pop-up notifikasi lokal (system tray)
/// tanpa bergantung pada Firebase/push server. Dipakai oleh [NotificationWatcher]
/// saat mendeteksi ada notifikasi baru dari backend.
class LocalNotificationService {
  LocalNotificationService._internal();

  static final LocalNotificationService instance = LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _plugin.initialize(initSettings);

    // Android 13+ mewajibkan izin runtime untuk menampilkan notifikasi.
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _plugin
        .resolvePlatformSpecificImplementation<DarwinFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    _initialized = true;
  }

  Future<void> show({required int id, required String title, required String body}) async {
    if (!_initialized) {
      await init();
    }

    const androidDetails = AndroidNotificationDetails(
      'edusmart_guru_notifications',
      'Notifikasi EduSmart Guru',
      channelDescription: 'Notifikasi diskusi, pengumpulan tugas, dan aktivitas kelas',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.show(id, title, body, details);
  }
}
