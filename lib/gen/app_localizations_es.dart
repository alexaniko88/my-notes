// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Mis Notas';

  @override
  String get notesEmptyState => 'Aún no hay notas';

  @override
  String get addNote => 'Agregar nota';

  @override
  String get fabOptionText => 'Texto';

  @override
  String get fabOptionImage => 'Imagen';

  @override
  String get fabOptionAudio => 'Audio';

  @override
  String get fabOptionPdf => 'PDF';
}
