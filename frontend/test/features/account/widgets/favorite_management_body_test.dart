import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aurabus/features/account/widgets/favorite_management_body.dart';
import 'package:aurabus/features/auth/data/auth_repository.dart';
import 'package:aurabus/features/auth/presentation/providers/auth_provider.dart';
import 'package:aurabus/features/map/data/map_providers.dart';
import 'package:aurabus/features/map/data/models/route_info.dart';
import 'package:aurabus/features/auth/data/models/user_model.dart';
import '../../../utils/test_app_wrapper.dart';

class FakeAuthRepository implements AuthRepository {
  List<int> currentFavorites = [1];
  bool shouldThrowOnSave = false;
  bool saveWasCalled = false;

  @override
  Future<List<int>> getFavoriteRoutes() async {
    return currentFavorites;
  }

  @override
  Future<void> updateFavoriteRoutes(List<int> routeIds) async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (shouldThrowOnSave) {
      throw Exception('Errore simulato dal server');
    }
    saveWasCalled = true;
    currentFavorites = routeIds;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeAuthNotifier extends Notifier<AuthState> implements AuthNotifier {
  @override
  AuthState build() {
    return AuthState(
      isAuthenticated: true,
      user: User(
        id: '1',
        firstName: 'Test',
        lastName: 'User',
        email: 'test@test.com',
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final List<RouteInfo> dummyRoutes = [
  RouteInfo(
    routeId: 1,
    routeShortName: '5',
    routeLongName: 'Linea 5',
    routeColor: '#FF0000',
  ),
  RouteInfo(
    routeId: 2,
    routeShortName: '8',
    routeLongName: 'Linea 8',
    routeColor: '#00FF00',
  ),
];

void main() {
  late FakeAuthRepository fakeRepo;

  setUp(() {
    fakeRepo = FakeAuthRepository();
  });

  List<Override> getTestOverrides() {
    return [
      authProvider.overrideWith(() => FakeAuthNotifier()),
      authRepositoryProvider.overrideWithValue(fakeRepo),
      allRoutesProvider.overrideWith((ref) => Future.value(dummyRoutes)),
    ];
  }

  group('FavoritesManagementBody Tests', () {
    testWidgets(
      'Mostra correttamente le linee e riconosce quella preferita iniziale',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestApp(
            child: const FavoritesManagementBody(),
            overrides: getTestOverrides(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Favorite Lines'), findsOneWidget);
        expect(find.text('Save Changes'), findsOneWidget);

        expect(find.text('5'), findsOneWidget);
        expect(find.text('8'), findsOneWidget);

        final animatedOpacity5 = tester.widget<AnimatedOpacity>(
          find
              .ancestor(
                of: find.text('5'),
                matching: find.byType(AnimatedOpacity),
              )
              .first,
        );
        final animatedOpacity8 = tester.widget<AnimatedOpacity>(
          find
              .ancestor(
                of: find.text('8'),
                matching: find.byType(AnimatedOpacity),
              )
              .first,
        );

        expect(animatedOpacity5.opacity, 1.0);
        expect(animatedOpacity8.opacity, 0.4);
      },
    );

    testWidgets('Cliccare su una linea ne cambia lo stato visivo (Toggle)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(
          child: const FavoritesManagementBody(),
          overrides: getTestOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('8'));
      await tester.pumpAndSettle();

      final animatedOpacity8 = tester.widget<AnimatedOpacity>(
        find
            .ancestor(
              of: find.text('8'),
              matching: find.byType(AnimatedOpacity),
            )
            .first,
      );
      expect(animatedOpacity8.opacity, 1.0);
    });

    testWidgets(
      'Cliccare "Save Changes" chiama il repository e mostra lo snackbar di successo',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestApp(
            child: const FavoritesManagementBody(),
            overrides: getTestOverrides(),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('8'));
        await tester.tap(find.text('5'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Save Changes'));

        await tester.pump();
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pumpAndSettle();

        expect(fakeRepo.saveWasCalled, isTrue);
        expect(fakeRepo.currentFavorites, contains(2));
        expect(fakeRepo.currentFavorites, isNot(contains(1)));

        expect(find.text('Favorites saved successfully!'), findsOneWidget);
      },
    );

    testWidgets('Mostra uno snackbar di errore se il salvataggio fallisce', (
      WidgetTester tester,
    ) async {
      fakeRepo.shouldThrowOnSave = true;

      await tester.pumpWidget(
        createTestApp(
          child: const FavoritesManagementBody(),
          overrides: getTestOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save Changes'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Errore simulato dal server'), findsOneWidget);
    });
  });
}
