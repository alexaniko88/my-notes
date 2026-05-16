import 'package:intl/intl.dart';
import 'package:my_notes/gen/app_localizations.dart';

extension DateTimeExtensions on DateTime {
  String toNoteLabel(AppLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final updated = DateTime(year, month, day);

    final time = DateFormat('h:mm a').format(this);

    if (updated == today) {
      return l10n.noteUpdatedTodayAt(time);
    } else if (updated == yesterday) {
      return l10n.noteUpdatedYesterdayAt(time);
    } else {
      return l10n.noteUpdatedDateAt(DateFormat('MMM d').format(this), time);
    }
  }
}
