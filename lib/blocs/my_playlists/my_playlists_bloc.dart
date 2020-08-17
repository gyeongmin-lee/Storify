import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storify/blocs/my_playlists/my_playlists.dart';
import 'package:storify/services/spotify_api.dart';
import 'package:storify/constants/values.dart' as Constants;

class MyPlaylistsBloc extends Bloc<MyPlaylistsEvent, MyPlaylistsState> {
  MyPlaylistsBloc() : super(MyPlaylistsInitial());

  @override
  Stream<MyPlaylistsState> mapEventToState(MyPlaylistsEvent event) async* {
    final currentState = state;
    if (event is MyPlaylistsFetched && !_hasReachedMax(currentState)) {
      try {
        if (currentState is MyPlaylistsInitial) {
          final playlists = await SpotifyApi.getListOfPlaylists(
              offset: 0, limit: Constants.playlistsLimit);
          yield MyPlaylistsSuccess(playlists: playlists, hasReachedMax: false);
        } else if (currentState is MyPlaylistsSuccess) {
          final playlists = await SpotifyApi.getListOfPlaylists(
              offset: currentState.playlists.length,
              limit: Constants.playlistsLimit);
          yield playlists.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : MyPlaylistsSuccess(
                  playlists: currentState.playlists + playlists,
                  hasReachedMax: false);
        }
      } catch (e) {
        print(e);
        yield MyPlaylistsFailure();
      }
    }
    if (event is MyPlaylistsRefreshed) {
      final currentState = state;
      try {
        if (currentState is MyPlaylistsSuccess)
          yield MyPlaylistsRefreshing(currentState.playlists);
        final playlists = await SpotifyApi.getListOfPlaylists(
            offset: 0, limit: Constants.playlistsLimit);
        yield MyPlaylistsSuccess(playlists: playlists, hasReachedMax: false);
      } catch (e) {
        print(e);
        yield MyPlaylistsFailure();
      }
    }
  }

  bool _hasReachedMax(MyPlaylistsState state) =>
      state is MyPlaylistsSuccess && state.hasReachedMax;
}
