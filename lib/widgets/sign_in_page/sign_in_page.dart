import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/services/spotify_auth.dart';
import 'package:storify/widgets/_common/custom_rounded_button.dart';
import 'package:storify/widgets/_common/custom_toast.dart';
import 'package:storify/widgets/my_playlist_page/my_playlist_page.dart';

class SignInPage extends StatefulWidget {
  static const routeName = '/sign_in';

  const SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _signInFromSavedTokens();
  }

  Future<void> _signInFromSavedTokens() async {
    final auth = context.read<SpotifyAuth>();
    setState(() => _isLoading = true);
    try {
      await auth.signInFromSavedTokens();
      Navigator.pushNamed(context, MyPlaylistPage.routeName);
    } on PlatformException catch (_) {} finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSignIn(SpotifyAuth auth, BuildContext context) async {
    try {
      setState(() => _isLoading = true);
      await auth.authenticate();
      Navigator.pushNamed(context, MyPlaylistPage.routeName);
    } catch (e) {
      CustomToast.showTextToast(
          text: "Failed to sign in", toastType: ToastType.error);
    } finally {
      setState(() => _isLoading = false);
    }
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
                  style: TextStyles.bannerText,
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text('Add a story to your Spotify Playlists',
                    style: TextStyles.light.copyWith(
                      fontSize: 18.0,
                    ))
              ],
            ),
            _isLoading
                ? SpinKitFadingCube(
                    size: 36, color: CustomColors.secondaryTextColor)
                : Consumer<SpotifyAuth>(
                    builder: (_, auth, __) => CustomRoundedButton(
                      onPressed: () => _handleSignIn(auth, context),
                      buttonText: 'SIGN IN WITH SPOTIFY',
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
