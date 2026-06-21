import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_notes/presentation/providers/recording/playback_controller.dart';
import 'package:my_notes/presentation/widgets/common/app_icon.dart';
import 'package:my_notes/presentation/widgets/common/app_icon_button.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';

String _formatDuration(Duration duration) {
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

class AudioPlayerBar extends ConsumerStatefulWidget {
  final String source;
  final bool isUrl;
  final Duration fallbackDuration;
  final VoidCallback? onDelete;

  const AudioPlayerBar({
    super.key,
    required this.source,
    this.isUrl = false,
    this.fallbackDuration = Duration.zero,
    this.onDelete,
  });

  @override
  ConsumerState<AudioPlayerBar> createState() => _AudioPlayerBarState();
}

class _AudioPlayerBarState extends ConsumerState<AudioPlayerBar> {
  // While the user drags, the thumb follows this instead of the player's
  // position stream (which would otherwise fight the gesture and jump).
  double? _dragMs;

  @override
  void initState() {
    super.initState();
    final notifier = ref.read(playbackControllerProvider.notifier);
    unawaited(
      widget.isUrl
          ? notifier.loadUrl(widget.source)
          : notifier.loadFile(widget.source),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.dimensions.spacing;
    final timeStyle = theme.textTheme.labelMedium;
    final borderColor = theme.colorScheme.outlineVariant;
    final borderRadius = BorderRadius.circular(
      context.dimensions.borderRadius.md,
    );

    final playback = ref.watch(playbackControllerProvider);
    final totalMs =
        playback.duration.inMilliseconds > 0
            ? playback.duration.inMilliseconds
            : widget.fallbackDuration.inMilliseconds;
    final isSeekable = totalMs > 0;
    final maxMs = isSeekable ? totalMs.toDouble() : 1.0;
    final positionMs = playback.position.inMilliseconds.clamp(0, totalMs);
    final sliderMs =
        (_dragMs ?? positionMs.toDouble()).clamp(0.0, maxMs).toDouble();

    final onDelete = widget.onDelete;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            AppIconButton(
              icon: playback.isPlaying ? AppIconName.pause : AppIconName.play,
              onPressed:
                  () => ref.read(playbackControllerProvider.notifier).toggle(),
            ),
            Expanded(
              child: Slider(
                value: sliderMs,
                max: maxMs,
                onChanged:
                    isSeekable
                        ? (value) => setState(() => _dragMs = value)
                        : null,
                onChangeEnd:
                    isSeekable
                        ? (value) {
                          ref
                              .read(playbackControllerProvider.notifier)
                              .seek(Duration(milliseconds: value.round()));
                          setState(() => _dragMs = null);
                        }
                        : null,
              ),
            ),
            if (onDelete != null)
              AppIconButton(
                icon: AppIconName.deleteOutlined,
                onPressed: onDelete,
              ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(Duration(milliseconds: sliderMs.round())),
                style: timeStyle,
              ),
              Text(
                _formatDuration(Duration(milliseconds: totalMs)),
                style: timeStyle,
              ),
            ],
          ),
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: borderRadius,
      ),
      child: content,
    );
  }
}
