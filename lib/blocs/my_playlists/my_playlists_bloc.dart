import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storify/blocs/my_playlists/my_playlists.dart';
import 'package:storify/services/spotify_api.dart';
import 'package:storify/constants/values.dart' as Constants;

class MyPlaylistsBloc extends Bloc<MyPlaylistsEvent, MyPlaylistsState> {
  MyPlaylistsBloc() : super(MyPlaylistsInitial()) {
    on<MyPlaylistsFetched>(_onPlaylistsFetched);
    on<MyPlaylistsRefreshed>(_onPlaylistsRefreshed);
  }

  Future _onPlaylistsFetched(
      MyPlaylistsFetched event, Emitter<MyPlaylistsState> emit) async {
    final MyPlaylistsState currentState = state;
    if (!_hasReachedMax(currentState)) {
      try {
        if (currentState is MyPlaylistsInitial) {
          final playlists = await SpotifyApi.getListOfPlaylists(
              offset: 0, limit: Constants.playlistsLimit);
          emit(MyPlaylistsSuccess(playlists: playlists, hasReachedMax: false));
        } else if (currentState is MyPlaylistsSuccess) {
          final playlists = await SpotifyApi.getListOfPlaylists(
              offset: currentState.playlists!.length,
              limit: Constants.playlistsLimit);

          emit(playlists.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : MyPlaylistsSuccess(
                  playlists: currentState.playlists! + playlists,
                  hasReachedMax: false));
        }
      } catch (e) {
        print(e);
        emit(MyPlaylistsFailure());
      }
    }
  }

  Future _onPlaylistsRefreshed(
      MyPlaylistsRefreshed event, Emitter<MyPlaylistsState> emit) async {
    final MyPlaylistsState currentState = state;
    try {
      if (currentState is MyPlaylistsSuccess)
        emit(MyPlaylistsRefreshing(currentState.playlists));
      final playlists = await SpotifyApi.getListOfPlaylists(
          offset: 0, limit: Constants.playlistsLimit);
      emit(MyPlaylistsSuccess(playlists: playlists, hasReachedMax: false));
    } catch (e) {
      print(e);
      emit(MyPlaylistsFailure());
    }
  }

  bool _hasReachedMax(MyPlaylistsState state) =>
      state is MyPlaylistsSuccess && state.hasReachedMax!;
}
