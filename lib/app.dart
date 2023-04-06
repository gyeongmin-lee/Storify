import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/services/spotfy_uri_manager.dart';
import 'package:storify/services/spotify_auth.dart';
import 'package:storify/widgets/_common/custom_toast.dart';
import 'package:storify/widgets/home_page/home_page.dart';
import 'package:storify/widgets/onboarding_page/onboarding_page.dart';
import 'package:storify/widgets/sign_in_page/sign_in_page.dart';
import 'package:storify/widgets/splash_page/splash_page.dart';
import 'package:uni_links/uni_links.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    initLoadFromUri();
  }

  @override
  void dispose() {
    super.dispose();
    _sub.cancel();
  }

  Future<void> initLoadFromUri() async {
    final auth = context.read<SpotifyAuth>();
    final uriManager = SpotifyUriManager(auth);
    _sub = uriLinkStream.listen((Uri? uri) async {
      if (!mounted) return;
      if (uri == null) return;
      try {
        await uriManager.handleLoadFromUri(uri);
      } catch (e) {
        print(e);
        uriManager.handleFail();
      }
    }, onError: (Object err) {
      print("ONERROR");
      if (!mounted) return;
      uriManager.handleFail();
    });

    try {
      final initialUri = await getInitialUri();
      if (initialUri == null) return;
      await uriManager.handleLoadFromUri(initialUri);
    } catch (e) {
      CustomToast.showTextToast(text: e.toString(), toastType: ToastType.error);
      if (!mounted) return;
      uriManager.handleFail();
    }
  }

  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();
    return GetMaterialApp(
        title: 'Storify',
        themeMode: ThemeMode.dark,
        initialRoute: SplashPage.routeName,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Color(0xFF191414),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.green[700],
            selectionColor: Colors.green[100]!.withOpacity(0.1),
            selectionHandleColor: Colors.green[700],
          ),
          textTheme: Theme.of(context).textTheme.apply(
              displayColor: Colors.white70,
              bodyColor: CustomColors.secondaryTextColor),
        ),
        builder: (context, child) {
          child = botToastBuilder(context, child);
          return child;
        },
        navigatorObservers: [
          BotToastNavigatorObserver()
        ],
        routes: {
          SignInPage.routeName: (context) => SignInPage(),
          HomePage.routeName: (context) => HomePage(),
          OnboardingPage.routeName: (context) => OnboardingPage(),
          SplashPage.routeName: (context) => SplashPage(),
        });
  }
}
