import 'package:auto_size_text/auto_size_text.dart' show AutoSizeText;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rendezvous/core/theme/app_colors.dart';
import 'package:rendezvous/core/utils/core_utils.dart';
import 'package:rendezvous/core/widgets/custom_textfield.dart';
import 'package:rendezvous/src/onboarding/presentation/providers/onboarding_state_manager.dart';

class VerifyEmailPage1 extends StatelessWidget {
  const VerifyEmailPage1({required this.emailController, super.key});

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 40,
        children: [
          const AutoSizeText(
            minFontSize: 24,
            maxFontSize: 28,
            'Let’s Get You Verified!  \u2714\ufe0f',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.fontColor,
            ),
          ),
          const AutoSizeText(
            minFontSize: 18,
            maxFontSize: 20,
            'Enter your email address to receive a \nverification code.',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.fontColor,
            ),
          ),

          CustomTextField(
            labelText: 'Enter Email',
            controller: emailController,
          ),

          Center(
            child: ElevatedButton(
              onPressed: () {
                CoreUtils.showSnackbar(context, 'Email Send');
                context.read<OnboardingStateManager>().nextPage();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: AppColors.primaryColor,
                shadowColor: AppColors.borderColor,
              ),
              child: const Text(
                'Send',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.fontColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
