import 'package:rendezvous/core/utils/typedefs.dart';

abstract class OnboardingRepo {
  const OnboardingRepo();

  ResultFuture<String> requestEmailCode({required String email});
  ResultFuture<void> verifyEmailCode({required int code});
}
