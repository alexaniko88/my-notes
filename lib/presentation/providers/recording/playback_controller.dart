import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:my_notes/presentation/providers/recording/playback_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'playback_controller.g.dart';

@riverpod
class PlaybackController extends _$PlaybackController {
  final AudioPlayer _player = AudioPlayer();
  String? _loadedSource;

  @override
  PlaybackState build() {
    final positionSub = _player.positionStream.listen((position) {
      // just_audio extrapolates position between native ticks, so during
      // playback it emits small backward values that make the seek bar jitter.
      // Keep the displayed position monotonic while playing; seek() and the
      // completion reset apply legitimate rewinds to state directly.
      if (_player.playing && position < state.position) {
        return;
      }
      state = state.copyWith(position: position);
    });
    final durationSub = _player.durationStream.listen((duration) {
      if (duration != null) {
        state = state.copyWith(duration: duration);
      }
    });
    final stateSub = _player.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        unawaited(_player.pause());
        unawaited(_player.seek(Duration.zero));
        state = state.copyWith(isPlaying: false, position: Duration.zero);
      } else {
        state = state.copyWith(isPlaying: playerState.playing);
      }
    });
    ref.onDispose(() {
      unawaited(positionSub.cancel());
      unawaited(durationSub.cancel());
      unawaited(stateSub.cancel());
      unawaited(_player.dispose());
    });
    return const PlaybackState();
  }

  Future<void> loadFile(String path) =>
      _load(path, () => _player.setFilePath(path));

  Future<void> loadUrl(String url) => _load(url, () => _player.setUrl(url));

  Future<void> _load(String source, Future<Duration?> Function() setter) async {
    if (_loadedSource == source) {
      return;
    }
    _loadedSource = source;
    final duration = await setter();
    if (duration != null) {
      state = state.copyWith(duration: duration);
    }
  }

  Future<void> toggle() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      unawaited(_player.play());
    }
  }

  Future<void> seek(Duration position) async {
    // Apply the new position to state immediately so the monotonic guard above
    // accepts the forward stream that follows, and the thumb stays put.
    state = state.copyWith(position: position);
    await _player.seek(position);
  }

  Future<void> stop() async {
    await _player.stop();
    _loadedSource = null;
    state = const PlaybackState();
  }
}
