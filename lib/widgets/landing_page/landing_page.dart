import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/widgets/_common/custom_rounded_button.dart';
import 'package:storify/widgets/my_playlist_page/my_playlist_page.dart';

class LandingPage extends StatelessWidget {
  static const routeName = '/';

  void onSignInWithSpotify(BuildContext context) {
    Navigator.pushNamed(context, MyPlaylistPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  'STORIFY',
                  style: kBannerTextStyle,
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text('Add a story to your Spotify Playlists',
                    style: kBodyTextStyle)
              ],
            ),
            CustomRoundedButton(
              onPressed: () => onSignInWithSpotify(context),
              buttonText: 'SIGN IN WITH SPOTIFY',
            )
          ],
        ),
      ),
    );
  }
}
