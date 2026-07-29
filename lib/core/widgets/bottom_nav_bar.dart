import 'package:flutter/material.dart';
import 'package:guru/core/theme/app_colors.dart';

/// Feature-agnostic bottom nav bar. Callers supply [onTabSelected] and
/// [onCenterTap] (each host screen wires these to its own feature's
/// routes.dart) instead of this widget importing concrete screens itself -
/// core/ must not depend on features/.
class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onCenterTap;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onCenterTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 8, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(Icons.home, 'Beranda', 0, selectedIndex == 0),
                      _buildNavItem(Icons.present_to_all, 'Kelas', 1, selectedIndex == 1),
                      const SizedBox(width: 70),
                      _buildNavItem(Icons.assignment, 'Nilai', 2, selectedIndex == 2),
                      _buildNavItem(Icons.person_outline, 'Profil', 3, selectedIndex == 3),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: constraints.maxWidth / 2 - 35,
              bottom: 30,
              child: GestureDetector(
                onTap: onCenterTap,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 36),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (index != selectedIndex) onTabSelected(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected ? AppColors.primary : Colors.white.withValues(alpha: 0.6),
              size: 22,
            ),
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
