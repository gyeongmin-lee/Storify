import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthTokens {
  AuthTokens(this.accessToken, this.refreshToken);
  String accessToken;
  String refreshToken;

  static String accessTokenKey = 'storify-access-token';
  static String refreshTokenKey = 'storify-refresh-token';

  AuthTokens.fromJson(Map<String, dynamic> json)
      : accessToken = json['access_token'],
        refreshToken = json['refresh_token'];

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
      };

  Future<void> saveToStorage() async {
    try {
      final storage = new FlutterSecureStorage();
      await storage.write(key: accessTokenKey, value: accessToken);
      await storage.write(key: refreshTokenKey, value: refreshToken);
    } catch (e) {
      print(e);
    }
  }

  static Future<AuthTokens> readFromStorage() async {
    String accessKey;
    String refreshKey;

    final storage = new FlutterSecureStorage();
    accessKey = await storage.read(key: accessTokenKey);
    refreshKey = await storage.read(key: refreshTokenKey);
    if (accessKey == null || refreshKey == null) return null;

    return AuthTokens(accessKey, refreshKey);
  }
}
