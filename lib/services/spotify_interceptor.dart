import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:storify/models/auth_tokens.dart';

class SpotifyInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    final storage = new FlutterSecureStorage();
    final accessToken = await storage.read(key: AuthTokens.accessTokenKey);
    data.headers
        .addAll({HttpHeaders.authorizationHeader: 'Bearer $accessToken'});
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    return data;
  }
}

class ExpiredTokenRetryPolicy extends RetryPolicy {
  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    if (response.statusCode == 401) {
      print("Token expired, updating token...");
      await AuthTokens.updateTokenToLatest();
      print("Updated");
      return true;
    }

    return false;
  }
}
