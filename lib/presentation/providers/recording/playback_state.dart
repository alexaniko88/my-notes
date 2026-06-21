import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class PlaybackState extends Equatable {
  final bool isPlaying;
  final Duration position;
  final Duration duration;

  const PlaybackState({
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  @override
  List<Object?> get props => [isPlaying, position, duration];

  PlaybackState copyWith({
    bool? isPlaying,
    Duration? position,
    Duration? duration,
  }) {
    return PlaybackState(
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }
}
