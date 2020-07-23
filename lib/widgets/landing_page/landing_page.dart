import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storify/services/spotify_auth.dart';
import 'package:storify/widgets/my_playlist_page/my_playlist_page.dart';
import 'package:storify/widgets/sign_in_page/sign_in_page.dart';

class LandingPage extends StatefulWidget {
  static const routeName = '/';

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  void _handleSignIn(SpotifyAuth auth) async {
    await auth.authenticate();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SpotifyAuth>(
        create: (_) => SpotifyAuth(),
        child: Consumer<SpotifyAuth>(
          builder: (_, auth, __) {
            return auth.user != null
                ? MyPlaylistPage()
                : SignInPage(onSignIn: () => _handleSignIn(auth));
          },
        ));
  }
}
