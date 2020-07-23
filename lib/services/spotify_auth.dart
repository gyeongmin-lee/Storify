import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:storify/models/auth_tokens.dart';
import 'package:storify/models/user.dart';
import 'package:storify/services/api_path.dart';
import 'package:storify/services/spotify_api.dart';
import 'package:storify/utils/general.dart';

class SpotifyAuth extends ChangeNotifier {
  User user;
  AuthTokens tokens;

  Future<void> authenticate() async {
    final clientId = DotEnv().env['CLIENT_ID'];
    final redirectUri = DotEnv().env['REDIRECT_URI'];
    final state = GeneralUtil.getRandomString(6);

    try {
      final result = await FlutterWebAuth.authenticate(
        url: APIPath.requestAuthorization(clientId, redirectUri, state),
        callbackUrlScheme: DotEnv().env['CALLBACK_URL_SCHEME'],
      );

      final returnedState = Uri.parse(result).queryParameters['state'];
      if (state != returnedState) throw HttpException('Invalid access');

      final code = Uri.parse(result).queryParameters['code'];

      tokens = await SpotifyApi.getAuthTokens(code, redirectUri);
      user = await SpotifyApi.getCurrentUser(token: tokens.accessToken);
      notifyListeners();
    } on Exception catch (e) {
      print(e); // TODO: Handle error
    }
  }
}
