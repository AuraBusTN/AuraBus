import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/core/utils/color_utils.dart';

void main() {
  group('ColorUtils.parseHexColor', () {
    test('parses 6-digit hex with # prefix', () {
      final color = ColorUtils.parseHexColor('#FF0000');
      expect(color, const Color(0xFFFF0000));
    });

    test('parses 6-digit hex without # prefix', () {
      final color = ColorUtils.parseHexColor('00FF00');
      expect(color, const Color(0xFF00FF00));
    });

    test('parses 8-digit hex (with alpha)', () {
      final color = ColorUtils.parseHexColor('80FF0000');
      expect(color, const Color(0x80FF0000));
    });

    test('returns black for null input', () {
      final color = ColorUtils.parseHexColor(null);
      expect(color, Colors.black);
    });

    test('returns black for empty string', () {
      final color = ColorUtils.parseHexColor('');
      expect(color, Colors.black);
    });

    test('returns black for invalid hex string', () {
      final color = ColorUtils.parseHexColor('not_a_color');
      expect(color, Colors.black);
    });

    test('parses blue hex color', () {
      final color = ColorUtils.parseHexColor('#1E88E5');
      expect(color, const Color(0xFF1E88E5));
    });

    test('parses hex with leading/trailing spaces', () {
      final color = ColorUtils.parseHexColor('  #AABBCC  ');
      expect(color, const Color(0xFFAABBCC));
    });

    test('parses lowercase hex', () {
      final color = ColorUtils.parseHexColor('#ff5500');
      expect(color, const Color(0xFFFF5500));
    });
  });
}
