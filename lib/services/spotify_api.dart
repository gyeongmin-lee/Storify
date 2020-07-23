import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:storify/models/auth_tokens.dart';
import 'package:http/http.dart' as http;
import 'package:storify/models/user.dart';
import 'package:storify/services/api_path.dart';

class SpotifyApi {
  static final clientId = DotEnv().env['CLIENT_ID'];
  static final clientSecret = DotEnv().env['CLIENT_SECRET'];

  static Future<AuthTokens> getAuthTokens(
      String code, String redirectUri) async {
    final base64Credential =
        utf8.fuse(base64).encode('$clientId:$clientSecret');
    final response = await http.post(
      APIPath.requestToken,
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,
      },
      headers: {HttpHeaders.authorizationHeader: 'Basic $base64Credential'},
    );

    if (response.statusCode == 200) {
      return AuthTokens.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to load token with status code ${response.statusCode}');
    }
  }

  static Future<User> getCurrentUser({@required String token}) async {
    final response = await http.get(APIPath.getCurrentUser,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to get user with status code ${response.statusCode}');
    }
  }
}
