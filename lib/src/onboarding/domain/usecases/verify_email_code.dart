import 'package:equatable/equatable.dart';
import 'package:rendezvous/core/usecase/usecase.dart';
import 'package:rendezvous/core/utils/typedefs.dart';
import 'package:rendezvous/src/onboarding/domain/repo/onboarding_repo.dart';

class VerifyEmailCode extends UsecaseWithParams<void, VerifyCodeParams> {
  const VerifyEmailCode(this._repo);

  final OnboardingRepo _repo;

  @override
  ResultFuture<void> call(VerifyCodeParams params) async =>
      _repo.verifyEmailCode(email: params.email, code: params.code);
}

class VerifyCodeParams extends Equatable {
  const VerifyCodeParams({required this.code, required this.email});
  const VerifyCodeParams.empty() : this(email: '', code: '');
  final String email;
  final String code;

  @override
  List<String> get props => [email, code];
}
