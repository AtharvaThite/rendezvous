import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rendezvous/core/routes/route_names.dart';
import 'package:rendezvous/core/services/dependacy_injection.dart';
import 'package:rendezvous/core/utils/shared_prefs_keys.dart';
import 'package:rendezvous/src/admin-approval/presentation/providers/admin_approval_provider.dart';
import 'package:rendezvous/src/admin-approval/presentation/views/admin_approval_screen.dart';
import 'package:rendezvous/src/dashboard/presentation/views/dashboard.dart';
import 'package:rendezvous/src/onboarding/presentation/providers/email_verification_provider.dart';
import 'package:rendezvous/src/onboarding/presentation/providers/onboarding_state_manager.dart';
import 'package:rendezvous/src/onboarding/presentation/providers/profile_submission_provider.dart';
import 'package:rendezvous/src/onboarding/presentation/views/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RouteNames.onboardingScreen:
      final prefs = sl<SharedPreferences>();
      final isEmailVerified =
          prefs.getBool(SharedPrefsKeys.isEmailVerified) ?? false;
      final isProfileCompleted =
          prefs.getBool(SharedPrefsKeys.isProfileCompleted) ?? false;
      final isProfileApproved =
          prefs.getBool(SharedPrefsKeys.isProfileApproved) ?? false;

      log('isEmailVerified = $isEmailVerified');
      log('isProfileCompleted = $isProfileCompleted');
      log('isProfileApproved = $isProfileApproved');
      return _pageRouteBuilder((context) {
        if (!isEmailVerified) {
          log('000');
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => sl<ProfileSubmissionProvider>(),
              ),
              ChangeNotifierProvider(
                create: (context) => sl<EmailVerificationProvider>(),
              ),
              ChangeNotifierProvider(
                create: (context) => OnboardingStateManager()..setPageIndex(0),
              ),
            ],
            builder: (context, child) => const OnboardingScreen(),
          );
        } else if (!isProfileCompleted && isEmailVerified) {
          log('000000');
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => sl<ProfileSubmissionProvider>(),
              ),

              ChangeNotifierProvider(
                create: (context) => sl<EmailVerificationProvider>(),
              ),
              ChangeNotifierProvider(
                create: (context) => OnboardingStateManager()..setPageIndex(2),
              ),
            ],
            child: const OnboardingScreen(),
          );
        } else if (isProfileCompleted &&
            isEmailVerified &&
            !isProfileApproved) {
          return ChangeNotifierProvider(
            create: (context) => sl<AdminApprovalProvider>(),
            builder: (context, child) => const AdminApprovalScreen(),
          );
        } else if (isProfileCompleted && isEmailVerified && isProfileApproved) {
          return const Dashboard();
        } else {
          return const Placeholder();
        }
      }, settings: settings);

    case RouteNames.adminApprovalScreen:
      return _pageRouteBuilder(
        (_) => ChangeNotifierProvider(
          create: (context) => sl<AdminApprovalProvider>(),
          builder: (context, child) => const AdminApprovalScreen(),
        ),
        settings: settings,
      );

    case RouteNames.dashboard:
      return _pageRouteBuilder((_) => const Dashboard(), settings: settings);
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
