import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/widgets/landing_page/landing_page.dart';
import 'package:storify/widgets/player_page/player_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Storify',
        initialRoute: LandingPage.routeName,
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xFF191414),
          textTheme: Theme.of(context)
              .textTheme
              .apply(displayColor: Colors.white70, bodyColor: Colors.white54),
        ),
        builder: (context, child) => ScrollConfiguration(
              behavior: DisableGlowScrollBehaviour(),
              child: child,
            ),
        routes: {
          LandingPage.routeName: (context) => LandingPage(),
          PlayerPage.routeName: (context) => PlayerPage(),
        });
  }
}
