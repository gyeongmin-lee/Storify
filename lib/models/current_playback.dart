import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class CurrentPlayback extends Equatable {
  CurrentPlayback(
      {@required this.progressMs,
      @required this.isPlaying,
      @required this.trackId});
  final int progressMs;
  final bool isPlaying;
  final String trackId;

  factory CurrentPlayback.fromJson(Map<String, dynamic> json) {
    final progressMs = json['progress_ms'];
    final isPlaying = json['is_playing'];
    final trackId = json['item']['id'];
    return CurrentPlayback(
        isPlaying: isPlaying, progressMs: progressMs, trackId: trackId);
  }

  @override
  List<Object> get props => [progressMs, isPlaying, trackId];
}
