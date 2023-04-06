import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:storify/blocs/blocs.dart';
import 'package:storify/constants/style.dart';
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
      : super(CurrentPlaybackInitial()) {
    on<CurrentPlaybackLoaded>(_currentPlaybackLoaded);
    on<CurrentPlaybackUpdated>(_currentPlaybackUpdated);
    on<CurrentPlaybackPlayed>(_currentPlaybackPlayed,
        transformer:
            debounce(Duration(milliseconds: Constants.debounceMillisecond)));
    on<CurrentPlaybackPaused>(_currentPlaybackPaused,
        transformer:
            debounce(Duration(milliseconds: Constants.debounceMillisecond)));
    on<CurrentPlaybackTrackChanged>(_currentPlaybackTrackChanged);
    on<CurrentPlaybackAppPaused>(_currentPlaybackAppPaused);
    on<CurrentPlaybackAppResumed>(_currentPlaybackAppResumed);
  }

  Future _currentPlaybackLoaded(
      CurrentPlaybackLoaded event, Emitter<CurrentPlaybackState> emit) async {
    await _currentPlaybackSubscription?.cancel();
    _currentPlaybackSubscription =
        SpotifyApi.getCurrentPlaybackStream().listen((Playback playback) {
      add(CurrentPlaybackUpdated(playback));
    });
  }

  Future _currentPlaybackUpdated(
      CurrentPlaybackUpdated event, Emitter<CurrentPlaybackState> emit) async {
    final playerTrackState = playerTracksBloc.state;
    if (playerTrackState is PlayerTracksSuccess) {
      if (event.playback == null) {
        emit(CurrentPlaybackEmpty());
      } else {
        emit(CurrentPlaybackSuccess(event.playback));
      }
    }
  }

  Future _currentPlaybackPlayed(
      CurrentPlaybackPlayed event, Emitter<CurrentPlaybackState> emit) async {
    final playerTrackState = playerTracksBloc.state;
    try {
      if (playerTrackState is PlayerTracksSuccess) {
        await SpotifyApi.play(
            playlistId: playerTrackState.playlist.id,
            trackId: playerTrackState.currentTrack.id,
            positionMs: event.positionMs);
      }
    } on NoActiveDeviceFoundException catch (_) {
      OverlayModal.show(
          icon: Icon(
            Icons.info,
            color: CustomColors.primaryTextColor,
            size: 72.0,
          ),
          message:
              'In order to use the playback feature, an active Spotify player is needed'
              '\n\nOpen Spotify app and play the playlist to enable playback',
          actionText: 'OPEN SPOTIFY',
          onConfirm: () async {
            final url = playerTrackState.playlist.externalUrl;
            Uri uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
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

  Future _currentPlaybackPaused(
      CurrentPlaybackPaused event, Emitter<CurrentPlaybackState> emit) async {
    final playerTrackState = playerTracksBloc.state;
    if (playerTrackState is PlayerTracksSuccess) {
      try {
        await SpotifyApi.pause();
      } on PremiumRequiredException catch (_) {
        CustomToast.showTextToast(
            text: 'You must be a Spotify premium user',
            toastType: ToastType.error);
      } catch (_) {
        CustomToast.showTextToast(
            text: 'Failed to pause', toastType: ToastType.error);
      }
    }
  }

  Future _currentPlaybackTrackChanged(CurrentPlaybackTrackChanged event,
      Emitter<CurrentPlaybackState> emit) async {
    final playerTrackState = playerTracksBloc.state;
    final currentState = state;

    if (playerTrackState is PlayerTracksSuccess &&
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

  Future _currentPlaybackAppPaused(CurrentPlaybackAppPaused event,
      Emitter<CurrentPlaybackState> emit) async {
    _currentPlaybackSubscription?.pause();
  }

  Future _currentPlaybackAppResumed(CurrentPlaybackAppResumed event,
      Emitter<CurrentPlaybackState> emit) async {
    _currentPlaybackSubscription?.resume();
  }

  EventTransformer<CurrentPlaybackEvent> debounce<CurrentPlaybackEvent>(
      Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  @override
  Future<void> close() {
    _currentPlaybackSubscription?.cancel();
    return super.close();
  }
}
