import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:storify/blocs/blocs.dart';
import 'package:storify/constants/values.dart' as Constants;
import 'package:storify/models/playlist.dart';
import 'package:storify/services/spotify_api.dart';

class PlayerTracksBloc extends Bloc<PlayerTracksEvent, PlayerTracksState> {
  final Playlist playlist;
  PlayerTracksBloc({this.playlist}) : super(PlayerTracksInitial(playlist));

  @override
  Stream<PlayerTracksState> mapEventToState(PlayerTracksEvent event) async* {
    final currentState = state;
    if (event is PlayerTracksFetched) {
      try {
        final tracks = await SpotifyApi.getTracks(playlist.id);
        final currentTrack = tracks[0];

        yield PlayerTracksSuccess(
            playlist: playlist, currentTrack: currentTrack, tracks: tracks);
        add(PlayerTracksArtistImageLoaded());
      } catch (_) {
        yield PlayerTracksFailure(playlist);
      }
    }
    if (event is PlayerTracksTrackSelected &&
        currentState is PlayerTracksSuccess) {
      try {
        final currentTrack = currentState.currentTrack;
        final selectedTrack = currentState.tracks[event.selectedTrackIndex];
        final isArtistImageLoaded =
            currentTrack.artists[0] == selectedTrack.artists[0] &&
                currentState.currentTrackArtistImageUrl != null;

        yield currentState.copyWith(
          currentTrack: selectedTrack,
          currentTrackArtistImageUrl: isArtistImageLoaded
              ? currentState.currentTrackArtistImageUrl
              : '',
        );

        if (!isArtistImageLoaded) add(PlayerTracksArtistImageLoaded());
      } catch (_) {
        yield PlayerTracksFailure(playlist);
      }
    }

    if (event is PlayerTracksArtistImageLoaded &&
        currentState is PlayerTracksSuccess) {
      try {
        final artistImageUrl = await SpotifyApi.getArtistImageUrl(
            currentState.currentTrack.artists[0].href);
        yield currentState.copyWith(currentTrackArtistImageUrl: artistImageUrl);
      } catch (_) {
        yield currentState;
      }
    }
  }

  @override
  Stream<Transition<PlayerTracksEvent, PlayerTracksState>> transformEvents(
    Stream<PlayerTracksEvent> events,
    TransitionFunction<PlayerTracksEvent, PlayerTracksState> transitionFn,
  ) {
    final nonDebounceStream =
        events.where((event) => event is! PlayerTracksArtistImageLoaded);
    final debounceStream = events
        .where((event) => event is PlayerTracksArtistImageLoaded)
        .debounceTime(
            const Duration(milliseconds: Constants.debounceMillisecond));
    return super.transformEvents(
        MergeStream([nonDebounceStream, debounceStream]), transitionFn);
  }
}
