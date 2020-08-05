import 'package:equatable/equatable.dart';

abstract class PlayerTracksEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PlayerTracksFetched extends PlayerTracksEvent {}

class PlayerTracksTrackSelected extends PlayerTracksEvent {
  final int selectedTrackIndex;

  PlayerTracksTrackSelected({this.selectedTrackIndex});

  @override
  List<Object> get props => [selectedTrackIndex];
}

class PlayerTracksArtistImageLoaded extends PlayerTracksEvent {}
