import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:storify/models/auth_tokens.dart';
import 'package:storify/models/user.dart';
import 'package:storify/services/api_path.dart';
import 'package:storify/services/spotify_api.dart';

class SpotifyAuth extends ChangeNotifier {
  User user;
  AuthTokens tokens;

  /// Authenticate user and and get token and user information
  ///
  /// Implemented using 'Authorization Code' flow from Spotify auth guide:
  /// https://developer.spotify.com/documentation/general/guides/authorization-guide/
  Future<void> authenticate() async {
    final clientId = DotEnv().env['CLIENT_ID'];
    final redirectUri = DotEnv().env['REDIRECT_URI'];
    final state = _getRandomString(6);

    try {
      final result = await FlutterWebAuth.authenticate(
        url: APIPath.requestAuthorization(clientId, redirectUri, state),
        callbackUrlScheme: DotEnv().env['CALLBACK_URL_SCHEME'],
      );

      final returnedState = Uri.parse(result).queryParameters['state'];
      if (state != returnedState) throw HttpException('Invalid access');

      final code = Uri.parse(result).queryParameters['code'];

      tokens = await SpotifyApi.getAuthTokens(code, redirectUri);
      await tokens.saveToStorage();

      await _updateUserWithToken();
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  /// If there is a saved token, use it to get new tokens and sign in
  Future<void> signInFromSavedTokens() async {
    try {
      final savedTokens = await AuthTokens.readFromStorage();
      if (savedTokens == null) throw Exception("No saved token found");

      tokens = await SpotifyApi.getNewTokens(originalTokens: savedTokens);
      await tokens.saveToStorage();

      await _updateUserWithToken();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> _updateUserWithToken() async {
    user = await SpotifyApi.getCurrentUser(token: tokens.accessToken);
    notifyListeners();
  }

  static String _getRandomString(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
}
