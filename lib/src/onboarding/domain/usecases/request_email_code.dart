import 'package:rendezvous/core/usecase/usecase.dart';
import 'package:rendezvous/core/utils/typedefs.dart';
import 'package:rendezvous/src/onboarding/domain/repo/onboarding_repo.dart';

class RequestEmailCode extends UsecaseWithParams<void, String> {
  const RequestEmailCode(this._repo);

  final OnboardingRepo _repo;

  @override
  ResultVoid call(String email) async => _repo.requestEmailCode(email: email);
}
