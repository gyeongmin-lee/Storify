import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:storify/blocs/blocs.dart';
import 'package:storify/constants/values.dart' as Constants;
import 'package:storify/models/playlist.dart';
import 'package:storify/services/firebase_db.dart';
import 'package:storify/services/spotify_api.dart';
import 'package:storify/widgets/_common/custom_toast.dart';

class PlayerTracksBloc extends Bloc<PlayerTracksEvent, PlayerTracksState> {
  final Playlist playlist;
  PlayerTracksBloc({this.playlist}) : super(PlayerTracksInitial(playlist));

  final FirebaseDB _firebaseDB = FirebaseDB();
  StreamSubscription _storyTextSubscription;

  @override
  Stream<PlayerTracksState> mapEventToState(PlayerTracksEvent event) async* {
    final currentState = state;
    if (event is PlayerTracksFetched) {
      try {
        final tracks = await SpotifyApi.getTracks(playlist.id);
        final currentTrack = tracks[0];

        yield PlayerTracksSuccess(
            playlist: playlist,
            currentTrack: currentTrack,
            tracks: tracks,
            isAllDataLoaded: false);
        add(PlayerTrackStoryTextAndArtistImageUrlLoaded());
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
            storyText: '',
            isAllDataLoaded: false);

        add(PlayerTrackStoryTextAndArtistImageUrlLoaded());
      } catch (_) {
        yield PlayerTracksFailure(playlist);
      }
    }

    if (event is PlayerTrackStoryTextAndArtistImageUrlLoaded &&
        currentState is PlayerTracksSuccess) {
      if (currentState.currentTrackArtistImageUrl.isEmpty)
        yield* _loadArtistImageUrl();
      yield* _loadStoryText();
      yield* _completeLoad();
    }

    if (event is PlayerTrackStoryTextUpdated &&
        currentState is PlayerTracksSuccess) {
      yield currentState.copyWith(storyText: event.storyText);
    }

    if (event is PlayerTrackStoryTextEdited &&
        currentState is PlayerTracksSuccess) {
      try {
        await _firebaseDB.setStory(event.updatedStoryText,
            currentState.playlist.id, currentState.currentTrack.id);
        CustomToast.showTextToast(
            text: 'Updated', toastType: ToastType.success);
      } catch (e) {
        print(e);
        CustomToast.showTextToast(
            text: 'Failed to update story', toastType: ToastType.error);
      }
    }
  }

  Stream<PlayerTracksState> _loadArtistImageUrl() async* {
    final PlayerTracksSuccess currentState = state;
    try {
      final artistImageUrl = await SpotifyApi.getArtistImageUrl(
          currentState.currentTrack.artists[0].href);
      yield currentState.copyWith(currentTrackArtistImageUrl: artistImageUrl);
    } catch (_) {
      yield currentState;
    }
  }

  Stream<PlayerTracksState> _loadStoryText() async* {
    final PlayerTracksSuccess currentState = state;
    await _storyTextSubscription?.cancel();
    _storyTextSubscription = _firebaseDB
        .storyStream(
            playlistId: currentState.playlist.id,
            trackId: currentState.currentTrack.id)
        .listen((storyText) => add(PlayerTrackStoryTextUpdated(storyText)));
  }

  Stream<PlayerTracksState> _completeLoad() async* {
    final PlayerTracksSuccess currentState = state;
    yield currentState.copyWith(isAllDataLoaded: true);
  }

  @override
  Future<void> close() {
    _storyTextSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<Transition<PlayerTracksEvent, PlayerTracksState>> transformEvents(
    Stream<PlayerTracksEvent> events,
    TransitionFunction<PlayerTracksEvent, PlayerTracksState> transitionFn,
  ) {
    final nonDebounceStream = events.where(
        (event) => event is! PlayerTrackStoryTextAndArtistImageUrlLoaded);
    final debounceStream = events
        .where((event) => event is PlayerTrackStoryTextAndArtistImageUrlLoaded)
        .debounceTime(
            const Duration(milliseconds: Constants.debounceMillisecond));
    return super.transformEvents(
        MergeStream([nonDebounceStream, debounceStream]), transitionFn);
  }
}
