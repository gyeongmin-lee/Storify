import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:storify/widgets/landing_page/landing_page.dart';
import 'package:storify/widgets/my_playlist_page/my_playlist_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Storify',
        initialRoute: '/',
        theme: ThemeData(
            scaffoldBackgroundColor: Color(0xFF191414),
            textTheme:
                GoogleFonts.notoSansTextTheme(Theme.of(context).textTheme)
                    .apply(
                        displayColor: Colors.white70,
                        bodyColor: Colors.white54)),
        routes: {
          LandingPage.routeName: (context) => LandingPage(),
          MyPlaylistPage.routeName: (context) => MyPlaylistPage(),
          '/playlist': (context) => Container(),
        });
  }
}
