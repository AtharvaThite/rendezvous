import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rendezvous/core/theme/app_colors.dart';
import 'package:rendezvous/core/utils/extensions.dart';
import 'package:rendezvous/src/onboarding/presentation/providers/onboarding_state_manager.dart';
import 'package:rendezvous/src/onboarding/presentation/widgets/email_verification/verify_email_page_1.dart';
import 'package:rendezvous/src/onboarding/presentation/widgets/email_verification/verify_email_page_2.dart';
import 'package:rendezvous/src/onboarding/presentation/widgets/onboarding_header.dart';
import 'package:rendezvous/src/onboarding/presentation/widgets/profile_creation_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final emailController = TextEditingController();
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: const OnboardingHeader(),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 40, bottom: 40),
                width: context.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(90),
                  ),
                  color: AppColors.secondaryColor,
                ),
                child: PageView(
                  controller:
                      context.read<OnboardingStateManager>().pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    context.read<OnboardingStateManager>().onPageChanged(index);
                  },
                  children: [
                    const VerifyEmailPage1(),
                    VerifyEmailPage2(emailController: emailController),
                    const ProfileCreationPage(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
