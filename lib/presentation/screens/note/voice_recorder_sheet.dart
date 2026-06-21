import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:my_notes/domain/models/audio_storage_exception.dart';
import 'package:my_notes/domain/models/note_type.dart';
import 'package:my_notes/presentation/providers/notes/notes_provider.dart';
import 'package:my_notes/presentation/providers/recording/playback_controller.dart';
import 'package:my_notes/presentation/providers/recording/recording_controller.dart';
import 'package:my_notes/presentation/providers/recording/recording_state.dart';
import 'package:my_notes/presentation/widgets/common/app_button.dart';
import 'package:my_notes/presentation/widgets/common/app_icon.dart';
import 'package:my_notes/presentation/widgets/common/app_icon_button.dart';
import 'package:my_notes/presentation/widgets/note/audio_player_bar.dart';
import 'package:my_notes/presentation/widgets/note/voice_waveform.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> showVoiceRecorderSheet(
  BuildContext context, {
  String? targetNoteId,
}) {
  final screenWidth = MediaQuery.sizeOf(context).width;
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    constraints: BoxConstraints(maxWidth: screenWidth),
    builder: (_) => VoiceRecorderSheet(targetNoteId: targetNoteId),
  );
}

String _formatDuration(Duration duration) {
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

class VoiceRecorderSheet extends ConsumerStatefulWidget {
  final String? targetNoteId;

  const VoiceRecorderSheet({super.key, this.targetNoteId});

  @override
  ConsumerState<VoiceRecorderSheet> createState() => _VoiceRecorderSheetState();
}

class _VoiceRecorderSheetState extends ConsumerState<VoiceRecorderSheet> {
  static const _maxLevels = 48;

  final List<double> _levels = [];
  bool _isSaving = false;
  bool _saveFailed = false;

  RecordingController get _controller =>
      ref.read(recordingControllerProvider.notifier);

  void _onStateChanged(RecordingState? previous, RecordingState next) {
    if (next.status != RecordingStatus.recording) {
      return;
    }
    setState(() {
      _levels.add(next.amplitude);
      if (_levels.length > _maxLevels) {
        _levels.removeAt(0);
      }
    });
  }

  Future<void> _start() async {
    setState(() {
      _levels.clear();
      _saveFailed = false;
    });
    await _controller.start();
  }

  Future<void> _pause() => _controller.pause();

  Future<void> _resume() => _controller.resume();

  Future<void> _stop() => _controller.stop();

  Future<void> _discard() async {
    await ref.read(playbackControllerProvider.notifier).stop();
    await _controller.cancel();
  }

  Future<void> _close() async {
    await ref.read(playbackControllerProvider.notifier).stop();
    await _controller.cancel();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _save() async {
    final filePath = ref.read(recordingControllerProvider).filePath;
    if (filePath == null) {
      return;
    }
    setState(() {
      _isSaving = true;
      _saveFailed = false;
    });
    await ref.read(playbackControllerProvider.notifier).stop();
    final targetNoteId = widget.targetNoteId;
    try {
      final notifier = ref.read(notesProvider.notifier);
      if (targetNoteId != null) {
        await notifier.attachVoice(targetNoteId, filePath);
      } else {
        await notifier.add(type: NoteType.voice, filePath: filePath);
      }
      await _controller.cancel();
      if (mounted) {
        Navigator.of(context).pop();
      }
    } on AudioStorageException {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _saveFailed = true;
        });
      }
    }
  }

  Future<void> _openSettings() => openAppSettings();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final spacing = context.dimensions.spacing;
    final titleStyle = theme.textTheme.titleMedium;
    final state = ref.watch(recordingControllerProvider);

    ref.listen(recordingControllerProvider, _onStateChanged);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _close();
        }
      },
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(spacing.lg, 0, spacing.lg, spacing.xl),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.voiceRecorderTitle, style: titleStyle),
                Gap(spacing.xl),
                _body(state),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _body(RecordingState state) {
    return switch (state.status) {
      RecordingStatus.idle => _IdleBody(onStart: _start),
      RecordingStatus.recording || RecordingStatus.paused => _ActiveBody(
        state: state,
        levels: _levels,
        onStop: _stop,
        onPause: _pause,
        onResume: _resume,
      ),
      RecordingStatus.completed => _CompletedBody(
        filePath: state.filePath ?? '',
        elapsed: state.elapsed,
        isSaving: _isSaving,
        saveFailed: _saveFailed,
        onSave: _save,
        onDiscard: _discard,
      ),
      RecordingStatus.permissionDenied => _PermissionDeniedBody(
        onRetry: _start,
        onOpenSettings: _openSettings,
      ),
    };
  }
}

