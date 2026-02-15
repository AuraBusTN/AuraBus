import 'package:aurabus/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:aurabus/routing/router.dart';
import 'package:aurabus/l10n/app_localizations.dart';

class HomePage extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const HomePage({super.key, required this.navigationShell});

  void _onItemTapped(int index, BuildContext context, WidgetRef ref) {
    if (index == 2) {
      final isLoggedIn = ref.read(authProvider).isAuthenticated;

      if (!isLoggedIn) {
        context.push(AppRoute.login);
        return;
      }
    }

    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: navigationShell,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => _onItemTapped(index, context, ref),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.confirmation_number_outlined),
            label: AppLocalizations.of(context)!.tickets,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.map_outlined),
            label: AppLocalizations.of(context)!.map,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            label: AppLocalizations.of(context)!.account,
          ),
        ],
      ),
    );
  }
}
