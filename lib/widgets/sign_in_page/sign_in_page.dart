import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/widgets/_common/custom_rounded_button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.onSignIn}) : super(key: key);
  final VoidCallback onSignIn;

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
                    style: kLightTextStyle.copyWith(
                      fontSize: 18.0,
                    ))
              ],
            ),
            CustomRoundedButton(
              onPressed: onSignIn,
              buttonText: 'SIGN IN WITH SPOTIFY',
            )
          ],
        ),
      ),
    );
  }
}
