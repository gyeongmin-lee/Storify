import 'package:equatable/equatable.dart';

abstract class MyPlaylistsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MyPlaylistsFetched extends MyPlaylistsEvent {}

class MyPlaylistsRefreshed extends MyPlaylistsEvent {}
