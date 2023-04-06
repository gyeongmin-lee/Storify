import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:storify/app.dart';
import 'package:storify/blocs/blocs.dart';
import 'package:storify/services/spotify_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
