import 'package:get/get.dart';
import 'package:storify/services/spotify_api.dart';
import 'package:storify/services/spotify_auth.dart';
import 'package:storify/widgets/_common/custom_toast.dart';
import 'package:storify/widgets/player_page/player_page.dart';

class SpotifyUriManager {
  SpotifyUriManager(this.auth);
  final SpotifyAuth auth;

  Future<void> handleLoadFromUri(Uri uri) async {
    final playlistId = uri.queryParameters['playlist_id'];
    if (auth.user == null) {
      await _authenticateUser();
    }

    final playlist = await SpotifyApi.getPlaylist(playlistId);
    Get.off(PlayerPage.create(playlist: playlist, isOpenedFromDeepLink: true));
  }

  void handleFail() {
    CustomToast.showTextToast(
        text: 'Failed to load playlist from Uri', toastType: ToastType.error);
  }

  Future<void> _authenticateUser() async {
    await auth.signInFromSavedTokens();
  }
}
