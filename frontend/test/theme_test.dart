import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/theme.dart';

void main() {
  group('AppColors', () {
    test('primary is blue', () {
      expect(AppColors.primary, const Color(0xFF1E88E5));
    });

    test('onPrimary is white', () {
      expect(AppColors.onPrimary, Colors.white);
    });

    test('secondary is dark blue', () {
      expect(AppColors.secondary, const Color(0xFF0D47A1));
    });

    test('ticketOrange is correct', () {
      expect(AppColors.ticketOrange, const Color(0xFFE96E2B));
    });

    test('scaffoldBackground is light gray', () {
      expect(AppColors.scaffoldBackground, const Color(0xFFF8F8F8));
    });

    test('surface is white', () {
      expect(AppColors.surface, Colors.white);
    });

    test('textPrimary is dark', () {
      expect(AppColors.textPrimary, const Color(0xFF212121));
    });

    test('textSecondary is gray', () {
      expect(AppColors.textSecondary, const Color(0xFF757575));
    });

    test('error is red', () {
      expect(AppColors.error, const Color(0xFFD32F2F));
    });

    test('border is light gray', () {
      expect(AppColors.border, const Color(0xFFE0E0E0));
    });

    test('divider is black12', () {
      expect(AppColors.divider, Colors.black12);
    });

    test('ticketPillText is white', () {
      expect(AppColors.ticketPillText, Colors.white);
    });

    test('qrBackground is correct', () {
      expect(AppColors.qrBackground, const Color(0xFFF5F5F5));
    });
  });

  group('AppTheme', () {
    test('lightTheme uses Material 3', () {
      expect(AppTheme.lightTheme.useMaterial3, isTrue);
    });

    test('lightTheme has correct primary color', () {
      expect(AppTheme.lightTheme.primaryColor, AppColors.primary);
    });

    test('lightTheme has correct scaffold background', () {
      expect(
        AppTheme.lightTheme.scaffoldBackgroundColor,
        AppColors.scaffoldBackground,
      );
    });

    test('lightTheme colorScheme brightness is light', () {
      expect(AppTheme.lightTheme.colorScheme.brightness, Brightness.light);
    });

    test('lightTheme colorScheme primary matches AppColors.primary', () {
      expect(AppTheme.lightTheme.colorScheme.primary, AppColors.primary);
    });

    test('lightTheme colorScheme onPrimary is white', () {
      expect(AppTheme.lightTheme.colorScheme.onPrimary, AppColors.onPrimary);
    });

    test('lightTheme colorScheme secondary matches', () {
      expect(AppTheme.lightTheme.colorScheme.secondary, AppColors.secondary);
    });

    test('lightTheme colorScheme error matches', () {
      expect(AppTheme.lightTheme.colorScheme.error, AppColors.error);
    });

    test('lightTheme colorScheme tertiary is ticketOrange', () {
      expect(AppTheme.lightTheme.colorScheme.tertiary, AppColors.ticketOrange);
    });

    test('lightTheme textTheme headlineMedium is correct', () {
      final style = AppTheme.lightTheme.textTheme.headlineMedium;
      expect(style?.fontSize, 26);
      expect(style?.fontWeight, FontWeight.bold);
      expect(style?.color, AppColors.textPrimary);
    });

    test('lightTheme textTheme titleLarge is correct', () {
      final style = AppTheme.lightTheme.textTheme.titleLarge;
      expect(style?.fontSize, 18);
      expect(style?.fontWeight, FontWeight.bold);
    });

    test('lightTheme textTheme titleMedium is correct', () {
      final style = AppTheme.lightTheme.textTheme.titleMedium;
      expect(style?.fontSize, 16);
      expect(style?.fontWeight, FontWeight.bold);
    });

    test('lightTheme textTheme labelMedium is correct', () {
      final style = AppTheme.lightTheme.textTheme.labelMedium;
      expect(style?.fontSize, 12);
      expect(style?.color, AppColors.textSecondary);
    });

    test('lightTheme textTheme headlineLarge is correct', () {
      final style = AppTheme.lightTheme.textTheme.headlineLarge;
      expect(style?.fontSize, 40);
      expect(style?.fontWeight, FontWeight.bold);
      expect(style?.color, AppColors.primary);
    });

    test('lightTheme cardTheme has correct shape', () {
      final shape =
          AppTheme.lightTheme.cardTheme.shape as RoundedRectangleBorder;
      expect(shape.borderRadius, BorderRadius.circular(14));
    });

    test('lightTheme cardTheme has zero elevation', () {
      expect(AppTheme.lightTheme.cardTheme.elevation, 0);
    });

    test('lightTheme cardTheme color is surface', () {
      expect(AppTheme.lightTheme.cardTheme.color, AppColors.surface);
    });

    test('lightTheme bottomSheetTheme has white background', () {
      expect(
        AppTheme.lightTheme.bottomSheetTheme.backgroundColor,
        Colors.white,
      );
    });

    test('lightTheme iconTheme size is 24', () {
      expect(AppTheme.lightTheme.iconTheme.size, 24);
    });

    test('lightTheme iconTheme color is textPrimary', () {
      expect(AppTheme.lightTheme.iconTheme.color, AppColors.textPrimary);
    });

    test('lightTheme listTileTheme has correct padding', () {
      expect(
        AppTheme.lightTheme.listTileTheme.contentPadding,
        const EdgeInsets.symmetric(horizontal: 16),
      );
    });
  });
}
