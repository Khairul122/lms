import 'package:flutter/material.dart';

class FileSourceDialog extends StatelessWidget {
  const FileSourceDialog({super.key});

  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (BuildContext dialogContext) {
        return const FileSourceDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with title and close button
            Stack(
              children: [
                const Center(
                  child: Text(
                    'Ambil Dari',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Grid of 4 options
            Row(
              children: [
                // File Manager
                Expanded(
                  child: _buildOption(
                    context,
                    icon: Icons.folder_outlined,
                    label: 'File Manager',
                    onTap: () {
                      Navigator.of(context).pop('file_manager');
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Kamera
                Expanded(
                  child: _buildOption(
                    context,
                    icon: Icons.camera_alt_outlined,
                    label: 'Kamera',
                    onTap: () {
                      Navigator.of(context).pop('camera');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Download
                Expanded(
                  child: _buildOption(
                    context,
                    icon: Icons.file_upload_outlined,
                    label: 'Download',
                    onTap: () {
                      Navigator.of(context).pop('download');
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Gallery
                Expanded(
                  child: _buildOption(
                    context,
                    icon: Icons.image_outlined,
                    label: 'Gallery',
                    onTap: () {
                      Navigator.of(context).pop('gallery');
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFF1A237E),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

