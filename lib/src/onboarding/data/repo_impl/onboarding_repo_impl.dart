import 'package:rendezvous/core/utils/typedefs.dart';
import 'package:rendezvous/src/onboarding/data/data_source/onboarding_remote_data_source.dart';
import 'package:rendezvous/src/onboarding/domain/repo/onboarding_repo.dart';

class OnboardingRepoImpl extends OnboardingRepo {
  const OnboardingRepoImpl(this._remoteDataSource);
  final OnboardingRemoteDataSource _remoteDataSource;
  @override
  ResultVoid requestEmailCode({required String email}) {
    // TODO: implement requestEmailCode
    throw UnimplementedError();
  }

  @override
  ResultFuture<void> verifyEmailCode({required int code}) {
    // TODO: implement verifyEmailCode
    throw UnimplementedError();
  }
}
