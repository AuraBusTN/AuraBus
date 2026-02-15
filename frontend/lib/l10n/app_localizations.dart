import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it'),
  ];

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your journey'**
  String get signInSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get noAccount;

  /// No description provided for @signUpLink.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpLink;

  /// No description provided for @yourTicketsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Tickets'**
  String get yourTicketsTitle;

  /// No description provided for @continueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get continueWith;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @tickets.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get tickets;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @accountInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Account Info'**
  String get accountInfoSection;

  /// No description provided for @subscriptionSection.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscriptionSection;

  /// No description provided for @contactUsSection.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUsSection;

  /// No description provided for @rankingSection.
  ///
  /// In en, this message translates to:
  /// **'Ranking'**
  String get rankingSection;

  /// No description provided for @logoutButton.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutButton;

  /// No description provided for @editProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Edit your profile picture'**
  String get editProfilePicture;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @busNotificationLabel.
  ///
  /// In en, this message translates to:
  /// **'Bus Coming Notification'**
  String get busNotificationLabel;

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorMessage(String error);

  /// No description provided for @lineTitle.
  ///
  /// In en, this message translates to:
  /// **'Line {route}'**
  String lineTitle(String route);

  /// No description provided for @arrivingIn.
  ///
  /// In en, this message translates to:
  /// **'Here in {minutes}m'**
  String arrivingIn(int minutes);

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountTitle;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join us and start your journey'**
  String get createAccountSubtitle;

  /// No description provided for @firstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstNameLabel;

  /// No description provided for @lastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastNameLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @signupButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signupButton;

  /// No description provided for @orSignUpWith.
  ///
  /// In en, this message translates to:
  /// **'Or sign up with'**
  String get orSignUpWith;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Do you already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @termsError.
  ///
  /// In en, this message translates to:
  /// **'Please accept terms and conditions'**
  String get termsError;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid Email'**
  String get invalidEmail;

  /// No description provided for @passwordMinChars.
  ///
  /// In en, this message translates to:
  /// **'Min 6 chars'**
  String get passwordMinChars;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Mismatch'**
  String get passwordMismatch;

  /// No description provided for @termsText.
  ///
  /// In en, this message translates to:
  /// **'I agree with the '**
  String get termsText;

  /// No description provided for @termsLink.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsLink;

  /// No description provided for @andText.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get andText;

  /// No description provided for @privacyLink.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyLink;

  /// No description provided for @ticketUrbanService.
  ///
  /// In en, this message translates to:
  /// **'Urban Service'**
  String get ticketUrbanService;

  /// No description provided for @ticketCity.
  ///
  /// In en, this message translates to:
  /// **'TRENTO'**
  String get ticketCity;

  /// No description provided for @ticketVat.
  ///
  /// In en, this message translates to:
  /// **'VAT 01807370224'**
  String get ticketVat;

  /// No description provided for @ticketDuration70.
  ///
  /// In en, this message translates to:
  /// **'70 minutes'**
  String get ticketDuration70;

  /// No description provided for @ticketPrice120.
  ///
  /// In en, this message translates to:
  /// **'€ 1.20'**
  String get ticketPrice120;

  /// No description provided for @ticketValidateAction.
  ///
  /// In en, this message translates to:
  /// **'Validate'**
  String get ticketValidateAction;

  /// No description provided for @ticketStatusUnused.
  ///
  /// In en, this message translates to:
  /// **'UNUSED'**
  String get ticketStatusUnused;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @subscriptionCardTitle.
  ///
  /// In en, this message translates to:
  /// **'LIBERA CIRCOLAZIONE UNITN'**
  String get subscriptionCardTitle;

  /// No description provided for @subscriptionCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Code:'**
  String get subscriptionCodeLabel;

  /// No description provided for @subscriptionStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status:'**
  String get subscriptionStatusLabel;

  /// No description provided for @subscriptionTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type:'**
  String get subscriptionTypeLabel;

  /// No description provided for @subscriptionStartDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Start date:'**
  String get subscriptionStartDateLabel;

  /// No description provided for @subscriptionExpirationDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Expiration Date:'**
  String get subscriptionExpirationDateLabel;

  /// No description provided for @statusValid.
  ///
  /// In en, this message translates to:
  /// **'Valid'**
  String get statusValid;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @rankingTitle.
  ///
  /// In en, this message translates to:
  /// **'AuraRanking'**
  String get rankingTitle;

  /// No description provided for @tiersAndRewards.
  ///
  /// In en, this message translates to:
  /// **'Tiers & Rewards'**
  String get tiersAndRewards;

  /// No description provided for @globalLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'Global Leaderboard'**
  String get globalLeaderboard;

  /// No description provided for @noUsersInLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'No users in the leaderboard yet.'**
  String get noUsersInLeaderboard;

  /// No description provided for @errorLoadingLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'Error loading leaderboard'**
  String get errorLoadingLeaderboard;

  /// No description provided for @yourTier.
  ///
  /// In en, this message translates to:
  /// **'YOUR TIER'**
  String get yourTier;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'POINTS'**
  String get points;

  /// No description provided for @pointsAbbr.
  ///
  /// In en, this message translates to:
  /// **'pts'**
  String get pointsAbbr;

  /// No description provided for @maxLevelReached.
  ///
  /// In en, this message translates to:
  /// **'Max level reached!'**
  String get maxLevelReached;

  /// No description provided for @nextTier.
  ///
  /// In en, this message translates to:
  /// **'Next:'**
  String get nextTier;

  /// No description provided for @missingPoints.
  ///
  /// In en, this message translates to:
  /// **'missing'**
  String get missingPoints;

  /// No description provided for @tierElite.
  ///
  /// In en, this message translates to:
  /// **'Elite'**
  String get tierElite;

  /// No description provided for @tierGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get tierGold;

  /// No description provided for @tierSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get tierSilver;

  /// No description provided for @tierBronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze'**
  String get tierBronze;

  /// No description provided for @rewardAnnual.
  ///
  /// In en, this message translates to:
  /// **'Annual Subscription'**
  String get rewardAnnual;

  /// No description provided for @rewardMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly Subscription'**
  String get rewardMonthly;

  /// No description provided for @reward10Rides.
  ///
  /// In en, this message translates to:
  /// **'10 Free Rides'**
  String get reward10Rides;

  /// No description provided for @reward2Rides.
  ///
  /// In en, this message translates to:
  /// **'2 Free Rides'**
  String get reward2Rides;

  /// No description provided for @youLabel.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get youLabel;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search stop...'**
  String get searchPlaceholder;

  /// No description provided for @favoritesManagementSection.
  ///
  /// In en, this message translates to:
  /// **'Manage Favorites'**
  String get favoritesManagementSection;

  /// No description provided for @favoriteLinesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Favorite Lines'**
  String get favoriteLinesSubtitle;

  /// No description provided for @noLinesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No lines available.'**
  String get noLinesAvailable;

  /// No description provided for @errorLoadingLines.
  ///
  /// In en, this message translates to:
  /// **'Error loading lines: {error}'**
  String errorLoadingLines(String error);

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveButton;

  /// No description provided for @favoritesSaved.
  ///
  /// In en, this message translates to:
  /// **'Favorites saved successfully!'**
  String get favoritesSaved;

  /// No description provided for @legalSection.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legalSection;

  /// No description provided for @termsOfServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfServiceTitle;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String lastUpdated(String date);

  /// No description provided for @tosIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'1. Introduction'**
  String get tosIntroTitle;

  /// No description provided for @tosIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Welcome to AuraBus (\"the App\"). These Terms of Service (\"Terms\") govern your access to and use of the AuraBus mobile application, operated by AuraBus (\"we\", \"us\", or \"our\"). By downloading, installing, or using the App, you agree to be bound by these Terms. If you do not agree, please do not use the App.'**
  String get tosIntroBody;

  /// No description provided for @tosEligibilityTitle.
  ///
  /// In en, this message translates to:
  /// **'2. Eligibility'**
  String get tosEligibilityTitle;

  /// No description provided for @tosEligibilityBody.
  ///
  /// In en, this message translates to:
  /// **'You must be at least 16 years of age to use the App. By using AuraBus, you represent and warrant that you meet this age requirement and have the legal capacity to enter into these Terms.'**
  String get tosEligibilityBody;

  /// No description provided for @tosAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'3. User Account'**
  String get tosAccountTitle;

  /// No description provided for @tosAccountBody.
  ///
  /// In en, this message translates to:
  /// **'To access certain features, you must create an account by providing accurate and complete information. You are responsible for maintaining the confidentiality of your credentials and for all activities that occur under your account. Notify us immediately of any unauthorized use.'**
  String get tosAccountBody;

  /// No description provided for @tosServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'4. Service Description'**
  String get tosServiceTitle;

  /// No description provided for @tosServiceBody.
  ///
  /// In en, this message translates to:
  /// **'AuraBus provides real-time public transportation information for the city of Trento, including bus routes, stop locations, arrival times, ticketing, and gamification features. The information is provided for convenience and may not always reflect real-time conditions.'**
  String get tosServiceBody;

  /// No description provided for @tosUseTitle.
  ///
  /// In en, this message translates to:
  /// **'5. Acceptable Use'**
  String get tosUseTitle;

  /// No description provided for @tosUseBody.
  ///
  /// In en, this message translates to:
  /// **'You agree not to: (a) use the App for any unlawful purpose; (b) attempt to gain unauthorized access to our systems; (c) interfere with the proper functioning of the App; (d) reverse engineer, decompile, or disassemble any part of the App; (e) use automated means to access the App without our permission.'**
  String get tosUseBody;

  /// No description provided for @tosIpTitle.
  ///
  /// In en, this message translates to:
  /// **'6. Intellectual Property'**
  String get tosIpTitle;

  /// No description provided for @tosIpBody.
  ///
  /// In en, this message translates to:
  /// **'All content, features, and functionality of the App — including but not limited to text, graphics, logos, icons, and software — are the exclusive property of AuraBus and are protected by applicable intellectual property laws. You are granted a limited, non-exclusive, non-transferable license to use the App for personal, non-commercial purposes.'**
  String get tosIpBody;

  /// No description provided for @tosTicketsTitle.
  ///
  /// In en, this message translates to:
  /// **'7. Tickets & Payments'**
  String get tosTicketsTitle;

  /// No description provided for @tosTicketsBody.
  ///
  /// In en, this message translates to:
  /// **'Digital tickets purchased through the App are subject to the terms and conditions of the local transport operator. AuraBus acts as a digital interface and is not responsible for service disruptions, route changes, or ticket validity disputes with the transport provider.'**
  String get tosTicketsBody;

  /// No description provided for @tosDisclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'8. Disclaimer of Warranties'**
  String get tosDisclaimerTitle;

  /// No description provided for @tosDisclaimerBody.
  ///
  /// In en, this message translates to:
  /// **'The App is provided \"as is\" and \"as available\" without warranties of any kind, either express or implied. We do not guarantee that the App will be uninterrupted, error-free, or that real-time data will be accurate. Use of the App is at your own risk.'**
  String get tosDisclaimerBody;

  /// No description provided for @tosLiabilityTitle.
  ///
  /// In en, this message translates to:
  /// **'9. Limitation of Liability'**
  String get tosLiabilityTitle;

  /// No description provided for @tosLiabilityBody.
  ///
  /// In en, this message translates to:
  /// **'To the fullest extent permitted by law, AuraBus shall not be liable for any indirect, incidental, special, consequential, or punitive damages arising from your use of the App, including but not limited to missed buses, incorrect schedule information, or data loss.'**
  String get tosLiabilityBody;

  /// No description provided for @tosTerminationTitle.
  ///
  /// In en, this message translates to:
  /// **'10. Termination'**
  String get tosTerminationTitle;

  /// No description provided for @tosTerminationBody.
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to suspend or terminate your account at any time, without prior notice, if you violate these Terms or engage in conduct that we determine to be harmful to other users or the App.'**
  String get tosTerminationBody;

  /// No description provided for @tosChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'11. Changes to Terms'**
  String get tosChangesTitle;

  /// No description provided for @tosChangesBody.
  ///
  /// In en, this message translates to:
  /// **'We may update these Terms from time to time. We will notify you of material changes through the App or via email. Your continued use of the App after such changes constitutes acceptance of the updated Terms.'**
  String get tosChangesBody;

  /// No description provided for @tosGoverningTitle.
  ///
  /// In en, this message translates to:
  /// **'12. Governing Law'**
  String get tosGoverningTitle;

  /// No description provided for @tosGoverningBody.
  ///
  /// In en, this message translates to:
  /// **'These Terms shall be governed by and construed in accordance with the laws of Italy. Any disputes arising under these Terms shall be subject to the exclusive jurisdiction of the courts of Trento, Italy.'**
  String get tosGoverningBody;

  /// No description provided for @tosContactTitle.
  ///
  /// In en, this message translates to:
  /// **'13. Contact Us'**
  String get tosContactTitle;

  /// No description provided for @tosContactBody.
  ///
  /// In en, this message translates to:
  /// **'If you have questions about these Terms, please contact us at: support@aurabus.it'**
  String get tosContactBody;

  /// No description provided for @ppIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'1. Introduction'**
  String get ppIntroTitle;

  /// No description provided for @ppIntroBody.
  ///
  /// In en, this message translates to:
  /// **'AuraBus (\"we\", \"us\", or \"our\") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use the AuraBus mobile application (\"the App\"). Please read this policy carefully. By using the App, you consent to the practices described herein.'**
  String get ppIntroBody;

  /// No description provided for @ppDataCollectedTitle.
  ///
  /// In en, this message translates to:
  /// **'2. Information We Collect'**
  String get ppDataCollectedTitle;

  /// No description provided for @ppDataCollectedBody.
  ///
  /// In en, this message translates to:
  /// **'We collect the following categories of information:\n\n• Personal Information: name, email address, and profile picture when you create an account or sign in with Google.\n• Location Data: your device\'s geographic location to provide nearby stops and real-time transit information (only when you grant permission).\n• Usage Data: information about how you interact with the App, including pages viewed, features used, and session duration.\n• Device Information: device type, operating system, unique device identifiers, and network information.'**
  String get ppDataCollectedBody;

  /// No description provided for @ppHowWeUseTitle.
  ///
  /// In en, this message translates to:
  /// **'3. How We Use Your Information'**
  String get ppHowWeUseTitle;

  /// No description provided for @ppHowWeUseBody.
  ///
  /// In en, this message translates to:
  /// **'We use the collected information to:\n\n• Provide, maintain, and improve the App\'s functionality.\n• Display real-time bus information and nearby stops.\n• Manage your account, subscriptions, and ticket purchases.\n• Operate the gamification and ranking system.\n• Send service-related notifications (e.g., bus approaching alerts).\n• Analyze usage patterns to improve user experience.\n• Ensure security and prevent fraud.'**
  String get ppHowWeUseBody;

  /// No description provided for @ppDataSharingTitle.
  ///
  /// In en, this message translates to:
  /// **'4. Data Sharing & Disclosure'**
  String get ppDataSharingTitle;

  /// No description provided for @ppDataSharingBody.
  ///
  /// In en, this message translates to:
  /// **'We do not sell your personal information. We may share your data with:\n\n• Service Providers: third-party vendors who assist in operating the App (e.g., cloud hosting, analytics).\n• Legal Obligations: when required by law, regulation, or legal process.\n• Safety: to protect the rights, property, or safety of AuraBus, our users, or the public.\n• Business Transfers: in connection with a merger, acquisition, or sale of assets.'**
  String get ppDataSharingBody;

  /// No description provided for @ppDataStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'5. Data Storage & Security'**
  String get ppDataStorageTitle;

  /// No description provided for @ppDataStorageBody.
  ///
  /// In en, this message translates to:
  /// **'Your data is stored on secure servers within the European Union. We implement industry-standard security measures including encryption, access controls, and regular security audits. However, no method of transmission over the Internet is 100% secure, and we cannot guarantee absolute security.'**
  String get ppDataStorageBody;

  /// No description provided for @ppRetentionTitle.
  ///
  /// In en, this message translates to:
  /// **'6. Data Retention'**
  String get ppRetentionTitle;

  /// No description provided for @ppRetentionBody.
  ///
  /// In en, this message translates to:
  /// **'We retain your personal data for as long as your account is active or as needed to provide our services. Upon account deletion, we will remove your personal data within 30 days, except where retention is required by law.'**
  String get ppRetentionBody;

  /// No description provided for @ppRightsTitle.
  ///
  /// In en, this message translates to:
  /// **'7. Your Rights (GDPR)'**
  String get ppRightsTitle;

  /// No description provided for @ppRightsBody.
  ///
  /// In en, this message translates to:
  /// **'Under the General Data Protection Regulation (GDPR), you have the right to:\n\n• Access: request a copy of the personal data we hold about you.\n• Rectification: request correction of inaccurate data.\n• Erasure: request deletion of your personal data (\"right to be forgotten\").\n• Restriction: request restriction of processing of your data.\n• Portability: receive your data in a structured, machine-readable format.\n• Objection: object to the processing of your personal data.\n• Withdraw Consent: withdraw consent at any time without affecting prior processing.\n\nTo exercise these rights, contact us at: privacy@aurabus.it'**
  String get ppRightsBody;

  /// No description provided for @ppChildrenTitle.
  ///
  /// In en, this message translates to:
  /// **'8. Children\'s Privacy'**
  String get ppChildrenTitle;

  /// No description provided for @ppChildrenBody.
  ///
  /// In en, this message translates to:
  /// **'The App is not intended for children under 16 years of age. We do not knowingly collect personal information from children under 16. If we discover such data has been collected, we will promptly delete it.'**
  String get ppChildrenBody;

  /// No description provided for @ppCookiesTitle.
  ///
  /// In en, this message translates to:
  /// **'9. Cookies & Tracking'**
  String get ppCookiesTitle;

  /// No description provided for @ppCookiesBody.
  ///
  /// In en, this message translates to:
  /// **'The App may use local storage and analytics tools to improve performance and user experience. These do not track you across other applications or websites. You can manage your preferences through your device settings.'**
  String get ppCookiesBody;

  /// No description provided for @ppChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'10. Changes to This Policy'**
  String get ppChangesTitle;

  /// No description provided for @ppChangesBody.
  ///
  /// In en, this message translates to:
  /// **'We may update this Privacy Policy periodically. We will notify you of significant changes through the App or via email. The \"Last Updated\" date at the top of this page indicates when the policy was last revised.'**
  String get ppChangesBody;

  /// No description provided for @ppContactTitle.
  ///
  /// In en, this message translates to:
  /// **'11. Contact Us'**
  String get ppContactTitle;

  /// No description provided for @ppContactBody.
  ///
  /// In en, this message translates to:
  /// **'If you have questions or concerns about this Privacy Policy, or wish to exercise your data rights, please contact our Data Protection Officer at:\n\nEmail: privacy@aurabus.it\nAddress: AuraBus, Trento, Italy'**
  String get ppContactBody;

  /// No description provided for @ppDpoTitle.
  ///
  /// In en, this message translates to:
  /// **'12. Data Protection Officer'**
  String get ppDpoTitle;

  /// No description provided for @ppDpoBody.
  ///
  /// In en, this message translates to:
  /// **'We have appointed a Data Protection Officer (DPO) to oversee compliance with data protection regulations. You may contact the DPO at privacy@aurabus.it for any data protection inquiries.'**
  String get ppDpoBody;

  /// No description provided for @expandAllLabel.
  ///
  /// In en, this message translates to:
  /// **'Expand'**
  String get expandAllLabel;

  /// No description provided for @collapseAllLabel.
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get collapseAllLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
