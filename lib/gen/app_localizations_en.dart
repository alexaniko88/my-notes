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
}
