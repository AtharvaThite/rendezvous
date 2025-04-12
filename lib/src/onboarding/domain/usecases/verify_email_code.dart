import 'package:rendezvous/core/usecase/usecase.dart';
import 'package:rendezvous/core/utils/typedefs.dart';
import 'package:rendezvous/src/onboarding/domain/repo/onboarding_repo.dart';

class VerifyEmailCode extends UsecaseWithParams<void, int> {
  const VerifyEmailCode(this._repo);

  final OnboardingRepo _repo;

  @override
  ResultFuture<void> call(int code) async => _repo.verifyEmailCode(code: code);
}
