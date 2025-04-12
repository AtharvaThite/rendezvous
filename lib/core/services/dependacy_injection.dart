import 'package:get_it/get_it.dart' show GetIt;
import 'package:rendezvous/src/onboarding/data/data_source/onboarding_remote_data_source.dart';
import 'package:rendezvous/src/onboarding/data/repo_impl/onboarding_repo_impl.dart';
import 'package:rendezvous/src/onboarding/domain/repo/onboarding_repo.dart';
import 'package:rendezvous/src/onboarding/domain/usecases/request_email_code.dart';
import 'package:rendezvous/src/onboarding/domain/usecases/verify_email_code.dart';
import 'package:rendezvous/src/onboarding/presentation/providers/email_verification_provider.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  await _initPrefs();
  await _initHttp();
  await _initOnboarding();
}

Future<void> _initPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);
}

Future<void> _initHttp() async {
  final client = http.Client();
  sl.registerLazySingleton(() => client);
}

Future<void> _initOnboarding() async {
  // Feature --> Onboarding
  sl
    ..registerLazySingleton<OnboardingRemoteDataSource>(
      () => OnboardingRemoteDataSourceImpl(sl(), sl()),
    )
    ..registerLazySingleton<OnboardingRepo>(() => OnboardingRepoImpl(sl()))
    ..registerLazySingleton(() => RequestEmailCode(sl()))
    ..registerLazySingleton(() => VerifyEmailCode(sl()))
    ..registerFactory(
      () => EmailVerificationProvider(
        requestEmailCode: sl(),
        verifyEmailCode: sl(),
      ),
    );
}
