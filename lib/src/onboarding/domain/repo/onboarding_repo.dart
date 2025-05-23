import 'package:dio/dio.dart';
import 'package:rendezvous/core/utils/typedefs.dart';

abstract class OnboardingRepo {
  const OnboardingRepo();

  ResultFuture<String> requestEmailCode({required String email});
  ResultFuture<void> verifyEmailCode({
    required String email,
    required String code,
  });
  ResultFuture<void> createUser({required FormData params});
}
