import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rendezvous/core/errors/exceptions.dart';
import 'package:rendezvous/core/utils/api_urls.dart';
import 'package:rendezvous/core/utils/shared_prefs_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AdminApprovalRemoteDataSource {
  const AdminApprovalRemoteDataSource();

  Future<String> checkApprovalStatus();
}

class AdminApprovalRemoteDataSourceImpl extends AdminApprovalRemoteDataSource {
  AdminApprovalRemoteDataSourceImpl(this._prefs, this._client);

  final SharedPreferences _prefs;
  final http.Client _client;

  @override
  Future<String> checkApprovalStatus() async {
    try {
      print('check status remote data source');
      final userId = _prefs.getString(SharedPrefsKeys.userId) ?? '';
      final response = await _client.patch(
        Uri.parse('${ApiUrls.adminApproval}/$userId'),
        headers: {'Content-Type': 'application/json'},
      );
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        await _prefs.setBool(SharedPrefsKeys.isProfileApproved, true);
        print('check status $responseBody');

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
}
