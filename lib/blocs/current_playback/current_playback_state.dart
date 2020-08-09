import 'package:equatable/equatable.dart';
import 'package:storify/models/playback.dart';

abstract class CurrentPlaybackState extends Equatable {
  @override
  List<Object> get props => [];
}

class CurrentPlaybackInitial extends CurrentPlaybackState {}

class CurrentPlaybackFailure extends CurrentPlaybackState {}

class CurrentPlaybackSuccess extends CurrentPlaybackState {
  final Playback playback;

  CurrentPlaybackSuccess(this.playback);

  @override
  List<Object> get props => [playback];
}
