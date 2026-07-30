import 'package:flutter/material.dart';

import 'package:lms/core/services/notification_watcher.dart';
import 'package:lms/features/notifications/presentation/notifikasi.dart';

/// Icon lonceng notifikasi dengan badge jumlah belum dibaca.
/// Dipakai di homepage & cari kelas supaya konsisten.
class NotificationBell extends StatelessWidget {
  final Color color;
  final double size;

  const NotificationBell({super.key, this.color = Colors.white, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: NotificationWatcher.instance.unreadCount,
      builder: (context, count, _) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: Icon(Icons.notifications_none, color: color, size: size),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotifikasiScreen()),
                );
                NotificationWatcher.instance.refresh();
              },
            ),
            if (count > 0)
              Positioned(
                right: 6,
                top: 6,
                child: IgnorePointer(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      count > 9 ? '9+' : '$count',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
