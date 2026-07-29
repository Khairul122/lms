import 'package:flutter/material.dart';
import 'package:lms/core/theme/app_colors.dart';

/// Feature-agnostic bottom nav bar (4 tabs: home/kelas/tugas/profil).
/// Callers supply [onTabSelected] instead of this widget importing
/// concrete screens itself - core/ must not depend on features/. Built
/// with the callback API from day one, unlike guru's original version
/// which had to be retrofitted after the fact.
///
/// This consolidates 3 near-identical `_buildBottomNavBar()` private
/// methods that were previously duplicated verbatim across
/// dftr_kelas.dart, daftar_tugas.dart and profil.dart.
class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  static const _tabs = [
    (icon: Icons.home_outlined, label: 'Beranda'),
    (icon: Icons.co_present_outlined, label: 'Kelas'),
    (icon: Icons.pending_actions_outlined, label: 'Tugas'),
    (icon: Icons.person_outline, label: 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_tabs.length, (index) {
          final tab = _tabs[index];
          final isSelected = index == selectedIndex;

          if (isSelected) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(tab.icon, color: AppColors.primary, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    tab.label,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            );
          }

          return IconButton(
            icon: Icon(tab.icon, color: Colors.white, size: 28),
            onPressed: () => onTabSelected(index),
          );
        }),
      ),
    );
  }
}
