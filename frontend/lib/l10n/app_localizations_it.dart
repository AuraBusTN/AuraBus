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
  String get favoritesManagementSection => 'Gestione Preferiti';

  @override
  String get favoriteLinesSubtitle => 'Linee Preferite';

  @override
  String get noLinesAvailable => 'Nessuna linea disponibile.';

  @override
  String errorLoadingLines(String error) {
    return 'Errore caricamento linee: $error';
  }

  @override
  String get saveButton => 'Salva Modifiche';

  @override
  String get favoritesSaved => 'Preferiti salvati con successo!';

  @override
  String get legalSection => 'Legale';

  @override
  String get termsOfServiceTitle => 'Termini di Servizio';

  @override
  String get privacyPolicyTitle => 'Informativa sulla Privacy';

  @override
  String lastUpdated(String date) {
    return 'Ultimo aggiornamento: $date';
  }

  @override
  String get tosIntroTitle => '1. Introduzione';

  @override
  String get tosIntroBody =>
      'Benvenuto su AuraBus (\"l\'App\"). I presenti Termini di Servizio (\"Termini\") regolano l\'accesso e l\'utilizzo dell\'applicazione mobile AuraBus, gestita da AuraBus (\"noi\" o \"nostro\"). Scaricando, installando o utilizzando l\'App, accetti di essere vincolato da questi Termini. Se non sei d\'accordo, ti preghiamo di non utilizzare l\'App.';

  @override
  String get tosEligibilityTitle => '2. Requisiti di Età';

  @override
  String get tosEligibilityBody =>
      'Devi avere almeno 16 anni per utilizzare l\'App. Utilizzando AuraBus, dichiari e garantisci di soddisfare questo requisito di età e di avere la capacità giuridica di accettare questi Termini.';

  @override
  String get tosAccountTitle => '3. Account Utente';

  @override
  String get tosAccountBody =>
      'Per accedere a determinate funzionalità, è necessario creare un account fornendo informazioni accurate e complete. Sei responsabile della riservatezza delle tue credenziali e di tutte le attività svolte con il tuo account. Comunicaci immediatamente qualsiasi utilizzo non autorizzato.';

  @override
  String get tosServiceTitle => '4. Descrizione del Servizio';

  @override
  String get tosServiceBody =>
      'AuraBus fornisce informazioni in tempo reale sul trasporto pubblico nella città di Trento, incluse linee degli autobus, posizioni delle fermate, orari di arrivo, biglietteria e funzionalità di gamification. Le informazioni sono fornite per comodità e potrebbero non riflettere sempre le condizioni in tempo reale.';

  @override
  String get tosUseTitle => '5. Uso Consentito';

  @override
  String get tosUseBody =>
      'Ti impegni a non: (a) utilizzare l\'App per scopi illeciti; (b) tentare di accedere in modo non autorizzato ai nostri sistemi; (c) interferire con il corretto funzionamento dell\'App; (d) decompilare, disassemblare o eseguire reverse engineering di qualsiasi parte dell\'App; (e) utilizzare mezzi automatizzati per accedere all\'App senza il nostro permesso.';

  @override
  String get tosIpTitle => '6. Proprietà Intellettuale';

  @override
  String get tosIpBody =>
      'Tutti i contenuti, le funzionalità e le caratteristiche dell\'App — inclusi ma non limitati a testi, grafiche, loghi, icone e software — sono di proprietà esclusiva di AuraBus e sono protetti dalle leggi sulla proprietà intellettuale applicabili. Ti viene concessa una licenza limitata, non esclusiva e non trasferibile per l\'uso personale e non commerciale dell\'App.';

  @override
  String get tosTicketsTitle => '7. Biglietti e Pagamenti';

  @override
  String get tosTicketsBody =>
      'I biglietti digitali acquistati tramite l\'App sono soggetti ai termini e alle condizioni dell\'operatore di trasporto locale. AuraBus funge da interfaccia digitale e non è responsabile per interruzioni del servizio, modifiche dei percorsi o controversie sulla validità dei biglietti con il fornitore di trasporto.';

  @override
  String get tosDisclaimerTitle => '8. Esclusione di Garanzie';

  @override
  String get tosDisclaimerBody =>
      'L\'App è fornita \"così com\'è\" e \"come disponibile\" senza garanzie di alcun tipo, esplicite o implicite. Non garantiamo che l\'App sarà ininterrotta, priva di errori o che i dati in tempo reale saranno accurati. L\'utilizzo dell\'App è a tuo rischio.';

  @override
  String get tosLiabilityTitle => '9. Limitazione di Responsabilità';

  @override
  String get tosLiabilityBody =>
      'Nella misura massima consentita dalla legge, AuraBus non sarà responsabile per danni indiretti, incidentali, speciali, consequenziali o punitivi derivanti dall\'utilizzo dell\'App, inclusi ma non limitati a autobus persi, informazioni sugli orari errate o perdita di dati.';

  @override
  String get tosTerminationTitle => '10. Risoluzione';

  @override
  String get tosTerminationBody =>
      'Ci riserviamo il diritto di sospendere o terminare il tuo account in qualsiasi momento, senza preavviso, qualora tu violi questi Termini o adotti comportamenti che riteniamo dannosi per gli altri utenti o per l\'App.';

  @override
  String get tosChangesTitle => '11. Modifiche ai Termini';

  @override
  String get tosChangesBody =>
      'Potremmo aggiornare questi Termini di volta in volta. Ti informeremo delle modifiche sostanziali tramite l\'App o via email. L\'uso continuato dell\'App dopo tali modifiche costituisce accettazione dei Termini aggiornati.';

  @override
  String get tosGoverningTitle => '12. Legge Applicabile';

  @override
  String get tosGoverningBody =>
      'Questi Termini sono regolati e interpretati in conformità alle leggi italiane. Qualsiasi controversia derivante da questi Termini sarà soggetta alla giurisdizione esclusiva del Tribunale di Trento, Italia.';

  @override
  String get tosContactTitle => '13. Contattaci';

  @override
  String get tosContactBody =>
      'Per domande su questi Termini, contattaci a: support@aurabus.it';

  @override
  String get ppIntroTitle => '1. Introduzione';

  @override
  String get ppIntroBody =>
      'AuraBus (\"noi\" o \"nostro\") si impegna a proteggere la tua privacy. Questa Informativa sulla Privacy spiega come raccogliamo, utilizziamo, divulghiamo e proteggiamo le tue informazioni quando utilizzi l\'applicazione mobile AuraBus (\"l\'App\"). Ti preghiamo di leggere attentamente questa informativa. Utilizzando l\'App, acconsenti alle pratiche qui descritte.';

  @override
  String get ppDataCollectedTitle => '2. Informazioni che Raccogliamo';

  @override
  String get ppDataCollectedBody =>
      'Raccogliamo le seguenti categorie di informazioni:\n\n• Informazioni Personali: nome, indirizzo email e foto profilo quando crei un account o accedi con Google.\n• Dati di Localizzazione: la posizione geografica del tuo dispositivo per fornire fermate vicine e informazioni sul trasporto in tempo reale (solo con il tuo permesso).\n• Dati di Utilizzo: informazioni su come interagisci con l\'App, incluse pagine visualizzate, funzionalità utilizzate e durata delle sessioni.\n• Informazioni sul Dispositivo: tipo di dispositivo, sistema operativo, identificatori univoci del dispositivo e informazioni di rete.';

  @override
  String get ppHowWeUseTitle => '3. Come Utilizziamo le Tue Informazioni';

  @override
  String get ppHowWeUseBody =>
      'Utilizziamo le informazioni raccolte per:\n\n• Fornire, mantenere e migliorare le funzionalità dell\'App.\n• Mostrare informazioni in tempo reale sugli autobus e le fermate vicine.\n• Gestire il tuo account, abbonamenti e acquisto biglietti.\n• Gestire il sistema di gamification e classifica.\n• Inviare notifiche relative al servizio (es. avvisi autobus in arrivo).\n• Analizzare i modelli di utilizzo per migliorare l\'esperienza utente.\n• Garantire la sicurezza e prevenire le frodi.';

  @override
  String get ppDataSharingTitle => '4. Condivisione e Divulgazione dei Dati';

  @override
  String get ppDataSharingBody =>
      'Non vendiamo le tue informazioni personali. Potremmo condividere i tuoi dati con:\n\n• Fornitori di Servizi: fornitori terzi che assistono nel funzionamento dell\'App (es. hosting cloud, analytics).\n• Obblighi Legali: quando richiesto dalla legge, regolamento o procedimento legale.\n• Sicurezza: per proteggere i diritti, la proprietà o la sicurezza di AuraBus, dei nostri utenti o del pubblico.\n• Trasferimenti Aziendali: in relazione a fusioni, acquisizioni o vendita di asset.';

  @override
  String get ppDataStorageTitle => '5. Archiviazione e Sicurezza dei Dati';

  @override
  String get ppDataStorageBody =>
      'I tuoi dati sono archiviati su server sicuri all\'interno dell\'Unione Europea. Implementiamo misure di sicurezza standard del settore, tra cui crittografia, controlli degli accessi e audit di sicurezza regolari. Tuttavia, nessun metodo di trasmissione su Internet è sicuro al 100% e non possiamo garantire una sicurezza assoluta.';

  @override
  String get ppRetentionTitle => '6. Conservazione dei Dati';

  @override
  String get ppRetentionBody =>
      'Conserviamo i tuoi dati personali finché il tuo account è attivo o per il tempo necessario a fornire i nostri servizi. Alla cancellazione dell\'account, rimuoveremo i tuoi dati personali entro 30 giorni, salvo nei casi in cui la conservazione sia richiesta dalla legge.';

  @override
  String get ppRightsTitle => '7. I Tuoi Diritti (GDPR)';

  @override
  String get ppRightsBody =>
      'Ai sensi del Regolamento Generale sulla Protezione dei Dati (GDPR), hai diritto a:\n\n• Accesso: richiedere una copia dei dati personali che conserviamo su di te.\n• Rettifica: richiedere la correzione di dati inesatti.\n• Cancellazione: richiedere la cancellazione dei tuoi dati personali (\"diritto all\'oblio\").\n• Limitazione: richiedere la limitazione del trattamento dei tuoi dati.\n• Portabilità: ricevere i tuoi dati in un formato strutturato e leggibile da dispositivo automatico.\n• Opposizione: opporti al trattamento dei tuoi dati personali.\n• Revoca del Consenso: revocare il consenso in qualsiasi momento senza pregiudicare il trattamento precedente.\n\nPer esercitare questi diritti, contattaci a: privacy@aurabus.it';

  @override
  String get ppChildrenTitle => '8. Privacy dei Minori';

  @override
  String get ppChildrenBody =>
      'L\'App non è destinata a minori di 16 anni. Non raccogliamo consapevolmente informazioni personali da minori di 16 anni. Qualora scoprissimo che tali dati sono stati raccolti, li cancelleremo tempestivamente.';

  @override
  String get ppCookiesTitle => '9. Cookie e Tracciamento';

  @override
  String get ppCookiesBody =>
      'L\'App potrebbe utilizzare archiviazione locale e strumenti di analisi per migliorare le prestazioni e l\'esperienza utente. Questi non ti tracciano attraverso altre applicazioni o siti web. Puoi gestire le tue preferenze tramite le impostazioni del dispositivo.';

  @override
  String get ppChangesTitle => '10. Modifiche a Questa Informativa';

  @override
  String get ppChangesBody =>
      'Potremmo aggiornare periodicamente questa Informativa sulla Privacy. Ti informeremo delle modifiche significative tramite l\'App o via email. La data di \"Ultimo aggiornamento\" in cima a questa pagina indica l\'ultima revisione dell\'informativa.';

  @override
  String get ppContactTitle => '11. Contattaci';

  @override
  String get ppContactBody =>
      'Per domande o dubbi su questa Informativa sulla Privacy, o per esercitare i tuoi diritti sui dati, contatta il nostro Responsabile della Protezione dei Dati:\n\nEmail: privacy@aurabus.it\nIndirizzo: AuraBus, Trento, Italia';

  @override
  String get ppDpoTitle => '12. Responsabile della Protezione dei Dati';

  @override
  String get ppDpoBody =>
      'Abbiamo nominato un Responsabile della Protezione dei Dati (DPO) per supervisionare la conformità alle normative sulla protezione dei dati. Puoi contattare il DPO all\'indirizzo privacy@aurabus.it per qualsiasi richiesta relativa alla protezione dei dati.';

  @override
  String get expandAllLabel => 'Espandi';

  @override
  String get collapseAllLabel => 'Riduci';
}
