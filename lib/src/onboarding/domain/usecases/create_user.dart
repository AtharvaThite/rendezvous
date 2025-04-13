import 'package:dio/dio.dart';
import 'package:rendezvous/core/usecase/usecase.dart';
import 'package:rendezvous/core/utils/typedefs.dart';
import 'package:rendezvous/src/onboarding/domain/repo/onboarding_repo.dart';

class CreateUser extends UsecaseWithParams<void, FormData> {
  const CreateUser(this._repo);

  final OnboardingRepo _repo;

  @override
  ResultFuture<void> call(FormData params) async =>
      _repo.createUser(params: params);
}
