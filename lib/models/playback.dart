import 'package:equatable/equatable.dart';
import 'package:storify/utils/index_walker.dart';

class Playback extends Equatable {
  Playback({
    required this.progressMs,
    required this.isPlaying,
    required this.trackId,
    this.playlistId,
  });
  final int? progressMs;
  final bool? isPlaying;
  final String? trackId;
  final String? playlistId;

  factory Playback.fromJson(Map<String, dynamic> json) {
    final progressMs = json['progress_ms'];
    final isPlaying = json['is_playing'];
    final trackId = json['item']['id'];
    String? playlistId = IndexWalker(json)['context']['uri'].value;
    if (playlistId == null || !playlistId.contains('spotify:playlist:')) {
      playlistId = null;
    } else {
      playlistId = playlistId.split('spotify:playlist:')[1];
    }
    return Playback(
        isPlaying: isPlaying,
        progressMs: progressMs,
        trackId: trackId,
        playlistId: playlistId);
  }

  @override
  List<Object?> get props => [progressMs, isPlaying, trackId, playlistId];
}
