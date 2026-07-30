import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:guru/services/api_service.dart';
import 'package:guru/core/services/local_notification_service.dart';

/// Singleton yang melakukan polling ringan ke /notifications supaya:
/// 1. Badge unread di icon lonceng selalu up to date.
/// 2. Notifikasi baru dimunculkan sebagai pop-up sistem (bukan Firebase push,
///    tapi tetap muncul di system tray selama aplikasi masih hidup di
///    foreground/background).
class NotificationWatcher {
  NotificationWatcher._internal();

  static final NotificationWatcher instance = NotificationWatcher._internal();

  static const String _lastNotifiedIdKey = 'last_notified_notification_id';
  static const Duration _pollInterval = Duration(seconds: 25);

  final ValueNotifier<int> unreadCount = ValueNotifier<int>(0);

  Timer? _timer;
  bool _isChecking = false;

  void start() {
    if (_timer != null) return;

    refresh();
    _timer = Timer.periodic(_pollInterval, (_) => refresh());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    unreadCount.value = 0;
  }

  Future<void> refresh() async {
    if (_isChecking) return;
    _isChecking = true;

    try {
      final response = await ApiService.get('/notifications');
      if (response is Map && response['success'] == true) {
        final List<dynamic> data = response['data'] is List ? List.from(response['data']) : [];
        final unread = data.where((item) => item is Map && item['is_read'] != true).toList();

        unreadCount.value = unread.length;
        await _popUpIfNew(unread);
      }
    } catch (e) {
      debugPrint('NotificationWatcher gagal refresh: $e');
    } finally {
      _isChecking = false;
    }
  }

  Future<void> _popUpIfNew(List<dynamic> unread) async {
    final prefs = await SharedPreferences.getInstance();

    int highestIdInBatch = 0;
    for (final item in unread) {
      final id = int.tryParse(item['id'].toString()) ?? 0;
      if (id > highestIdInBatch) highestIdInBatch = id;
    }

    // Baseline saat pertama kali fitur ini aktif di device: catat id tertinggi
    // yang sudah ada tanpa memunculkan pop-up, supaya tidak "banjir" notifikasi lama.
    if (!prefs.containsKey(_lastNotifiedIdKey)) {
      await prefs.setInt(_lastNotifiedIdKey, highestIdInBatch);
      return;
    }

    final lastNotifiedId = prefs.getInt(_lastNotifiedIdKey) ?? 0;
    int newHighestId = lastNotifiedId;

    for (final item in unread) {
      final id = int.tryParse(item['id'].toString()) ?? 0;
      if (id > lastNotifiedId) {
        await LocalNotificationService.instance.show(
          id: id,
          title: (item['title'] ?? 'Notifikasi').toString(),
          body: (item['message'] ?? '').toString(),
        );
        if (id > newHighestId) newHighestId = id;
      }
    }

    if (newHighestId > lastNotifiedId) {
      await prefs.setInt(_lastNotifiedIdKey, newHighestId);
    }
  }
}
