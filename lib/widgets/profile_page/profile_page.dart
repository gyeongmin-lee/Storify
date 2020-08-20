import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/services/spotify_auth.dart';
import 'package:provider/provider.dart';
import 'package:storify/widgets/_common/custom_image_provider.dart';
import 'package:storify/widgets/_common/custom_rounded_button.dart';
import 'package:storify/widgets/_common/custom_toast.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
  void _openSpotify() async {
    final url = 'http://open.spotify.com/user';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      CustomToast.showTextToast(
          text: 'Failed to open spotify link', toastType: ToastType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<SpotifyAuth>();

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 160.0, bottom: 120.0, left: 24.0, right: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: <Widget>[
                CircleAvatar(
                    radius: 54.0,
                    backgroundColor: Colors.transparent,
                    backgroundImage: CustomImageProvider.cachedImage(
                        auth.user.avatarImageUrl)),
                SizedBox(
                  height: 8.0,
                ),
                Text('Signed in as',
                    style: TextStyles.light.copyWith(fontSize: 14.0)),
                Text(auth.user.name,
                    style: TextStyles.primary.copyWith(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5)),
              ],
            ),
            CustomRoundedButton(
              borderColor: Colors.green,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              regularLetterSpacing: 0.8,
              onPressed: _openSpotify,
              buttonText: 'OPEN SPOTIFY',
            ),
          ],
        ),
      ),
    );
  }
}
