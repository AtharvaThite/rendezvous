import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rendezvous/core/errors/exceptions.dart';
import 'package:rendezvous/core/errors/failure.dart';
import 'package:rendezvous/core/utils/typedefs.dart';
import 'package:rendezvous/src/onboarding/data/data_source/onboarding_remote_data_source.dart';
import 'package:rendezvous/src/onboarding/domain/repo/onboarding_repo.dart';
import 'package:rendezvous/src/onboarding/domain/usecases/create_user.dart';

class OnboardingRepoImpl extends OnboardingRepo {
  const OnboardingRepoImpl(this._remoteDataSource);
  final OnboardingRemoteDataSource _remoteDataSource;
  @override
  ResultFuture<String> requestEmailCode({required String email}) async {
    try {
      final result = await _remoteDataSource.requestEmailCode(email: email);
      return Right(result);
    } on APIException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> verifyEmailCode({
    required String email,
    required String code,
  }) async {
    try {
      await _remoteDataSource.verifyEmailCode(email: email, code: code);
      return const Right(null);
    } on APIException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> createUser({required FormData params}) async {
    try {
      await _remoteDataSource.createUser(formData: params);
      return const Right(null);
    } on APIException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  // @override
  // ResultFuture<void> createUser({required FormData params}) async {
  //   try {
  //     await _remoteDataSource.createUser(formData: params);
  //     log('6');
  //     return const Right(null);
  //   } catch (e, s) {
  //     log('Caught unexpected error in Repo: $e', stackTrace: s);
  //     return Left(ApiFailure.fromException(e as APIException));
  //   }
  // }
}
