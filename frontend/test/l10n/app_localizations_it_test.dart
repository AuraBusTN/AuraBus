import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:aurabus/theme.dart';

void main() {
  Widget buildLocalizedApp(Widget child) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('it'),
      theme: AppTheme.lightTheme,
      home: Scaffold(body: child),
    );
  }

  late AppLocalizations l10n;

  Future<void> loadLocale(WidgetTester tester) async {
    await tester.pumpWidget(
      buildLocalizedApp(
        Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return const SizedBox();
          },
        ),
      ),
    );
  }

  group('Italian Localization', () {
    testWidgets('loads Italian locale', (tester) async {
      await loadLocale(tester);
      expect(l10n.localeName, 'it');
    });

    testWidgets('auth strings are in Italian', (tester) async {
      await loadLocale(tester);
      expect(l10n.welcomeBack, isNotEmpty);
      expect(l10n.emailLabel, isNotEmpty);
      expect(l10n.passwordLabel, isNotEmpty);
      expect(l10n.loginButton, isNotEmpty);
      expect(l10n.signupButton, isNotEmpty);
      expect(l10n.forgotPassword, isNotEmpty);
      expect(l10n.requiredField, isNotEmpty);
      expect(l10n.invalidEmail, isNotEmpty);
      expect(l10n.signInSubtitle, isNotEmpty);
      expect(l10n.continueWith, isNotEmpty);
      expect(l10n.noAccount, isNotEmpty);
      expect(l10n.signUpLink, isNotEmpty);
    });

    testWidgets('signup strings are in Italian', (tester) async {
      await loadLocale(tester);
      expect(l10n.createAccountTitle, isNotEmpty);
      expect(l10n.createAccountSubtitle, isNotEmpty);
      expect(l10n.firstNameLabel, isNotEmpty);
      expect(l10n.lastNameLabel, isNotEmpty);
      expect(l10n.confirmPasswordLabel, isNotEmpty);
      expect(l10n.passwordMinChars, isNotEmpty);
      expect(l10n.passwordMismatch, isNotEmpty);
      expect(l10n.orSignUpWith, isNotEmpty);
      expect(l10n.alreadyHaveAccount, isNotEmpty);
      expect(l10n.termsError, isNotEmpty);
    });

    testWidgets('ticket strings are in Italian', (tester) async {
      await loadLocale(tester);
      expect(l10n.yourTicketsTitle, isNotEmpty);
      expect(l10n.ticketUrbanService, isNotEmpty);
      expect(l10n.ticketCity, isNotEmpty);
      expect(l10n.ticketStatusUnused, isNotEmpty);
      expect(l10n.ticketDuration70, isNotEmpty);
      expect(l10n.ticketPrice120, isNotEmpty);
      expect(l10n.ticketValidateAction, isNotEmpty);
      expect(l10n.ticketVat, isNotEmpty);
    });

    testWidgets('account strings are in Italian', (tester) async {
      await loadLocale(tester);
      expect(l10n.editProfilePicture, isNotEmpty);
      expect(l10n.busNotificationLabel, isNotEmpty);
      expect(l10n.subscriptionCardTitle, isNotEmpty);
      expect(l10n.accountSettings, isNotEmpty);
      expect(l10n.accountInfoSection, isNotEmpty);
      expect(l10n.subscriptionSection, isNotEmpty);
      expect(l10n.contactUsSection, isNotEmpty);
      expect(l10n.rankingSection, isNotEmpty);
      expect(l10n.logoutButton, isNotEmpty);
      expect(l10n.settingsTitle, isNotEmpty);
      expect(l10n.subscriptionCodeLabel, isNotEmpty);
      expect(l10n.subscriptionStatusLabel, isNotEmpty);
      expect(l10n.subscriptionTypeLabel, isNotEmpty);
      expect(l10n.subscriptionStartDateLabel, isNotEmpty);
      expect(l10n.subscriptionExpirationDateLabel, isNotEmpty);
      expect(l10n.statusValid, isNotEmpty);
      expect(l10n.favoritesManagementSection, isNotEmpty);
      expect(l10n.favoriteLinesSubtitle, isNotEmpty);
      expect(l10n.noLinesAvailable, isNotEmpty);
      expect(l10n.errorLoadingLines('err'), isNotEmpty);
      expect(l10n.saveButton, isNotEmpty);
      expect(l10n.favoritesSaved, isNotEmpty);
      expect(l10n.legalSection, isNotEmpty);
    });

    testWidgets('ranking strings are in Italian', (tester) async {
      await loadLocale(tester);
      expect(l10n.rewardAnnual, isNotEmpty);
      expect(l10n.rewardMonthly, isNotEmpty);
      expect(l10n.reward10Rides, isNotEmpty);
      expect(l10n.reward2Rides, isNotEmpty);
      expect(l10n.rankingTitle, isNotEmpty);
      expect(l10n.tiersAndRewards, isNotEmpty);
      expect(l10n.globalLeaderboard, isNotEmpty);
      expect(l10n.noUsersInLeaderboard, isNotEmpty);
      expect(l10n.errorLoadingLeaderboard, isNotEmpty);
      expect(l10n.yourTier, isNotEmpty);
      expect(l10n.points, isNotEmpty);
      expect(l10n.pointsAbbr, isNotEmpty);
      expect(l10n.maxLevelReached, isNotEmpty);
      expect(l10n.nextTier, isNotEmpty);
      expect(l10n.missingPoints, isNotEmpty);
      expect(l10n.tierElite, isNotEmpty);
      expect(l10n.tierGold, isNotEmpty);
      expect(l10n.tierSilver, isNotEmpty);
      expect(l10n.tierBronze, isNotEmpty);
      expect(l10n.youLabel, isNotEmpty);
    });

    testWidgets('legal strings are in Italian', (tester) async {
      await loadLocale(tester);
      expect(l10n.termsOfServiceTitle, isNotEmpty);
      expect(l10n.privacyPolicyTitle, isNotEmpty);
      expect(l10n.termsText, isNotEmpty);
      expect(l10n.termsLink, isNotEmpty);
      expect(l10n.privacyLink, isNotEmpty);
      expect(l10n.andText, isNotEmpty);
      expect(l10n.lastUpdated('2024-01-01'), isNotEmpty);
    });

    testWidgets('TOS section strings are in Italian', (tester) async {
      await loadLocale(tester);
      expect(l10n.tosIntroTitle, isNotEmpty);
      expect(l10n.tosIntroBody, isNotEmpty);
      expect(l10n.tosEligibilityTitle, isNotEmpty);
      expect(l10n.tosEligibilityBody, isNotEmpty);
      expect(l10n.tosAccountTitle, isNotEmpty);
      expect(l10n.tosAccountBody, isNotEmpty);
      expect(l10n.tosServiceTitle, isNotEmpty);
      expect(l10n.tosServiceBody, isNotEmpty);
      expect(l10n.tosUseTitle, isNotEmpty);
      expect(l10n.tosUseBody, isNotEmpty);
      expect(l10n.tosIpTitle, isNotEmpty);
      expect(l10n.tosIpBody, isNotEmpty);
      expect(l10n.tosTicketsTitle, isNotEmpty);
      expect(l10n.tosTicketsBody, isNotEmpty);
      expect(l10n.tosDisclaimerTitle, isNotEmpty);
      expect(l10n.tosDisclaimerBody, isNotEmpty);
      expect(l10n.tosLiabilityTitle, isNotEmpty);
      expect(l10n.tosLiabilityBody, isNotEmpty);
      expect(l10n.tosTerminationTitle, isNotEmpty);
      expect(l10n.tosTerminationBody, isNotEmpty);
      expect(l10n.tosChangesTitle, isNotEmpty);
      expect(l10n.tosChangesBody, isNotEmpty);
      expect(l10n.tosGoverningTitle, isNotEmpty);
      expect(l10n.tosGoverningBody, isNotEmpty);
      expect(l10n.tosContactTitle, isNotEmpty);
      expect(l10n.tosContactBody, isNotEmpty);
    });

    testWidgets('Privacy Policy section strings are in Italian', (
      tester,
    ) async {
      await loadLocale(tester);
      expect(l10n.ppIntroTitle, isNotEmpty);
      expect(l10n.ppIntroBody, isNotEmpty);
      expect(l10n.ppDataCollectedTitle, isNotEmpty);
      expect(l10n.ppDataCollectedBody, isNotEmpty);
      expect(l10n.ppHowWeUseTitle, isNotEmpty);
      expect(l10n.ppHowWeUseBody, isNotEmpty);
      expect(l10n.ppDataSharingTitle, isNotEmpty);
      expect(l10n.ppDataSharingBody, isNotEmpty);
      expect(l10n.ppDataStorageTitle, isNotEmpty);
      expect(l10n.ppDataStorageBody, isNotEmpty);
      expect(l10n.ppRetentionTitle, isNotEmpty);
      expect(l10n.ppRetentionBody, isNotEmpty);
      expect(l10n.ppRightsTitle, isNotEmpty);
      expect(l10n.ppRightsBody, isNotEmpty);
      expect(l10n.ppChildrenTitle, isNotEmpty);
      expect(l10n.ppChildrenBody, isNotEmpty);
      expect(l10n.ppCookiesTitle, isNotEmpty);
      expect(l10n.ppCookiesBody, isNotEmpty);
      expect(l10n.ppChangesTitle, isNotEmpty);
      expect(l10n.ppChangesBody, isNotEmpty);
      expect(l10n.ppContactTitle, isNotEmpty);
      expect(l10n.ppContactBody, isNotEmpty);
      expect(l10n.ppDpoTitle, isNotEmpty);
      expect(l10n.ppDpoBody, isNotEmpty);
    });

    testWidgets('map and nav strings are in Italian', (tester) async {
      await loadLocale(tester);
      expect(l10n.clear, isNotEmpty);
      expect(l10n.arrivingIn(5), isNotEmpty);
      expect(l10n.errorMessage('test'), isNotEmpty);
      expect(l10n.signInWithGoogle, isNotEmpty);
      expect(l10n.searchPlaceholder, isNotEmpty);
      expect(l10n.lineTitle('42'), isNotEmpty);
      expect(l10n.tickets, isNotEmpty);
      expect(l10n.map, isNotEmpty);
      expect(l10n.account, isNotEmpty);
    });
  });
}
