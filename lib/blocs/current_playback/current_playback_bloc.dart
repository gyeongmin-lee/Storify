import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:storify/blocs/blocs.dart';
import 'package:storify/models/playback.dart';
import 'package:storify/services/spotify_api.dart';
import 'package:storify/widgets/_common/custom_toast.dart';
import 'package:storify/constants/values.dart' as Constants;
import 'package:storify/widgets/_common/overlay_modal.dart';
import 'package:url_launcher/url_launcher.dart';

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
      if (event.playback == null) {
        yield CurrentPlaybackEmpty();
      } else {
        yield CurrentPlaybackSuccess(event.playback);
      }
    }

    if (event is CurrentPlaybackPlayed) {
      try {
        if (playerTrackState is PlayerTracksSuccess) {
          await SpotifyApi.play(
              playlistId: playerTrackState.playlist.id,
              trackId: playerTrackState.currentTrack.id,
              positionMs: event.positionMs);
        }
      } on NoActiveDeviceFoundException catch (_) {
        OverlayModal.show(onConfirm: () async {
          final url = playerTrackState.playlist.externalUrl;
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            CustomToast.showTextToast(
                text: 'Failed to open spotify link',
                toastType: ToastType.error);
          }
        });
      } on PremiumRequiredException catch (_) {
        CustomToast.showTextToast(
            text: 'You must be a Spotify premium user',
            toastType: ToastType.error);
      }
    }

    if (event is CurrentPlaybackPaused) {
      try {
        if (playerTrackState is PlayerTracksSuccess) await SpotifyApi.pause();
      } on PremiumRequiredException catch (_) {
        CustomToast.showTextToast(
            text: 'You must be a Spotify premium user',
            toastType: ToastType.error);
      } catch (_) {
        CustomToast.showTextToast(
            text: 'Failed to pause', toastType: ToastType.error);
      }
    }

    if (event is CurrentPlaybackTrackChanged &&
        playerTrackState is PlayerTracksSuccess &&
        currentState is CurrentPlaybackSuccess) {
      final changedTrackNotBeingPlayed =
          currentState.playback.trackId != playerTrackState.currentTrack.id;
      final isWithinPlaylistContext =
          currentState.playback.playlistId == playerTrackState.playlist.id;
      if (currentState.playback.isPlaying &&
          isWithinPlaylistContext &&
          changedTrackNotBeingPlayed) add(CurrentPlaybackPlayed());
    }
  }

  @override
  Stream<Transition<CurrentPlaybackEvent, CurrentPlaybackState>>
      transformEvents(
    Stream<CurrentPlaybackEvent> events,
    TransitionFunction<CurrentPlaybackEvent, CurrentPlaybackState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) =>
        (event is! CurrentPlaybackPlayed && event is! CurrentPlaybackPaused));
    final debounceStream = events
        .where((event) =>
            (event is CurrentPlaybackPlayed || event is CurrentPlaybackPaused))
        .debounceTime(Duration(milliseconds: Constants.debounceMillisecond));
    return super.transformEvents(
        MergeStream([nonDebounceStream, debounceStream]), transitionFn);
  }
}
