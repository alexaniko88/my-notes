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

  @override
  String noteLastUpdated(String timeLabel) {
    return 'Última actualización: $timeLabel';
  }

  @override
  String noteUpdatedTodayAt(String time) {
    return 'hoy a las $time';
  }

  @override
  String noteUpdatedYesterdayAt(String time) {
    return 'ayer a las $time';
  }

  @override
  String noteUpdatedDateAt(String date, String time) {
    return '$date a las $time';
  }

  @override
  String get searchHint => 'Buscar notas';

  @override
  String get searchNoResults => 'Sin notas coincidentes';

  @override
  String get noteTitleHint => 'Título';

  @override
  String get noteBodyHint => 'Nota';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get signUp => 'Registrarse';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get noAccount => '¿No tienes una cuenta?';

  @override
  String get haveAccount => '¿Ya tienes una cuenta?';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get gmailOnly => 'Solo cuentas de Gmail';

  @override
  String get authErrorEmptyFields =>
      'Por favor ingresa tu correo y contraseña.';
}
