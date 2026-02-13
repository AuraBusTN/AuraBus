import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/ranking/domain/rank_tier.dart';

void main() {
  group('RankTier', () {
    test('allTiers has 4 tiers in correct order', () {
      expect(RankTier.allTiers.length, 4);
      expect(RankTier.allTiers[0].type, TierType.elite);
      expect(RankTier.allTiers[1].type, TierType.gold);
      expect(RankTier.allTiers[2].type, TierType.silver);
      expect(RankTier.allTiers[3].type, TierType.bronze);
    });

    test('allTiers minPoints are in descending order', () {
      expect(RankTier.allTiers[0].minPoints, 2000);
      expect(RankTier.allTiers[1].minPoints, 1500);
      expect(RankTier.allTiers[2].minPoints, 1000);
      expect(RankTier.allTiers[3].minPoints, 0);
    });

    test('allTiers colors are correct', () {
      expect(RankTier.allTiers[0].color, Colors.purple);
      expect(RankTier.allTiers[1].color, Colors.amber);
      expect(RankTier.allTiers[2].color, const Color(0xFFBDBDBD));
      expect(RankTier.allTiers[3].color, const Color(0xFF8D6E63));
    });
  });

  group('RankTier.getTierInfo', () {
    test('0 points returns bronze current, silver next', () {
      final info = RankTier.getTierInfo(0);
      expect(info.current.type, TierType.bronze);
      expect(info.next.type, TierType.silver);
    });

    test('500 points returns bronze current, silver next', () {
      final info = RankTier.getTierInfo(500);
      expect(info.current.type, TierType.bronze);
      expect(info.next.type, TierType.silver);
    });

    test('999 points returns bronze current, silver next', () {
      final info = RankTier.getTierInfo(999);
      expect(info.current.type, TierType.bronze);
      expect(info.next.type, TierType.silver);
    });

    test('1000 points returns silver current, gold next', () {
      final info = RankTier.getTierInfo(1000);
      expect(info.current.type, TierType.silver);
      expect(info.next.type, TierType.gold);
    });

    test('1499 points returns silver current, gold next', () {
      final info = RankTier.getTierInfo(1499);
      expect(info.current.type, TierType.silver);
      expect(info.next.type, TierType.gold);
    });

    test('1500 points returns gold current, elite next', () {
      final info = RankTier.getTierInfo(1500);
      expect(info.current.type, TierType.gold);
      expect(info.next.type, TierType.elite);
    });

    test('1999 points returns gold current, elite next', () {
      final info = RankTier.getTierInfo(1999);
      expect(info.current.type, TierType.gold);
      expect(info.next.type, TierType.elite);
    });

    test('2000 points returns elite current, max next', () {
      final info = RankTier.getTierInfo(2000);
      expect(info.current.type, TierType.elite);
      expect(info.next.type, TierType.max);
    });

    test('10000 points returns elite current, max next', () {
      final info = RankTier.getTierInfo(10000);
      expect(info.current.type, TierType.elite);
      expect(info.next.type, TierType.max);
    });

    test('max tier has minPoints 99999', () {
      final info = RankTier.getTierInfo(2000);
      expect(info.next.minPoints, 99999);
    });

    test('max tier has black color', () {
      final info = RankTier.getTierInfo(2000);
      expect(info.next.color, Colors.black);
    });
  });

  group('TierType', () {
    test('has all expected values', () {
      expect(TierType.values, contains(TierType.elite));
      expect(TierType.values, contains(TierType.gold));
      expect(TierType.values, contains(TierType.silver));
      expect(TierType.values, contains(TierType.bronze));
      expect(TierType.values, contains(TierType.max));
      expect(TierType.values.length, 5);
    });
  });
}
