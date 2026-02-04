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
}
