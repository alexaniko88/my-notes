import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_notes/shared/navigation/app_route.dart';

/// The home-screen title. A hidden developer gesture: pressing and holding it
/// for [_pressDuration] opens the widget playground.
class PlaygroundTitle extends StatefulWidget {
  final String label;

  const PlaygroundTitle({super.key, required this.label});

  @override
  State<PlaygroundTitle> createState() => _PlaygroundTitleState();
}

class _PlaygroundTitleState extends State<PlaygroundTitle> {
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
