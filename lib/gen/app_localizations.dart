import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
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
    Locale('es'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'My Notes'**
  String get appTitle;

  /// Shown when the notes list is empty
  ///
  /// In en, this message translates to:
  /// **'No notes yet'**
  String get notesEmptyState;

  /// Tooltip for the add note FAB
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get addNote;

  /// FAB speed dial option — plain text note
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get fabOptionText;

  /// FAB speed dial option — image note
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get fabOptionImage;

  /// FAB speed dial option — voice recording note
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get fabOptionAudio;

  /// FAB speed dial option — PDF note
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get fabOptionPdf;

  /// Note card footer showing when the note was last updated
  ///
  /// In en, this message translates to:
  /// **'Last updated: {timeLabel}'**
  String noteLastUpdated(String timeLabel);

  /// Relative time label for a note updated today
  ///
  /// In en, this message translates to:
  /// **'today at {time}'**
  String noteUpdatedTodayAt(String time);

  /// Relative time label for a note updated yesterday
  ///
  /// In en, this message translates to:
  /// **'yesterday at {time}'**
  String noteUpdatedYesterdayAt(String time);

  /// Time label for a note updated on a specific date
  ///
  /// In en, this message translates to:
  /// **'{date} at {time}'**
  String noteUpdatedDateAt(String date, String time);

  /// Hint text in the search field
  ///
  /// In en, this message translates to:
  /// **'Search notes'**
  String get searchHint;

  /// Shown when search returns no results
  ///
  /// In en, this message translates to:
  /// **'No matching notes'**
  String get searchNoResults;

  /// Placeholder for the note title field
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get noteTitleHint;

  /// Placeholder for the note body field
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteBodyHint;

  /// Sign-in button label and screen title
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Label for the Google sign-up button
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// Error shown when sign-in fails due to a network issue
  ///
  /// In en, this message translates to:
  /// **'Network error. Check your connection and try again.'**
  String get authErrorNetwork;

  /// Generic error shown when sign-in fails for an unknown reason
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get authErrorUnknown;

  /// Sign-out action in the navigation drawer
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Title of the confirmation dialog before signing out
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutConfirmTitle;

  /// Confirm button in the sign-out dialog
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOutConfirm;

  /// Title of the confirmation dialog shown when the user tries to exit the app
  ///
  /// In en, this message translates to:
  /// **'Exit app?'**
  String get exitAppTitle;

  /// Confirm button in the exit-app dialog
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exitAppConfirm;

  /// Cancel button in the exit-app dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get exitAppCancel;

  /// Header of the labels section in the navigation drawer
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get labelsSectionTitle;

  /// Button in the labels section header that opens label editing
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get labelsEdit;

  /// Row in the labels section that creates a new label
  ///
  /// In en, this message translates to:
  /// **'Create new label'**
  String get createNewLabel;

  /// App bar title of the edit labels screen
  ///
  /// In en, this message translates to:
  /// **'Edit labels'**
  String get editLabelsTitle;

  /// Title of the confirmation dialog before deleting a label
  ///
  /// In en, this message translates to:
  /// **'Delete label?'**
  String get deleteLabelDialogTitle;

  /// Body of the confirmation dialog before deleting a label
  ///
  /// In en, this message translates to:
  /// **'We\'ll delete this label and remove it from all of your notes. Your notes won\'t be deleted.'**
  String get deleteLabelDialogBody;

  /// Confirm button in the delete-label dialog
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteLabelConfirm;

  /// Shown on the edit labels screen when the labels stream fails
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load labels'**
  String get labelsLoadError;

  /// Snackbar shown when adding, renaming, or deleting a label fails
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save label. Try again.'**
  String get labelSaveError;

  /// Shown when the active label filter matches no notes
  ///
  /// In en, this message translates to:
  /// **'No notes with this label'**
  String get labelNoNotes;

  /// Hint in the label picker search field
  ///
  /// In en, this message translates to:
  /// **'Enter label name'**
  String get labelSearchHint;

  /// Row in the label picker that creates a label from the search query
  ///
  /// In en, this message translates to:
  /// **'Create \"{name}\"'**
  String labelCreateNew(String name);

  /// Snackbar shown when trying to select more labels than allowed on a note
  ///
  /// In en, this message translates to:
  /// **'You can add up to {count} labels'**
  String labelMaxReached(int count);

  /// Trash section in the navigation drawer and the trash screen title
  ///
  /// In en, this message translates to:
  /// **'Trash'**
  String get trash;

  /// Shown on the trash screen when there are no deleted notes
  ///
  /// In en, this message translates to:
  /// **'No notes in Trash'**
  String get trashEmptyState;

  /// Notice on the trash screen explaining the auto-delete retention period
  ///
  /// In en, this message translates to:
  /// **'Notes in Trash are deleted after 7 days'**
  String get trashRetentionNotice;

  /// Delete action in the note options menu
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get noteDelete;

  /// Restore action in the trashed note options menu
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get noteRestore;

  /// Permanent delete action in the trashed note options menu
  ///
  /// In en, this message translates to:
  /// **'Delete forever'**
  String get noteDeleteForever;

  /// Drawer item that shows all notes without any filter
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get allNotes;

  /// Snackbar shown when trashing, restoring, or deleting a note fails
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get noteActionError;

  /// Title of the confirmation dialog before permanently deleting a note
  ///
  /// In en, this message translates to:
  /// **'Delete forever?'**
  String get deleteForeverDialogTitle;

  /// Body of the confirmation dialog before permanently deleting a note
  ///
  /// In en, this message translates to:
  /// **'This note will be permanently deleted.'**
  String get deleteForeverDialogBody;
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
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
