import 'package:get_it/get_it.dart' show GetIt;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

final sl = GetIt.instance;

Future<void> init() async {
  await _initPrefs();
}

Future<void> _initPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);
}
