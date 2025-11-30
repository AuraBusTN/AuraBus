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
