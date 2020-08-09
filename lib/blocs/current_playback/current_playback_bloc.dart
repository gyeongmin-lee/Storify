import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:storify/blocs/blocs.dart';
import 'package:storify/models/playback.dart';
import 'package:storify/services/spotify_api.dart';
import 'package:storify/widgets/_common/custom_toast.dart';
import 'package:storify/constants/values.dart' as Constants;

class CurrentPlaybackBloc
    extends Bloc<CurrentPlaybackEvent, CurrentPlaybackState> {
  StreamSubscription _currentPlaybackSubscription;
  final PlayerTracksBloc playerTracksBloc;

  CurrentPlaybackBloc({@required this.playerTracksBloc})
      : super(CurrentPlaybackInitial());

  @override
  Stream<CurrentPlaybackState> mapEventToState(
      CurrentPlaybackEvent event) async* {
    final currentState = state;
    final playerTrackState = playerTracksBloc.state;
    if (event is CurrentPlaybackLoaded) {
      await _currentPlaybackSubscription?.cancel();
      _currentPlaybackSubscription =
          SpotifyApi.getCurrentPlaybackStream().listen((Playback playback) {
        add(CurrentPlaybackUpdated(playback));
      });
    }

    if (event is CurrentPlaybackUpdated &&
        playerTrackState is PlayerTracksSuccess) {
      yield CurrentPlaybackSuccess(event.playback);
    }

    if (event is CurrentPlaybackPlayed) {
      try {
        if (playerTrackState is PlayerTracksSuccess)
          await SpotifyApi.play(
              playlistId: playerTrackState.playlist.id,
              trackId: playerTrackState.currentTrack.id);
      } on NoActiveDeviceFoundException catch (_) {
        // TODO show a dismissible popup instead of toast
        CustomToast.showTextToast(
            text: 'Play any track in Spotify app \nto activate this feature',
            toastType: ToastType.warning);
      } on PremiumRequiredException catch (_) {
        CustomToast.showTextToast(
            text: 'You must be a Spotify premium user',
            toastType: ToastType.error);
      }
    }

    if (event is CurrentPlaybackTrackChanged) {
      if (currentState is CurrentPlaybackSuccess &&
          currentState.playback != null) {
        if (currentState.playback.isPlaying) add(CurrentPlaybackPlayed());
      }
    }
  }

  @override
  Stream<Transition<CurrentPlaybackEvent, CurrentPlaybackState>>
      transformEvents(
    Stream<CurrentPlaybackEvent> events,
    TransitionFunction<CurrentPlaybackEvent, CurrentPlaybackState> transitionFn,
  ) {
    final nonDebounceStream =
        events.where((event) => event is! CurrentPlaybackPlayed);
    final debounceStream = events
        .where((event) => event is CurrentPlaybackPlayed)
        .debounceTime(Duration(milliseconds: Constants.debounceMillisecond));
    return super.transformEvents(
        MergeStream([nonDebounceStream, debounceStream]), transitionFn);
  }
}
