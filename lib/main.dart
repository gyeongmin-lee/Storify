import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:storify/blocs/blocs.dart';
import 'package:storify/blocs/my_playlists/my_playlists.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/services/spotify_auth.dart';
import 'package:storify/widgets/my_playlists_page/my_playlists_page.dart';
import 'package:storify/widgets/sign_in_page/sign_in_page.dart';

Future main() async {
  await DotEnv().load('.env');
  Bloc.observer = LoggerBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();
    return ChangeNotifierProvider<SpotifyAuth>(
      create: (_) => SpotifyAuth(),
      child: MaterialApp(
          title: 'Storify',
          themeMode: ThemeMode.dark,
          initialRoute: SignInPage.routeName,
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Color(0xFF191414),
            cursorColor: Colors.green[700],
            textSelectionColor: Colors.green[100].withOpacity(0.1),
            textSelectionHandleColor: Colors.green[700],
            textTheme: Theme.of(context).textTheme.apply(
                displayColor: Colors.white70,
                bodyColor: CustomColors.secondaryTextColor),
          ),
          builder: (context, child) {
            child = ScrollConfiguration(
              behavior: DisableGlowScrollBehaviour(),
              child: child,
            );

            child = botToastBuilder(context, child);
            return child;
          },
          navigatorObservers: [
            BotToastNavigatorObserver()
          ],
          routes: {
            SignInPage.routeName: (context) => SignInPage(),
            MyPlaylistsPage.routeName: (context) => BlocProvider(
                create: (_) => MyPlaylistsBloc()..add(MyPlaylistsFetched()),
                child: MyPlaylistsPage()),
          }),
    );
  }
}
