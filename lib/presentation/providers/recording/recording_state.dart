import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum RecordingStatus { idle, recording, paused, completed, permissionDenied }

@immutable
class RecordingState extends Equatable {
  final RecordingStatus status;
  final Duration elapsed;

  /// Latest microphone level, normalized to 0–1 for a waveform/level meter.
  final double amplitude;

  /// Local path of the finished recording; set only when [status] is
  /// [RecordingStatus.completed].
  final String? filePath;

  const RecordingState({
    this.status = RecordingStatus.idle,
    this.elapsed = Duration.zero,
    this.amplitude = 0,
    this.filePath,
  });

  bool get isRecording => status == RecordingStatus.recording;
  bool get isPaused => status == RecordingStatus.paused;
  bool get isActive => isRecording || isPaused;
  bool get isCompleted => status == RecordingStatus.completed;

  @override
  List<Object?> get props => [status, elapsed, amplitude, filePath];

  RecordingState copyWith({
    RecordingStatus? status,
    Duration? elapsed,
    double? amplitude,
    String? filePath,
    bool clearFilePath = false,
  }) {
    return RecordingState(
      status: status ?? this.status,
      elapsed: elapsed ?? this.elapsed,
      amplitude: amplitude ?? this.amplitude,
      filePath: clearFilePath ? null : filePath ?? this.filePath,
    );
  }
}
