import 'package:flutter/material.dart';
import 'package:my_notes/presentation/widgets/home/fab_notes.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final options = [
      (Icons.text_fields, l10n.fabOptionText),
      (Icons.image_outlined, l10n.fabOptionImage),
      (Icons.mic_outlined, l10n.fabOptionAudio),
      (Icons.picture_as_pdf_outlined, l10n.fabOptionPdf),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: Stack(
        children: [
          _NotesBody(emptyLabel: l10n.notesEmptyState),
          FabNotes(options: options),
        ],
      ),
    );
  }
}

class _NotesBody extends StatelessWidget {
  const _NotesBody({required this.emptyLabel});

  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        emptyLabel,
        style: theme.textTheme.bodyLarge,
      ),
    );
  }
}
