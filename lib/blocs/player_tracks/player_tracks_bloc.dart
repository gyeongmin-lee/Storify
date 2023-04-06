import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:storify/blocs/blocs.dart';
import 'package:storify/constants/values.dart' as Constants;
import 'package:storify/models/playlist.dart';
import 'package:storify/services/firebase_db.dart';
import 'package:storify/services/spotify_api.dart';

class PlayerTracksBloc extends Bloc<PlayerTracksEvent, PlayerTracksState> {
  final Playlist? playlist;
  PlayerTracksBloc({this.playlist}) : super(PlayerTracksInitial(playlist)) {
    on<PlayerTracksFetched>(_onPlayerTracksFetched);
    on<PlayerTracksTrackSelected>(_onPlayerTracksTrackSelected);
    on<PlayerTrackStoryTextAndArtistImageUrlLoaded>(
        _onPlayerTrackStoryTextAndArtistImageUrlLoaded,
        transformer: debounce(
            const Duration(milliseconds: Constants.debounceMillisecond)));
    on<PlayerTrackStoryTextUpdated>(_onPlayerTrackStoryTextUpdated);
  }

  final FirebaseDB _firebaseDB = FirebaseDB();
  StreamSubscription? _storyTextSubscription;

  Future _onPlayerTracksFetched(
      PlayerTracksFetched event, Emitter<PlayerTracksState> emit) async {
    try {
      final tracks = await SpotifyApi.getTracks(playlist!.id);
      final currentTrack = tracks[0];

      emit(PlayerTracksSuccess(
          playlist: playlist,
          currentTrack: currentTrack,
          tracks: tracks,
          isAllDataLoaded: false));
      add(PlayerTrackStoryTextAndArtistImageUrlLoaded());
    } catch (_) {
      emit(PlayerTracksFailure(playlist));
    }
  }

  Future _onPlayerTracksTrackSelected(
      PlayerTracksTrackSelected event, Emitter<PlayerTracksState> emit) async {
    final PlayerTracksState currentState = state;
    if (currentState is PlayerTracksSuccess) {
      try {
        final currentTrack = currentState.currentTrack;
        final selectedTrack = currentState.tracks[event.selectedTrackIndex!];
        final isArtistImageLoaded =
            currentTrack.artists[0] == selectedTrack.artists[0] &&
                currentState.currentTrackArtistImageUrl != '';

        emit(currentState.copyWith(
            currentTrack: selectedTrack,
            currentTrackArtistImageUrl: isArtistImageLoaded
                ? currentState.currentTrackArtistImageUrl
                : '',
            storyText: '',
            isAllDataLoaded: false));
        add(PlayerTrackStoryTextAndArtistImageUrlLoaded());
      } catch (_) {
        emit(PlayerTracksFailure(playlist));
      }
    }
  }

  Future _onPlayerTrackStoryTextAndArtistImageUrlLoaded(
      PlayerTrackStoryTextAndArtistImageUrlLoaded event,
      Emitter<PlayerTracksState> emit) async {
    final PlayerTracksState currentState = state;
    if (currentState is PlayerTracksSuccess) {
      if (currentState.currentTrackArtistImageUrl.isEmpty) {
        await for (final result in _loadArtistImageUrl()) {
          emit(result);
        }
      }

      await for (final result in _loadStoryText()) {
        emit(result);
      }

      emit(currentState.copyWith(isAllDataLoaded: true));
    }
  }

  Future _onPlayerTrackStoryTextUpdated(PlayerTrackStoryTextUpdated event,
      Emitter<PlayerTracksState> emit) async {
    final PlayerTracksState currentState = state;
    if (currentState is PlayerTracksSuccess) {
      emit(currentState.copyWith(storyText: event.storyText));
    }
  }

  Stream<PlayerTracksState> _loadArtistImageUrl() async* {
    final PlayerTracksSuccess currentState = state as PlayerTracksSuccess;
    try {
      final artistImageUrl = await SpotifyApi.getArtistImageUrl(
          currentState.currentTrack.artists[0].href!);
      yield currentState.copyWith(currentTrackArtistImageUrl: artistImageUrl);
    } catch (_) {
      yield currentState;
    }
  }

  Stream<PlayerTracksState> _loadStoryText() async* {
    final PlayerTracksSuccess currentState = state as PlayerTracksSuccess;
    await _storyTextSubscription?.cancel();
    _storyTextSubscription = _firebaseDB
        .storyStream(
            playlistId: currentState.playlist!.id,
            trackId: currentState.currentTrack.id)
        .listen((storyText) => add(PlayerTrackStoryTextUpdated(storyText)));
  }

  @override
  Future<void> close() {
    _storyTextSubscription?.cancel();
    return super.close();
  }

  EventTransformer<PlayerTracksEvent> debounce<PlayerTracksEvent>(
      Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
