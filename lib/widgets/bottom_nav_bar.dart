import 'package:flutter/material.dart';
import 'package:guru/features/onboarding/halamanutama.dart';
import 'package:guru/features/classroom/daftarkelas.dart';
import 'package:guru/features/tasks/penilaian.dart';
import 'package:guru/features/profile/profil.dart';
import 'package:guru/features/classroom/tambahkelas.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Background navigation bar
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1A237E),
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
                      // Home Icon
                      _buildNavItem(
                        context,
                        Icons.home,
                        'Beranda',
                        0,
                        selectedIndex == 0,
                        onTap: () {
                          if (selectedIndex != 0) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HalamanUtama(),
                              ),
                            );
                          }
                        },
                      ),
                      // Upload Icon
                      _buildNavItem(
                        context,
                        Icons.present_to_all,
                        'Kelas',
                        1,
                        selectedIndex == 1,
                        onTap: () {
                          if (selectedIndex != 1) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DaftarKelas(),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 70), // Space for center button
                      // Clipboard Icon
                      _buildNavItem(
                        context,
                        Icons.assignment,
                        'Nilai',
                        2,
                        selectedIndex == 2,
                        onTap: () {
                          if (selectedIndex != 2) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Penilaian(),
                              ),
                            );
                          }
                        },
                      ),
                      // Person Icon
                      _buildNavItem(
                        context,
                        Icons.person_outline,
                        'Profil',
                        3,
                        selectedIndex == 3,
                        onTap: () {
                          if (selectedIndex != 3) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Profil(),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Center FAB button (elevated)
            Positioned(
              left: constraints.maxWidth / 2 - 35,
              bottom: 30,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TambahKelas(),
                    ),
                  );
                },
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A237E),
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
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
    bool isSelected, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
              color: isSelected
                  ? const Color(0xFF1A237E)
                  : Colors.white.withValues(alpha: 0.6),
              size: 22,
            ),
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isSelected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

