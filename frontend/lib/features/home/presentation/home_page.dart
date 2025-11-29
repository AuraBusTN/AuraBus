import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:aurabus/routing/router.dart';
import 'package:aurabus/features/account/presentation/account_page.dart';
import 'package:aurabus/features/map/presentation/map_screen.dart';
import 'package:aurabus/features/tickets/presentation/ticket_page.dart';
import 'package:aurabus/l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  final Widget child;
  const HomePage({super.key, required this.child});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _indexFromLocation(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    if (loc.startsWith(AppRoute.tickets)) return 0;
    if (loc.startsWith(AppRoute.map)) return 1;
    if (loc.startsWith(AppRoute.account)) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _indexFromLocation(context);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [TicketPage(), MapScreen(), AccountPage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) {
          switch (i) {
            case 0:
              context.go(AppRoute.tickets);
              break;
            case 1:
              context.go(AppRoute.map);
              break;
            case 2:
              context.go(AppRoute.account);
              break;
          }
        },
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
