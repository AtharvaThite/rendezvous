import 'package:auto_size_text/auto_size_text.dart' show AutoSizeText;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rendezvous/core/theme/app_colors.dart';
import 'package:rendezvous/core/widgets/custom_textfield.dart';
import 'package:rendezvous/src/onboarding/presentation/providers/onboarding_state_manager.dart';

class VerifyEmailPage2 extends StatelessWidget {
  const VerifyEmailPage2({required this.emailController, super.key});

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
            'Check Your Inbox! 📬',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.fontColor,
            ),
          ),
          const AutoSizeText(
            minFontSize: 18,
            maxFontSize: 20,
            'We’ve sent a 6-digit code to your email.\nEnter it below to verify your identity.',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.fontColor,
            ),
          ),

          CustomTextField(
            labelText: 'Enter Verification Code',
            controller: emailController,
          ),

          Center(
            child: ElevatedButton(
              onPressed: () {
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
                'Verify',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.fontColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Didn’t get it?\n',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.fontColor,
                ),
                children: [
                  TextSpan(
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            // Add your onTap logic here
                          },
                    text: 'Click Here ',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.linkColor,
                    ),
                  ),
                  const TextSpan(
                    text: 'to Resend Code!',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
