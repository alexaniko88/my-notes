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
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get authErrorNetwork =>
      'Network error. Check your connection and try again.';

  @override
  String get authErrorUnknown => 'Something went wrong. Please try again.';

  @override
  String get signOut => 'Sign Out';

  @override
  String get signOutConfirmTitle => 'Are you sure you want to sign out?';

  @override
  String get signOutConfirm => 'Sign Out';

  @override
  String get exitAppTitle => 'Exit app?';

  @override
  String get exitAppConfirm => 'Exit';

  @override
  String get exitAppCancel => 'Cancel';

  @override
  String get labelsSectionTitle => 'Labels';

  @override
  String get labelsEdit => 'Edit';

  @override
  String get createNewLabel => 'Create new label';

  @override
  String get editLabelsTitle => 'Edit labels';

  @override
  String get deleteLabelDialogTitle => 'Delete label?';

  @override
  String get deleteLabelDialogBody =>
      'We\'ll delete this label and remove it from all of your notes. Your notes won\'t be deleted.';

  @override
  String get deleteLabelConfirm => 'Delete';

  @override
  String get labelsLoadError => 'Couldn\'t load labels';

  @override
  String get labelSaveError => 'Couldn\'t save label. Try again.';

  @override
  String get labelNoNotes => 'No notes with this label';

  @override
  String get labelSearchHint => 'Enter label name';

  @override
  String labelCreateNew(String name) {
    return 'Create \"$name\"';
  }

  @override
  String labelMaxReached(int count) {
    return 'You can add up to $count labels';
  }

  @override
  String get trash => 'Trash';

  @override
  String get trashEmptyState => 'No notes in Trash';

  @override
  String get trashRetentionNotice => 'Notes in Trash are deleted after 7 days';

  @override
  String get noteDelete => 'Delete';

  @override
  String get noteRestore => 'Restore';

  @override
  String get noteDeleteForever => 'Delete forever';

  @override
  String get allNotes => 'Notes';

  @override
  String get noteActionError => 'Something went wrong. Try again.';

  @override
  String get deleteForeverDialogTitle => 'Delete forever?';

  @override
  String get deleteForeverDialogBody =>
      'This note will be permanently deleted.';

  @override
  String get sectionPinned => 'Pinned';

  @override
  String get sectionOthers => 'Others';
}
