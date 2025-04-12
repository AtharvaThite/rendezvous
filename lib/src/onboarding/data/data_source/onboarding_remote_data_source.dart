import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:rendezvous/core/errors/exceptions.dart';
import 'package:rendezvous/core/utils/api_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OnboardingRemoteDataSource {
  const OnboardingRemoteDataSource();

  Future<String> requestEmailCode({required String email});
  Future<void> verifyEmailCode({required int code});
}

class OnboardingRemoteDataSourceImpl extends OnboardingRemoteDataSource {
  OnboardingRemoteDataSourceImpl(this._prefs, this._client);

  final SharedPreferences _prefs;
  final http.Client _client;

  @override
  Future<String> requestEmailCode({required String email}) async {
    try {
      final response = await _client.post(
        Uri.parse(ApiUrls.requestEmailCode),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        log('Email code requested successfully');
        log(response.body);
        final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        return responseBody['message'] as String;
      } else {
        log('Failed with status: ${response.statusCode}');
        throw APIException(
          statusCode: response.statusCode,
          message: response.body,
        );
      }
    } catch (e, s) {
      log('Exception: $e', stackTrace: s);
      throw const APIException(
        statusCode: 800,
        message: 'Something went wrong',
      );
    }
  }

  @override
  Future<void> verifyEmailCode({required int code}) async {
    try {
      final response = await _client.post(
        Uri.parse(ApiUrls.requestEmailCode),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code}),
      );

      if (response.statusCode == 200) {
        log('Email code verified');
        return;
      } else {
        log('Verification failed: ${response.statusCode}');
        throw APIException(
          statusCode: response.statusCode,
          message: response.body,
        );
      }
    } catch (e, s) {
      log('Exception: $e', stackTrace: s);
      throw const APIException(
        statusCode: 800,
        message: 'Something went wrong',
      );
    }
  }
}