class _RecordButton extends StatelessWidget {
  final AppIconName icon;
  final VoidCallback onPressed;

  const _RecordButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final iconSize = context.dimensions.iconSize;

    return FloatingActionButton.large(
      heroTag: null,
      onPressed: onPressed,
      child: AppIcon(name: icon, size: iconSize.lg),
    );
  }
}

class _IdleBody extends StatelessWidget {
  final VoidCallback onStart;

  const _IdleBody({required this.onStart});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.dimensions.spacing;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _RecordButton(icon: AppIconName.micOutlined, onPressed: onStart),
        Gap(spacing.lg),
        Text(l10n.recordingTapToStart),
      ],
    );
  }
}

class _ActiveBody extends StatelessWidget {
  final RecordingState state;
  final List<double> levels;
  final VoidCallback onStop;
  final VoidCallback onPause;
  final VoidCallback onResume;

  const _ActiveBody({
    required this.state,
    required this.levels,
    required this.onStop,
    required this.onPause,
    required this.onResume,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final spacing = context.dimensions.spacing;
    final timerStyle = theme.textTheme.displaySmall;
    final isPaused = state.isPaused;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        VoiceWaveform(levels: levels),
        Gap(spacing.lg),
        Text(_formatDuration(state.elapsed), style: timerStyle),
        if (isPaused) ...[Gap(spacing.sm), Text(l10n.recordingPaused)],
        Gap(spacing.xl),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIconButton(
              icon: isPaused ? AppIconName.mic : AppIconName.pause,
              onPressed: isPaused ? onResume : onPause,
            ),
            Gap(spacing.lg),
            _RecordButton(icon: AppIconName.stop, onPressed: onStop),
          ],
        ),
      ],
    );
  }
}

class _CompletedBody extends StatelessWidget {
  final String filePath;
  final Duration elapsed;
  final bool isSaving;
  final bool saveFailed;
  final VoidCallback onSave;
  final VoidCallback onDiscard;

  const _CompletedBody({
    required this.filePath,
    required this.elapsed,
    required this.isSaving,
    required this.saveFailed,
    required this.onSave,
    required this.onDiscard,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final spacing = context.dimensions.spacing;
    final errorStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.error,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AudioPlayerBar(
          source: filePath,
          fallbackDuration: elapsed,
          onDelete: onDiscard,
        ),
        if (saveFailed) ...[
          Gap(spacing.md),
          Text(
            l10n.recordingSaveError,
            textAlign: TextAlign.center,
            style: errorStyle,
          ),
        ],
        Gap(spacing.xl),
        if (isSaving)
          const CircularProgressIndicator()
        else
          AppButton.primary(label: l10n.recordingSave, onPressed: onSave),
      ],
    );
  }
}

class _PermissionDeniedBody extends StatelessWidget {
  final VoidCallback onRetry;
  final VoidCallback onOpenSettings;

  const _PermissionDeniedBody({
    required this.onRetry,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.dimensions.spacing;
    final iconSize = context.dimensions.iconSize;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIcon(name: AppIconName.micOutlined, size: iconSize.xl),
        Gap(spacing.lg),
        Text(l10n.recordingPermissionDenied, textAlign: TextAlign.center),
        Gap(spacing.xl),
        AppButton.primary(label: l10n.recordingTryAgain, onPressed: onRetry),
        Gap(spacing.sm),
        AppButton.secondary(
          label: l10n.recordingOpenSettings,
          onPressed: onOpenSettings,
        ),
      ],
    );
  }
}
