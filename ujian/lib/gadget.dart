import 'package:flutter/material.dart';

class Gadget {
  final IconData icon;
  final String nama;
  final int harga;
  final Color color;

  const Gadget({
    required this.icon,
    required this.nama,
    required this.harga,
    required this.color,
  });

  // Format angka jadi Rp12.500.000 tanpa package tambahan
  static String formatRupiah(int angka) {
    final text = angka.toString();
    final buffer = StringBuffer('Rp');
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && (text.length - i) % 3 == 0) buffer.write('.');
      buffer.write(text[i]);
    }
    return buffer.toString();
  }

  String get hargaText => formatRupiah(harga);
}