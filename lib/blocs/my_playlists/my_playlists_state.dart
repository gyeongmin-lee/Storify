import 'package:equatable/equatable.dart';
import 'package:storify/models/playlist.dart';

abstract class MyPlaylistsState extends Equatable {
  const MyPlaylistsState();

  @override
  List<Object?> get props => [];
}

class MyPlaylistsInitial extends MyPlaylistsState {}

class MyPlaylistsFailure extends MyPlaylistsState {}

abstract class MyPlaylistsWithData extends MyPlaylistsState {
  final List<Playlist>? playlists;

  MyPlaylistsWithData(this.playlists);

  @override
  List<Object?> get props => [playlists];
}

class MyPlaylistsRefreshing extends MyPlaylistsWithData {
  MyPlaylistsRefreshing(List<Playlist>? playlists) : super(playlists);
}

class MyPlaylistsSuccess extends MyPlaylistsRefreshing {
  final List<Playlist>? playlists;
  final bool? hasReachedMax;

  MyPlaylistsSuccess({this.playlists, this.hasReachedMax}) : super(playlists);

  MyPlaylistsSuccess copyWith({List<Playlist>? playlists, bool? hasReachedMax}) =>
      MyPlaylistsSuccess(
          playlists: playlists ?? this.playlists,
          hasReachedMax: hasReachedMax ?? this.hasReachedMax);

  @override
  List<Object?> get props => [playlists, hasReachedMax];
}
