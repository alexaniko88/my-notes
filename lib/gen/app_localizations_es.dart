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
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get authErrorNetwork =>
      'Error de red. Verifica tu conexión e inténtalo de nuevo.';

  @override
  String get authErrorUnknown => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get signOutConfirmTitle =>
      '¿Estás seguro de que quieres cerrar sesión?';

  @override
  String get signOutConfirm => 'Cerrar sesión';

  @override
  String get exitAppTitle => '¿Salir de la app?';

  @override
  String get exitAppConfirm => 'Salir';

  @override
  String get exitAppCancel => 'Cancelar';

  @override
  String get labelsSectionTitle => 'Etiquetas';

  @override
  String get labelsEdit => 'Editar';

  @override
  String get createNewLabel => 'Crear etiqueta';

  @override
  String get editLabelsTitle => 'Editar etiquetas';

  @override
  String get deleteLabelDialogTitle => '¿Eliminar etiqueta?';

  @override
  String get deleteLabelDialogBody =>
      'Eliminaremos esta etiqueta y la quitaremos de todas tus notas. Tus notas no se eliminarán.';

  @override
  String get deleteLabelConfirm => 'Eliminar';

  @override
  String get labelsLoadError => 'No se pudieron cargar las etiquetas';

  @override
  String get labelSaveError =>
      'No se pudo guardar la etiqueta. Inténtalo de nuevo.';

  @override
  String get labelNoNotes => 'No hay notas con esta etiqueta';

  @override
  String get labelSearchHint => 'Nombre de la etiqueta';

  @override
  String labelCreateNew(String name) {
    return 'Crear \"$name\"';
  }

  @override
  String labelMaxReached(int count) {
    return 'Puedes añadir hasta $count etiquetas';
  }

  @override
  String get trash => 'Papelera';

  @override
  String get trashEmptyState => 'No hay notas en la papelera';

  @override
  String get trashRetentionNotice =>
      'Las notas de la papelera se eliminan después de 7 días';

  @override
  String get noteDelete => 'Eliminar';
}
