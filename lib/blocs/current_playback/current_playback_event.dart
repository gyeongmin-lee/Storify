import 'package:equatable/equatable.dart';
import 'package:storify/models/playback.dart';

abstract class CurrentPlaybackEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CurrentPlaybackLoaded extends CurrentPlaybackEvent {}

class CurrentPlaybackPlayed extends CurrentPlaybackEvent {}

class CurrentPlaybackUpdated extends CurrentPlaybackEvent {
  final Playback playback;

  CurrentPlaybackUpdated(this.playback);

  @override
  List<Object> get props => [playback];
}

class CurrentPlaybackTrackChanged extends CurrentPlaybackEvent {}
