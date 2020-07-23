class AuthTokens {
  AuthTokens(this.accessToken, this.refreshToken);
  final String accessToken;
  final String refreshToken;

  AuthTokens.fromJson(Map<String, dynamic> json)
      : accessToken = json['access_token'],
        refreshToken = json['refresh_token'];

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
      };
}
