import 'package:flutter/material.dart';

Color parseHexColor(String hex) {
  final value = int.parse('FF$hex', radix: 16);
  return Color(value);
}