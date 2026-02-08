import 'package:flutter/material.dart';

class ColorUtils {
  static Color parseHexColor(String? hex) {
    if (hex == null || hex.isEmpty) return Colors.black;
    try {
      final buffer = StringBuffer();
      var cleanHex = hex.replaceFirst('#', '').trim();

      if (cleanHex.length == 6) {
        buffer.write('ff');
      }
      buffer.write(cleanHex);

      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return Colors.black;
    }
  }
}
