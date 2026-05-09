import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_notes/presentation/widgets/home/fab_notes.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';
import 'package:my_notes/shared/navigation/app_route.dart';

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
      appBar: AppBar(title: _PlaygroundTitle(label: l10n.appTitle)),
      body: Stack(
        children: [
          _NotesBody(emptyLabel: l10n.notesEmptyState),
          FabNotes(options: options),
        ],
      ),
    );
  }
}

class _PlaygroundTitle extends StatefulWidget {
  const _PlaygroundTitle({required this.label});

  final String label;

  @override
  State<_PlaygroundTitle> createState() => _PlaygroundTitleState();
}

class _PlaygroundTitleState extends State<_PlaygroundTitle> {
  static const _pressDuration = Duration(seconds: 3);

  Timer? _timer;

  void _onTapDown(TapDownDetails _) {
    _timer = Timer(_pressDuration, () {
      if (mounted) context.push(AppRoute.playground.path);
    });
  }

  void _onTapUp(TapUpDetails _) => _cancelTimer();

  void _onTapCancel() => _cancelTimer();

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Text(widget.label),
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
