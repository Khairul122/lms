import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Layar scan QR kode kelas. Pop dengan string kode kelas begitu QR terbaca.
class ScanKodeKelas extends StatefulWidget {
  const ScanKodeKelas({super.key});

  @override
  State<ScanKodeKelas> createState() => _ScanKodeKelasState();
}

class _ScanKodeKelasState extends State<ScanKodeKelas> {
  bool _handled = false;

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    final value = capture.barcodes.firstOrNull?.rawValue;
    if (value == null || value.isEmpty) return;

    _handled = true;
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scan Kode Kelas'),
        backgroundColor: const Color(0xFF00A3E9),
        foregroundColor: Colors.white,
      ),
      body: MobileScanner(onDetect: _onDetect),
    );
  }
}

extension _FirstOrNull<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
