import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:aurabus/routing/router.dart';
import 'package:aurabus/features/account/widgets/account_info_body.dart';
import 'package:aurabus/features/account/widgets/account_section.dart';
import 'package:aurabus/features/account/widgets/contact_us_body.dart';
import 'package:aurabus/features/account/widgets/subscription_body.dart';

enum AccountSectionType { info, subscription, contact, ranking }

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
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
                title: l10n.contactUsSection,
                isExpanded: expandedSections.contains(
                  AccountSectionType.contact,
                ),
                onTap: () => toggleSection(AccountSectionType.contact),
                child: const ContactUsBody(),
              ),
              const SizedBox(height: 12),

              AccountSection(
                title: l10n.rankingSection,
                isExpanded: expandedSections.contains(
                  AccountSectionType.ranking,
                ),
                onTap: () => toggleSection(AccountSectionType.ranking),
              ),
              const SizedBox(height: 12),
              AccountSection(
                title: l10n.logoutButton,
                isExpanded: false,
                onTap: () => context.push(AppRoute.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
