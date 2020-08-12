import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:storify/app.dart';
import 'package:storify/blocs/blocs.dart';
import 'package:storify/services/spotify_auth.dart';

Future main() async {
  await DotEnv().load('.env');
  Bloc.observer = LoggerBlocObserver();
  runApp(Storify());
}

class Storify extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SpotifyAuth>(
      create: (_) => SpotifyAuth(),
      child: App(),
    );
  }
}
