import 'dart:developer';

import 'package:rendezvous/core/utils/typedefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OnboardingRemoteDataSource {
  const OnboardingRemoteDataSource();
  ResultVoid requestEmailCode({required String email});
  ResultFuture<void> verifyEmailCode({required int code});
}

class OnboardingRemoteDataSourceImpl extends OnboardingRemoteDataSource {
  OnboardingRemoteDataSourceImpl(this._prefs);
  final SharedPreferences _prefs;
  @override
  ResultVoid requestEmailCode({required String email}) {
    log('message');
    throw UnimplementedError();
  }

  @override
  ResultFuture<void> verifyEmailCode({required int code}) {
    log('message2');
    throw UnimplementedError();
  }
}
