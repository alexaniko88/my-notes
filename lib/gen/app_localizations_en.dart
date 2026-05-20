// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'My Notes';

  @override
  String get notesEmptyState => 'No notes yet';

  @override
  String get addNote => 'Add note';

  @override
  String get fabOptionText => 'Text';

  @override
  String get fabOptionImage => 'Image';

  @override
  String get fabOptionAudio => 'Audio';

  @override
  String get fabOptionPdf => 'PDF';

  @override
  String noteLastUpdated(String timeLabel) {
    return 'Last updated: $timeLabel';
  }

  @override
  String noteUpdatedTodayAt(String time) {
    return 'today at $time';
  }

  @override
  String noteUpdatedYesterdayAt(String time) {
    return 'yesterday at $time';
  }

  @override
  String noteUpdatedDateAt(String date, String time) {
    return '$date at $time';
  }

  @override
  String get searchHint => 'Search notes';

  @override
  String get searchNoResults => 'No matching notes';

  @override
  String get noteTitleHint => 'Title';

  @override
  String get noteBodyHint => 'Note';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get authErrorEmptyFields => 'Please enter your email and password.';

  @override
  String get signOut => 'Sign Out';

  @override
  String get exitAppTitle => 'Exit app?';

  @override
  String get exitAppConfirm => 'Exit';

  @override
  String get exitAppCancel => 'Cancel';
}
