import 'package:flutter/material.dart';
import 'package:storify/widgets/my_playlist_page/my_playlist_page.dart';
import 'package:storify/widgets/sign_in_page/sign_in_page.dart';

class LandingPage extends StatefulWidget {
  static const routeName = '/';

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool isSignedIn = false;

  @override
  Widget build(BuildContext context) {
    return isSignedIn
        ? MyPlaylistPage()
        : SignInPage(
            onSignIn: () => setState(() => isSignedIn = true),
          );
  }
}
