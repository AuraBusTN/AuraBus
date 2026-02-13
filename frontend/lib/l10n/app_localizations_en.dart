// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get signInSubtitle => 'Sign in to continue your journey';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Login';

  @override
  String get noAccount => 'Don\'t have an account? ';

  @override
  String get signUpLink => 'Sign Up';

  @override
  String get yourTicketsTitle => 'My Tickets';

  @override
  String get continueWith => 'Or continue with';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get tickets => 'Tickets';

  @override
  String get map => 'Map';

  @override
  String get account => 'Account';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get accountInfoSection => 'Account Info';

  @override
  String get subscriptionSection => 'Subscription';

  @override
  String get contactUsSection => 'Contact Us';

  @override
  String get rankingSection => 'Ranking';

  @override
  String get logoutButton => 'Logout';

  @override
  String get editProfilePicture => 'Edit your profile picture';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get busNotificationLabel => 'Bus Coming Notification';

  @override
  String errorMessage(String error) {
    return 'Error: $error';
  }

  @override
  String lineTitle(String route) {
    return 'Line $route';
  }

  @override
  String arrivingIn(int minutes) {
    return 'Here in ${minutes}m';
  }

  @override
  String get createAccountTitle => 'Create Account';

  @override
  String get createAccountSubtitle => 'Join us and start your journey';

  @override
  String get firstNameLabel => 'First Name';

  @override
  String get lastNameLabel => 'Last Name';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get signupButton => 'Sign Up';

  @override
  String get orSignUpWith => 'Or sign up with';

  @override
  String get alreadyHaveAccount => 'Do you already have an account? ';

  @override
  String get termsError => 'Please accept terms and conditions';

  @override
  String get requiredField => 'Required';

  @override
  String get invalidEmail => 'Invalid Email';

  @override
  String get passwordMinChars => 'Min 6 chars';

  @override
  String get passwordMismatch => 'Mismatch';

  @override
  String get termsText => 'I agree with the ';

  @override
  String get termsLink => 'Terms & Conditions';

  @override
  String get andText => ' and ';

  @override
  String get privacyLink => 'Privacy Policy';

  @override
  String get ticketUrbanService => 'Urban Service';

  @override
  String get ticketCity => 'TRENTO';

  @override
  String get ticketVat => 'VAT 01807370224';

  @override
  String get ticketDuration70 => '70 minutes';

  @override
  String get ticketPrice120 => '€ 1.20';

  @override
  String get ticketValidateAction => 'Validate';

  @override
  String get ticketStatusUnused => 'UNUSED';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get subscriptionCardTitle => 'LIBERA CIRCOLAZIONE UNITN';

  @override
  String get subscriptionCodeLabel => 'Code:';

  @override
  String get subscriptionStatusLabel => 'Status:';

  @override
  String get subscriptionTypeLabel => 'Type:';

  @override
  String get subscriptionStartDateLabel => 'Start date:';

  @override
  String get subscriptionExpirationDateLabel => 'Expiration Date:';

  @override
  String get statusValid => 'Valid';

  @override
  String get clear => 'Clear';

  @override
  String get rankingTitle => 'AuraRanking';

  @override
  String get tiersAndRewards => 'Tiers & Rewards';

  @override
  String get globalLeaderboard => 'Global Leaderboard';

  @override
  String get noUsersInLeaderboard => 'No users in the leaderboard yet.';

  @override
  String get errorLoadingLeaderboard => 'Error loading leaderboard';

  @override
  String get yourTier => 'YOUR TIER';

  @override
  String get points => 'POINTS';

  @override
  String get pointsAbbr => 'pts';

  @override
  String get maxLevelReached => 'Max level reached!';

  @override
  String get nextTier => 'Next:';

  @override
  String get missingPoints => 'missing';

  @override
  String get tierElite => 'Elite';

  @override
  String get tierGold => 'Gold';

  @override
  String get tierSilver => 'Silver';

  @override
  String get tierBronze => 'Bronze';

  @override
  String get rewardAnnual => 'Annual Subscription';

  @override
  String get rewardMonthly => 'Monthly Subscription';

  @override
  String get reward10Rides => '10 Free Rides';

  @override
  String get reward2Rides => '2 Free Rides';

  @override
  String get youLabel => 'You';

  @override
  String get searchPlaceholder => 'Search stop...';

  @override
  String get favoritesManagementSection => 'Manage Favorites';

  @override
  String get favoriteLinesSubtitle => 'Favorite Lines';

  @override
  String get noLinesAvailable => 'No lines available.';

  @override
  String errorLoadingLines(String error) {
    return 'Error loading lines: $error';
  }

  @override
  String get saveButton => 'Save Changes';

  @override
  String get favoritesSaved => 'Favorites saved successfully!';

  @override
  String get legalSection => 'Legal';

  @override
  String get termsOfServiceTitle => 'Terms of Service';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String lastUpdated(String date) {
    return 'Last updated: $date';
  }

  @override
  String get tosIntroTitle => '1. Introduction';

  @override
  String get tosIntroBody =>
      'Welcome to AuraBus (\"the App\"). These Terms of Service (\"Terms\") govern your access to and use of the AuraBus mobile application, operated by AuraBus (\"we\", \"us\", or \"our\"). By downloading, installing, or using the App, you agree to be bound by these Terms. If you do not agree, please do not use the App.';

  @override
  String get tosEligibilityTitle => '2. Eligibility';

  @override
  String get tosEligibilityBody =>
      'You must be at least 16 years of age to use the App. By using AuraBus, you represent and warrant that you meet this age requirement and have the legal capacity to enter into these Terms.';

  @override
  String get tosAccountTitle => '3. User Account';

  @override
  String get tosAccountBody =>
      'To access certain features, you must create an account by providing accurate and complete information. You are responsible for maintaining the confidentiality of your credentials and for all activities that occur under your account. Notify us immediately of any unauthorized use.';

  @override
  String get tosServiceTitle => '4. Service Description';

  @override
  String get tosServiceBody =>
      'AuraBus provides real-time public transportation information for the city of Trento, including bus routes, stop locations, arrival times, ticketing, and gamification features. The information is provided for convenience and may not always reflect real-time conditions.';

  @override
  String get tosUseTitle => '5. Acceptable Use';

  @override
  String get tosUseBody =>
      'You agree not to: (a) use the App for any unlawful purpose; (b) attempt to gain unauthorized access to our systems; (c) interfere with the proper functioning of the App; (d) reverse engineer, decompile, or disassemble any part of the App; (e) use automated means to access the App without our permission.';

  @override
  String get tosIpTitle => '6. Intellectual Property';

  @override
  String get tosIpBody =>
      'All content, features, and functionality of the App — including but not limited to text, graphics, logos, icons, and software — are the exclusive property of AuraBus and are protected by applicable intellectual property laws. You are granted a limited, non-exclusive, non-transferable license to use the App for personal, non-commercial purposes.';

  @override
  String get tosTicketsTitle => '7. Tickets & Payments';

  @override
  String get tosTicketsBody =>
      'Digital tickets purchased through the App are subject to the terms and conditions of the local transport operator. AuraBus acts as a digital interface and is not responsible for service disruptions, route changes, or ticket validity disputes with the transport provider.';

  @override
  String get tosDisclaimerTitle => '8. Disclaimer of Warranties';

  @override
  String get tosDisclaimerBody =>
      'The App is provided \"as is\" and \"as available\" without warranties of any kind, either express or implied. We do not guarantee that the App will be uninterrupted, error-free, or that real-time data will be accurate. Use of the App is at your own risk.';

  @override
  String get tosLiabilityTitle => '9. Limitation of Liability';

  @override
  String get tosLiabilityBody =>
      'To the fullest extent permitted by law, AuraBus shall not be liable for any indirect, incidental, special, consequential, or punitive damages arising from your use of the App, including but not limited to missed buses, incorrect schedule information, or data loss.';

  @override
  String get tosTerminationTitle => '10. Termination';

  @override
  String get tosTerminationBody =>
      'We reserve the right to suspend or terminate your account at any time, without prior notice, if you violate these Terms or engage in conduct that we determine to be harmful to other users or the App.';

  @override
  String get tosChangesTitle => '11. Changes to Terms';

  @override
  String get tosChangesBody =>
      'We may update these Terms from time to time. We will notify you of material changes through the App or via email. Your continued use of the App after such changes constitutes acceptance of the updated Terms.';

  @override
  String get tosGoverningTitle => '12. Governing Law';

  @override
  String get tosGoverningBody =>
      'These Terms shall be governed by and construed in accordance with the laws of Italy. Any disputes arising under these Terms shall be subject to the exclusive jurisdiction of the courts of Trento, Italy.';

  @override
  String get tosContactTitle => '13. Contact Us';

  @override
  String get tosContactBody =>
      'If you have questions about these Terms, please contact us at: support@aurabus.it';

  @override
  String get ppIntroTitle => '1. Introduction';

  @override
  String get ppIntroBody =>
      'AuraBus (\"we\", \"us\", or \"our\") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use the AuraBus mobile application (\"the App\"). Please read this policy carefully. By using the App, you consent to the practices described herein.';

  @override
  String get ppDataCollectedTitle => '2. Information We Collect';

  @override
  String get ppDataCollectedBody =>
      'We collect the following categories of information:\n\n• Personal Information: name, email address, and profile picture when you create an account or sign in with Google.\n• Location Data: your device\'s geographic location to provide nearby stops and real-time transit information (only when you grant permission).\n• Usage Data: information about how you interact with the App, including pages viewed, features used, and session duration.\n• Device Information: device type, operating system, unique device identifiers, and network information.';

  @override
  String get ppHowWeUseTitle => '3. How We Use Your Information';

  @override
  String get ppHowWeUseBody =>
      'We use the collected information to:\n\n• Provide, maintain, and improve the App\'s functionality.\n• Display real-time bus information and nearby stops.\n• Manage your account, subscriptions, and ticket purchases.\n• Operate the gamification and ranking system.\n• Send service-related notifications (e.g., bus approaching alerts).\n• Analyze usage patterns to improve user experience.\n• Ensure security and prevent fraud.';

  @override
  String get ppDataSharingTitle => '4. Data Sharing & Disclosure';

  @override
  String get ppDataSharingBody =>
      'We do not sell your personal information. We may share your data with:\n\n• Service Providers: third-party vendors who assist in operating the App (e.g., cloud hosting, analytics).\n• Legal Obligations: when required by law, regulation, or legal process.\n• Safety: to protect the rights, property, or safety of AuraBus, our users, or the public.\n• Business Transfers: in connection with a merger, acquisition, or sale of assets.';

  @override
  String get ppDataStorageTitle => '5. Data Storage & Security';

  @override
  String get ppDataStorageBody =>
      'Your data is stored on secure servers within the European Union. We implement industry-standard security measures including encryption, access controls, and regular security audits. However, no method of transmission over the Internet is 100% secure, and we cannot guarantee absolute security.';

  @override
  String get ppRetentionTitle => '6. Data Retention';

  @override
  String get ppRetentionBody =>
      'We retain your personal data for as long as your account is active or as needed to provide our services. Upon account deletion, we will remove your personal data within 30 days, except where retention is required by law.';

  @override
  String get ppRightsTitle => '7. Your Rights (GDPR)';

  @override
  String get ppRightsBody =>
      'Under the General Data Protection Regulation (GDPR), you have the right to:\n\n• Access: request a copy of the personal data we hold about you.\n• Rectification: request correction of inaccurate data.\n• Erasure: request deletion of your personal data (\"right to be forgotten\").\n• Restriction: request restriction of processing of your data.\n• Portability: receive your data in a structured, machine-readable format.\n• Objection: object to the processing of your personal data.\n• Withdraw Consent: withdraw consent at any time without affecting prior processing.\n\nTo exercise these rights, contact us at: privacy@aurabus.it';

  @override
  String get ppChildrenTitle => '8. Children\'s Privacy';

  @override
  String get ppChildrenBody =>
      'The App is not intended for children under 16 years of age. We do not knowingly collect personal information from children under 16. If we discover such data has been collected, we will promptly delete it.';

  @override
  String get ppCookiesTitle => '9. Cookies & Tracking';

  @override
  String get ppCookiesBody =>
      'The App may use local storage and analytics tools to improve performance and user experience. These do not track you across other applications or websites. You can manage your preferences through your device settings.';

  @override
  String get ppChangesTitle => '10. Changes to This Policy';

  @override
  String get ppChangesBody =>
      'We may update this Privacy Policy periodically. We will notify you of significant changes through the App or via email. The \"Last Updated\" date at the top of this page indicates when the policy was last revised.';

  @override
  String get ppContactTitle => '11. Contact Us';

  @override
  String get ppContactBody =>
      'If you have questions or concerns about this Privacy Policy, or wish to exercise your data rights, please contact our Data Protection Officer at:\n\nEmail: privacy@aurabus.it\nAddress: AuraBus, Trento, Italy';

  @override
  String get ppDpoTitle => '12. Data Protection Officer';

  @override
  String get ppDpoBody =>
      'We have appointed a Data Protection Officer (DPO) to oversee compliance with data protection regulations. You may contact the DPO at privacy@aurabus.it for any data protection inquiries.';
}
