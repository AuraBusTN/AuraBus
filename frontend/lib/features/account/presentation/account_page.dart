import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:aurabus/features/account/widgets/account_info_body.dart';
import 'package:aurabus/features/account/widgets/account_section.dart';
import 'package:aurabus/features/account/widgets/favorite_management_body.dart';
import 'package:aurabus/features/account/widgets/subscription_body.dart';
import 'package:aurabus/features/auth/presentation/providers/auth_provider.dart';
import 'package:aurabus/routing/router.dart';
import 'package:aurabus/theme.dart';

enum AccountSectionType { info, subscription, favorites, ranking }

class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key});
  @override
  ConsumerState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  final Set<AccountSectionType> expandedSections = {};
  bool busNotificationEnabled = true;

  void toggleSection(AccountSectionType section) {
    setState(() {
      expandedSections.contains(section)
          ? expandedSections.remove(section)
          : expandedSections.add(section);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(authProvider).user;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(
                l10n.accountSettings,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),

              AccountSection(
                title: l10n.accountInfoSection,
                isExpanded: expandedSections.contains(AccountSectionType.info),
                onTap: () => toggleSection(AccountSectionType.info),
                child: AccountInfoBody(
                  firstName: user?.firstName ?? "Utente",
                  lastName: user?.lastName ?? "",
                  email: user?.email ?? "",
                  profilePictureUrl: user?.picture,
                  busNotificationEnabled: busNotificationEnabled,
                  onNotificationToggle: (v) =>
                      setState(() => busNotificationEnabled = v),
                ),
              ),
              const SizedBox(height: 12),

              AccountSection(
                title: l10n.subscriptionSection,
                isExpanded: expandedSections.contains(
                  AccountSectionType.subscription,
                ),
                onTap: () => toggleSection(AccountSectionType.subscription),
                child: const SubscriptionBody(),
              ),
              const SizedBox(height: 12),

              AccountSection(
                title: l10n.favoritesManagementSection,
                isExpanded: expandedSections.contains(
                  AccountSectionType.favorites,
                ),
                onTap: () => toggleSection(AccountSectionType.favorites),
                child: const FavoritesManagementBody(),
              ),
              const SizedBox(height: 12),

              AccountSection(
                title: l10n.rankingSection,
                isExpanded: expandedSections.contains(
                  AccountSectionType.ranking,
                ),
                onTap: () => context.push(AppRoute.ranking),
              ),
              const SizedBox(height: 12),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.description_outlined,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      title: Text(
                        l10n.termsOfServiceTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push(AppRoute.termsOfService),
                    ),
                    Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: Colors.grey.shade200,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.shield_outlined,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      title: Text(
                        l10n.privacyPolicyTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push(AppRoute.privacyPolicy),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              AccountSection(
                title: l10n.logoutButton,
                isExpanded: false,
                onTap: () async {
                  await ref.read(authProvider.notifier).logout();

                  if (context.mounted) {
                    context.go(AppRoute.map);
                    context.push(AppRoute.login);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
