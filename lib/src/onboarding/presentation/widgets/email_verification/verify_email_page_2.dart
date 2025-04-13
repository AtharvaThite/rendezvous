import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart' show AutoSizeText;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rendezvous/core/services/dependacy_injection.dart';
import 'package:rendezvous/core/theme/app_colors.dart';
import 'package:rendezvous/core/utils/core_utils.dart';
import 'package:rendezvous/core/utils/shared_prefs_keys.dart';
import 'package:rendezvous/core/widgets/custom_textfield.dart';
import 'package:rendezvous/core/widgets/rounded_loading_button.dart';
import 'package:rendezvous/src/onboarding/domain/usecases/verify_email_code.dart';
import 'package:rendezvous/src/onboarding/presentation/providers/email_verification_provider.dart';
import 'package:rendezvous/src/onboarding/presentation/providers/onboarding_state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyEmailPage2 extends StatefulWidget {
  const VerifyEmailPage2({super.key});

  @override
  State<VerifyEmailPage2> createState() => _VerifyEmailPage2State();
}

class _VerifyEmailPage2State extends State<VerifyEmailPage2> {
  final codeController = TextEditingController();
  final verifyButtonController = RoundedLoadingButtonController();
  final verifyCodeFormKey = GlobalKey<FormState>();
  final prefs = sl<SharedPreferences>();

  String email = '';

  @override
  void initState() {
    super.initState();
    email = prefs.getString(SharedPrefsKeys.email) ?? '';
    if (email.isEmpty) {
      email = context.read<OnboardingStateManager>().emailAddress;
    }
  }

  Future<void> verifyErrorHandler({required String error}) async {
    verifyButtonController.error();
    CoreUtils.showErrorSnackbar(context, error);
    await Future<void>.delayed(const Duration(seconds: 1));
    verifyButtonController.reset();
  }

  Future<void> resendEmailErrorHandler({required String error}) async {
    CoreUtils.showErrorSnackbar(context, error);
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  Future<void> verifySuccessHandler({required String message}) async {
    verifyButtonController.success();
    CoreUtils.showSnackbar(context, message);
    await Future<void>.delayed(const Duration(seconds: 1));
    verifyButtonController.reset();
    navigate();
  }

  Future<void> resendEmailSuccessHandler({required String message}) async {
    CoreUtils.showSnackbar(context, message);
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  void navigate() {
    context.read<OnboardingStateManager>().nextPage();
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmailVerificationProvider>(
      builder: (context, provider, state) {
        if (provider.codeVerifyError != null) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            verifyErrorHandler(error: provider.codeVerifyError!);
          });
        }
        if (provider.codeVerifySuccessMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            verifySuccessHandler(message: provider.codeVerifySuccessMessage!);
          });
        }
        if (provider.emailSentError != null) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            resendEmailErrorHandler(error: provider.emailSentError!);
          });
        }
        if (provider.emailSentSuccessMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            resendEmailSuccessHandler(
              message: provider.emailSentSuccessMessage!,
            );
          });
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
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
                  'We’ve sent a 6-digit code to your email.\n'
                  'Enter it below to verify your identity.',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.fontColor,
                  ),
                ),

                Form(
                  key: verifyCodeFormKey,
                  child: CustomTextField(
                    labelText: 'Enter Verification Code',
                    controller: codeController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(6),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),

                Center(
                  child: RoundedLoadingButton(
                    controller: verifyButtonController,
                    onPressed: () {
                      if (codeController.text.length != 6) {
                        CoreUtils.showSnackbar(
                          context,
                          'Please Enter a six digit verification code',
                        );
                        verifyButtonController.reset();
                      } else {
                        if (verifyCodeFormKey.currentState!.validate()) {
                          log(email);
                          log(codeController.text);
                          final params = VerifyCodeParams(
                            code: codeController.text.trim(),
                            email: email,
                          );
                          provider.verifyCode(params);
                        } else {
                          verifyButtonController.reset();
                        }
                      }
                    },
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
                                  if (email.isNotEmpty) {
                                    provider.requestCode(email);
                                  } else {
                                    CoreUtils.showSnackbar(
                                      context,
                                      'Email Address not found',
                                    );
                                  }
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
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
