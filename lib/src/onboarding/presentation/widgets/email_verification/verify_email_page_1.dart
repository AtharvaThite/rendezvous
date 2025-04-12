import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rendezvous/core/theme/app_colors.dart';
import 'package:rendezvous/core/utils/core_utils.dart';
import 'package:rendezvous/core/widgets/custom_textfield.dart';
import 'package:rendezvous/core/widgets/rounded_loading_button.dart';
import 'package:rendezvous/src/onboarding/presentation/providers/email_verification_provider.dart';
import 'package:rendezvous/src/onboarding/presentation/providers/onboarding_state_manager.dart';

class VerifyEmailPage1 extends StatefulWidget {
  const VerifyEmailPage1({super.key});

  @override
  State<VerifyEmailPage1> createState() => _VerifyEmailPage1State();
}

class _VerifyEmailPage1State extends State<VerifyEmailPage1> {
  final emailController = TextEditingController();
  final sendButtonController = RoundedLoadingButtonController();
  final emailFormKey = GlobalKey<FormState>();

  late EmailVerificationProvider emailVerificationProvider;

  @override
  void initState() {
    super.initState();
    emailVerificationProvider = context.read<EmailVerificationProvider>();

    emailVerificationProvider.addListener(() {
      if (emailVerificationProvider.error != null) {
        errorHandler(error: emailVerificationProvider.error!);
      }
      if (emailVerificationProvider.successMessage != null) {
        emailSentHandler(message: emailVerificationProvider.successMessage!);
      }
    });
  }

  Future<void> errorHandler({required String error}) async {
    sendButtonController.error();
    CoreUtils.showErrorSnackbar(context, error);
    await Future<void>.delayed(const Duration(seconds: 1));
    sendButtonController.reset();
    emailVerificationProvider.reset();
  }

  Future<void> emailSentHandler({required String message}) async {
    sendButtonController.success();
    CoreUtils.showSnackbar(context, message);
    await Future<void>.delayed(const Duration(seconds: 1));
    sendButtonController.reset();
    emailVerificationProvider.reset();
    navigate();
  }

  void navigate() {
    context.read<OnboardingStateManager>().nextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const AutoSizeText(
              minFontSize: 24,
              maxFontSize: 28,
              'Let’s Get You Verified! ✅',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.fontColor,
              ),
            ),
            const SizedBox(height: 20),
            const AutoSizeText(
              minFontSize: 18,
              maxFontSize: 20,
              'Enter your email address to receive a \nverification code.',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.fontColor,
              ),
            ),
            const SizedBox(height: 40),

            Form(
              key: emailFormKey,
              child: CustomTextField(
                labelText: 'Enter Email',
                controller: emailController,
              ),
            ),
            const SizedBox(height: 40),

            Center(
              child: RoundedLoadingButton(
                controller: sendButtonController,
                onPressed: () async {
                  sendButtonController.start();
                  if (emailFormKey.currentState!.validate()) {
                    log('request code called');
                    await emailVerificationProvider.requestCode(
                      emailController.text.trim(),
                    );
                  } else {
                    sendButtonController.reset();
                  }
                },
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
      ),
    );
  }
}
