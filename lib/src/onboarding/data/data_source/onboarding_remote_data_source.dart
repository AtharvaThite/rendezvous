import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:rendezvous/core/errors/exceptions.dart';
import 'package:rendezvous/core/utils/api_urls.dart';
import 'package:rendezvous/core/utils/shared_prefs_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OnboardingRemoteDataSource {
  const OnboardingRemoteDataSource();

  Future<String> requestEmailCode({required String email});
  Future<void> verifyEmailCode({required String email, required String code});
}

class OnboardingRemoteDataSourceImpl extends OnboardingRemoteDataSource {
  OnboardingRemoteDataSourceImpl(this._prefs, this._client);

  final SharedPreferences _prefs;
  final http.Client _client;

  @override
  Future<String> requestEmailCode({required String email}) async {
    try {
      await _prefs.setString(SharedPrefsKeys.email, email);
      final response = await _client.post(
        Uri.parse(ApiUrls.requestEmailCode),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return responseBody['message'] as String;
      } else {
        throw APIException(
          statusCode: response.statusCode,
          message: responseBody['error'] as String,
        );
      }
    } on APIException {
      rethrow;
    } catch (e) {
      throw const APIException(
        statusCode: 800,
        message: 'Something went wrong',
      );
    }
  }

  @override
  Future<void> verifyEmailCode({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(ApiUrls.verifyEmailCode),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email,'code': code}),
      );
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        log('Email code verified');
        await _prefs.setBool(SharedPrefsKeys.isEmailVerified, true);

        return;
      } else {
        log('Verification failed: ${response.statusCode}');
        throw APIException(
          statusCode: response.statusCode,
          message: responseBody['error'] as String,
        );
      }
    } on APIException {
      rethrow;
    } catch (e, s) {
      log('Exception: $e', stackTrace: s);
      throw const APIException(
        statusCode: 800,
        message: 'Something went wrong',
      );
    }
  }
}
