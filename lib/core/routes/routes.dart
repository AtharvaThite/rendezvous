import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rendezvous/core/routes/route_names.dart';
import 'package:rendezvous/core/services/dependacy_injection.dart';
import 'package:rendezvous/src/onboarding/presentation/providers/onboarding_state_manager.dart';
import 'package:rendezvous/src/onboarding/presentation/views/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RouteNames.onboardingScreen:
      return _pageRouteBuilder(
        (context) => ChangeNotifierProvider(
          create: (context) => OnboardingStateManager(),
          child: const OnboardingScreen(),
        ),
        settings: settings,
      );

    // Route to Page Not Found (Default) Page
    default:
      return _pageRouteBuilder((_) => const Placeholder(), settings: settings);
  }
}

PageRouteBuilder<dynamic> _pageRouteBuilder(
  Widget Function(BuildContext) page, {
  required RouteSettings settings,
}) {
  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (context, _, __) => page(context),
    transitionsBuilder: (_, animation, __, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
