import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/services/spotify_auth.dart';
import 'package:storify/widgets/landing_page/landing_page.dart';
import 'package:storify/widgets/player_page/player_page.dart';

Future main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SpotifyAuth>(
      create: (_) => SpotifyAuth(),
      child: MaterialApp(
          title: 'Storify',
          themeMode: ThemeMode.dark,
          initialRoute: LandingPage.routeName,
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Color(0xFF191414),
            cursorColor: Colors.green[700],
            textSelectionColor: Colors.green[100].withOpacity(0.1),
            textSelectionHandleColor: Colors.green[700],
            textTheme: Theme.of(context).textTheme.apply(
                displayColor: Colors.white70,
                bodyColor: CustomColors.secondaryTextColor),
          ),
          builder: (context, child) => ScrollConfiguration(
                behavior: DisableGlowScrollBehaviour(),
                child: child,
              ),
          routes: {
            LandingPage.routeName: (context) => LandingPage(),
            PlayerPage.routeName: (context) => PlayerPage(),
          }),
    );
  }
}
