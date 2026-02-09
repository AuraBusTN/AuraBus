// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get welcomeBack => 'Bentornato!';

  @override
  String get signInSubtitle => 'Accedi per continuare il viaggio';

  @override
  String get emailLabel => 'Indirizzo Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Accedi';

  @override
  String get noAccount => 'Non hai un account? ';

  @override
  String get signUpLink => 'Registrati';

  @override
  String get yourTicketsTitle => 'I Miei Biglietti';

  @override
  String get continueWith => 'o continua con';

  @override
  String get forgotPassword => 'Password Dimenticata?';

  @override
  String get tickets => 'Biglietti';

  @override
  String get map => 'Mappa';

  @override
  String get account => 'Account';

  @override
  String get accountSettings => 'Impostazioni Account';

  @override
  String get accountInfoSection => 'Info Account';

  @override
  String get subscriptionSection => 'Abbonamento';

  @override
  String get contactUsSection => 'Contattaci';

  @override
  String get rankingSection => 'Classifica';

  @override
  String get logoutButton => 'Esci';

  @override
  String get editProfilePicture => 'Modifica foto profilo';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get busNotificationLabel => 'Notifica Bus in arrivo';

  @override
  String errorMessage(String error) {
    return 'Errore: $error';
  }

  @override
  String lineTitle(String route) {
    return 'Linea $route';
  }

  @override
  String arrivingIn(int minutes) {
    return 'Qui tra ${minutes}m';
  }

  @override
  String get createAccountTitle => 'Crea Account';

  @override
  String get createAccountSubtitle => 'Unisciti a noi e inizia il viaggio';

  @override
  String get firstNameLabel => 'Nome';

  @override
  String get lastNameLabel => 'Cognome';

  @override
  String get confirmPasswordLabel => 'Conferma Password';

  @override
  String get signupButton => 'Registrati';

  @override
  String get orSignUpWith => 'O registrati con';

  @override
  String get alreadyHaveAccount => 'Hai già un account? ';

  @override
  String get termsError => 'Accetta i termini e condizioni';

  @override
  String get requiredField => 'Obbligatorio';

  @override
  String get invalidEmail => 'Email non valida';

  @override
  String get passwordMinChars => 'Min 6 caratt.';

  @override
  String get passwordMismatch => 'Non corrispondono';

  @override
  String get termsText => 'Accetto i ';

  @override
  String get termsLink => 'Termini & Condizioni';

  @override
  String get andText => ' e la ';

  @override
  String get privacyLink => 'Privacy Policy';

  @override
  String get ticketUrbanService => 'Servizio Urbano';

  @override
  String get ticketCity => 'TRENTO';

  @override
  String get ticketVat => 'P.IVA 01807370224';

  @override
  String get ticketDuration70 => '70 minuti';

  @override
  String get ticketPrice120 => '€ 1.20';

  @override
  String get ticketValidateAction => 'Convalida';

  @override
  String get ticketStatusUnused => 'INUTILIZZATO';

  @override
  String get signInWithGoogle => 'Accedi con Google';

  @override
  String get subscriptionCardTitle => 'LIBERA CIRCOLAZIONE UNITN';

  @override
  String get subscriptionCodeLabel => 'Codice:';

  @override
  String get subscriptionStatusLabel => 'Stato:';

  @override
  String get subscriptionTypeLabel => 'Tipo:';

  @override
  String get subscriptionStartDateLabel => 'Data inizio:';

  @override
  String get subscriptionExpirationDateLabel => 'Data scadenza:';

  @override
  String get statusValid => 'Valido';

  @override
  String get clear => 'Reset';

  @override
  String get rankingTitle => 'AuraRanking';

  @override
  String get tiersAndRewards => 'Fasce e Premi';

  @override
  String get globalLeaderboard => 'Classifica Globale';

  @override
  String get noUsersInLeaderboard => 'Nessun utente in classifica.';

  @override
  String get errorLoadingLeaderboard => 'Errore caricamento classifica';

  @override
  String get yourTier => 'LA TUA FASCIA';

  @override
  String get points => 'PUNTI';

  @override
  String get pointsAbbr => 'pti';

  @override
  String get maxLevelReached => 'Livello massimo raggiunto!';

  @override
  String get nextTier => 'Prossima:';

  @override
  String get missingPoints => 'mancanti';

  @override
  String get tierElite => 'Elite';

  @override
  String get tierGold => 'Gold';

  @override
  String get tierSilver => 'Silver';

  @override
  String get tierBronze => 'Bronze';

  @override
  String get rewardAnnual => 'Abbonamento Annuale';

  @override
  String get rewardMonthly => 'Abbonamento Mensile';

  @override
  String get reward10Rides => '10 Corse Gratis';

  @override
  String get reward2Rides => '2 Corse Gratis';

  @override
  String get youLabel => 'Tu';

  @override
  String get searchPlaceholder => 'Cerca fermata...';
  
  @override
  String get favoritesSection => 'Preferiti';
  
  @override
  String get privacyLoadError => 'Errore caricamento Privacy Policy';
  
  @override
  String get termsLoadError => 'Errore caricamento Termini e Condizioni';
  
  @override
  String get userPlaceholder => 'Utente';
  
  @override
  String get favoritesTitle => 'Preferiti';
}
