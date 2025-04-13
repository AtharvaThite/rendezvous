import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:http/http.dart' as http;
import 'package:rendezvous/src/admin-approval/data/data_source/admin_approval_remote_data_source.dart';
import 'package:rendezvous/src/admin-approval/data/repo_impl/admin_approval_repo_impl.dart';
import 'package:rendezvous/src/admin-approval/domain/repo/admin_approval_repo.dart';
import 'package:rendezvous/src/admin-approval/domain/usecase/check_approval_status.dart';
import 'package:rendezvous/src/admin-approval/presentation/providers/admin_approval_provider.dart';
import 'package:rendezvous/src/onboarding/data/data_source/onboarding_remote_data_source.dart';
import 'package:rendezvous/src/onboarding/data/repo_impl/onboarding_repo_impl.dart';
import 'package:rendezvous/src/onboarding/domain/repo/onboarding_repo.dart';
import 'package:rendezvous/src/onboarding/domain/usecases/create_user.dart';
import 'package:rendezvous/src/onboarding/domain/usecases/request_email_code.dart';
import 'package:rendezvous/src/onboarding/domain/usecases/verify_email_code.dart';
import 'package:rendezvous/src/onboarding/presentation/providers/email_verification_provider.dart';
import 'package:rendezvous/src/onboarding/presentation/providers/profile_submission_provider.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

final sl = GetIt.instance;

Future<void> init() async {
  await _initPrefs();
  await _initHttp();
  await _initDio();
  await _initOnboarding();
  await _initAdminApproval();
}

Future<void> _initPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);
}

Future<void> _initHttp() async {
  final client = http.Client();
  sl.registerLazySingleton(() => client);
}

Future<void> _initDio() async {
  final options = BaseOptions(
    validateStatus: (status) {
      return status != null;
    },
  );
  final dio = Dio(options);
  sl.registerLazySingleton(() => dio);
}

Future<void> _initOnboarding() async {
  // Feature --> Onboarding
  sl
    ..registerLazySingleton<OnboardingRemoteDataSource>(
      () => OnboardingRemoteDataSourceImpl(sl(), sl(), sl()),
    )
    ..registerLazySingleton<OnboardingRepo>(() => OnboardingRepoImpl(sl()))
    // UseCases
    ..registerLazySingleton(() => RequestEmailCode(sl()))
    ..registerLazySingleton(() => VerifyEmailCode(sl()))
    ..registerLazySingleton(() => CreateUser(sl()))
    // Providers
    ..registerFactory(
      () => EmailVerificationProvider(
        requestEmailCode: sl(),
        verifyEmailCode: sl(),
      ),
    )
    ..registerFactory(() => ProfileSubmissionProvider(createUser: sl()));
}

Future<void> _initAdminApproval() async {
  sl
    ..registerLazySingleton<AdminApprovalRemoteDataSource>(
      () => AdminApprovalRemoteDataSourceImpl(sl(), sl()),
    )
    ..registerLazySingleton<AdminApprovalRepo>(
      () => AdminApprovalRepoImpl(sl()),
    )
    // UseCases
    ..registerLazySingleton(() => CheckApprovalStatus(sl()))
    // Providers
    ..registerFactory(() => AdminApprovalProvider(sl()));
}
