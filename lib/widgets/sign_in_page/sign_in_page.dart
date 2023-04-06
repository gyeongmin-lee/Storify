import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/services/spotfy_uri_manager.dart';
import 'package:storify/services/spotify_auth.dart';
import 'package:storify/widgets/_common/custom_rounded_button.dart';
import 'package:storify/widgets/_common/custom_toast.dart';
import 'package:storify/widgets/home_page/home_page.dart';
import 'package:uni_links/uni_links.dart';

class SignInPage extends StatefulWidget {
  static const routeName = '/sign_in';

  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initialSignIn();
  }

  Future<void> _initialSignIn() async {
    final auth = context.read<SpotifyAuth>();
    final uriManager = SpotifyUriManager(auth);
    setState(() => _isLoading = true);
    try {
      final initialUri = await getInitialUri();
      if (initialUri == null) {
        _signInFromSavedTokens();
        return;
      }
      await uriManager.handleLoadFromUri(initialUri);
    } catch (e) {
      if (!mounted) return;
      uriManager.handleFail();
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInFromSavedTokens() async {
    final auth = context.read<SpotifyAuth>();
    setState(() => _isLoading = true);
    try {
      await auth.signInFromSavedTokens();
      Navigator.popAndPushNamed(context, HomePage.routeName);
    } catch (_) {} finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSignIn(SpotifyAuth auth, BuildContext context) async {
    try {
      setState(() => _isLoading = true);
      await auth.authenticate();
      Navigator.popAndPushNamed(context, HomePage.routeName);
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
                Image.asset(
                  'images/text_logo.png',
                  width: 280.0,
                ),
                Text('Add captions to your Spotify Playlists',
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
                      borderColor: Colors.green,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      buttonText: 'SIGN IN WITH SPOTIFY',
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
