import 'dart:async';
import 'dart:io';

import 'package:my_notes/presentation/providers/recording/recording_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'recording_controller.g.dart';

@riverpod
class RecordingController extends _$RecordingController {
  // Microphone level (dBFS) treated as silence; anything quieter maps to 0 on
  // the normalized 0–1 amplitude scale, 0 dBFS maps to 1.
  static const _minDb = -45.0;
  static const _tickInterval = Duration(milliseconds: 200);
  static const _amplitudeInterval = Duration(milliseconds: 200);

  final AudioRecorder _recorder = AudioRecorder();
  final Stopwatch _stopwatch = Stopwatch();
  final Uuid _uuid = const Uuid();
  Timer? _ticker;
  StreamSubscription<Amplitude>? _amplitudeSub;

  @override
  RecordingState build() {
    ref.onDispose(() {
      _ticker?.cancel();
      unawaited(_amplitudeSub?.cancel());
      unawaited(_recorder.dispose());
    });
    return const RecordingState();
  }

  Future<void> start() async {
    final granted = await _ensurePermission();
    if (!granted) {
      state = const RecordingState(status: RecordingStatus.permissionDenied);
      return;
    }
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/voice_${_uuid.v4()}.m4a';
    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc, numChannels: 1),
      path: path,
    );
    _stopwatch
      ..reset()
      ..start();
    _startTicker();
    _amplitudeSub = _recorder
        .onAmplitudeChanged(_amplitudeInterval)
        .listen(_onAmplitude);
    state = const RecordingState(status: RecordingStatus.recording);
  }

  Future<void> pause() async {
    if (!state.isRecording) {
      return;
    }
    await _recorder.pause();
    _stopwatch.stop();
    _ticker?.cancel();
    state = state.copyWith(status: RecordingStatus.paused);
  }

  Future<void> resume() async {
    if (!state.isPaused) {
      return;
    }
    await _recorder.resume();
    _stopwatch.start();
    _startTicker();
    state = state.copyWith(status: RecordingStatus.recording);
  }

  Future<void> stop() async {
    if (!state.isActive) {
      return;
    }
    final path = await _recorder.stop();
    _stopTicking();
    if (path == null) {
      state = const RecordingState();
      return;
    }
    state = RecordingState(
      status: RecordingStatus.completed,
      elapsed: _stopwatch.elapsed,
      filePath: path,
    );
  }

  /// Stops any in-progress or finished recording and deletes its temp file,
  /// returning to [RecordingStatus.idle].
  Future<void> cancel() async {
    if (state.isActive) {
      final path = await _recorder.stop();
      if (path != null) {
        await _deleteFile(path);
      }
    } else if (state.isCompleted) {
      final path = state.filePath;
      if (path != null) {
        await _deleteFile(path);
      }
    }
    _stopTicking();
    state = const RecordingState();
  }

  /// Clears a completed recording without deleting the file (e.g. after the
  /// caller has taken ownership of it for upload).
  void reset() {
    _stopTicking();
    state = const RecordingState();
  }

  Future<bool> _ensurePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(_tickInterval, (_) {
      state = state.copyWith(elapsed: _stopwatch.elapsed);
    });
  }

  void _onAmplitude(Amplitude amplitude) {
    final normalized = ((amplitude.current - _minDb) / -_minDb).clamp(0.0, 1.0);
    state = state.copyWith(amplitude: normalized);
  }

  void _stopTicking() {
    _ticker?.cancel();
    _ticker = null;
    _stopwatch.stop();
    unawaited(_amplitudeSub?.cancel());
    _amplitudeSub = null;
  }

  Future<void> _deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
