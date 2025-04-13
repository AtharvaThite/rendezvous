import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart' show AutoSizeText;
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rendezvous/core/routes/route_names.dart';
import 'package:rendezvous/core/services/dependacy_injection.dart';
import 'package:rendezvous/core/theme/app_colors.dart';
import 'package:rendezvous/core/utils/core_utils.dart';
import 'package:rendezvous/core/utils/shared_prefs_keys.dart';
import 'package:rendezvous/core/widgets/custom_date_picker.dart';
import 'package:rendezvous/core/widgets/custom_drop_down.dart';
import 'package:rendezvous/core/widgets/custom_textfield.dart';
import 'package:rendezvous/core/widgets/custom_video_picker.dart';
import 'package:rendezvous/core/widgets/rounded_loading_button.dart';
import 'package:rendezvous/src/onboarding/presentation/providers/email_verification_provider.dart';
import 'package:rendezvous/src/onboarding/presentation/providers/onboarding_state_manager.dart';
import 'package:rendezvous/src/onboarding/presentation/providers/profile_submission_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCreationPage extends StatefulWidget {
  const ProfileCreationPage({super.key});

  @override
  State<ProfileCreationPage> createState() => _ProfileCreationPageState();
}

class _ProfileCreationPageState extends State<ProfileCreationPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final submitButtonController = RoundedLoadingButtonController();

  final profileFormKey = GlobalKey<FormState>();
  final prefs = sl<SharedPreferences>();

  late ProfileSubmissionProvider profileSubmissionProvider;
  late EmailVerificationProvider emailVerificationProvider;

  String? selectedGender;
  String? selectedAppType;
  PlatformFile? selectedVideo;

  @override
  void initState() {
    profileSubmissionProvider = context.read<ProfileSubmissionProvider>();

    profileSubmissionProvider.addListener(() {
      if (profileSubmissionProvider.errorMessage != null) {
        errorHandler(error: profileSubmissionProvider.errorMessage!);
      }
      if (profileSubmissionProvider.successMessage != null) {
        emailSentHandler(message: profileSubmissionProvider.successMessage!);
      }
    });

    fetchEmail();
    super.initState();
  }

  Future<void> errorHandler({required String error}) async {
    log('5');
    submitButtonController.error();
    CoreUtils.showErrorSnackbar(context, error);
    await Future<void>.delayed(const Duration(seconds: 1));
    submitButtonController.reset();
    profileSubmissionProvider.reset();
  }

  Future<void> emailSentHandler({required String message}) async {
    log('6');
    submitButtonController.success();
    CoreUtils.showSnackbar(context, message);
    await Future<void>.delayed(const Duration(seconds: 1));
    submitButtonController.reset();
    profileSubmissionProvider.reset();
    navigate();
  }

  void navigate() {
    Navigator.pushReplacementNamed(context, RouteNames.adminApprovalScreen);
  }

  void fetchEmail() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingStateManager>().setEmail(
        prefs.getString(SharedPrefsKeys.email) ?? '',
      );

      final value = context.read<OnboardingStateManager>().emailAddress;

      if (value.isNotEmpty) {
        emailController.text = value;
      }
    });
  }

  Future<void> _performCreateUser() async {
    if (profileFormKey.currentState!.validate()) {
      final video = await MultipartFile.fromFile(
        selectedVideo!.path!,
        filename: selectedVideo!.name,
      );
      final formData = FormData.fromMap({
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'dob': dobController.text.trim(),
        'gender': selectedGender,
        'purposeOfUsingApp': selectedAppType,
        'nonReferralVerificationVideo': video,
        'password': '123456',
      });
      log('message');
      await profileSubmissionProvider.createUser(formData);
      CoreUtils.showSnackbar(context, 'Profile Completed');
      final userID = prefs.getString(SharedPrefsKeys.userId) ?? '';
      if (userID.isNotEmpty) {
        navigate();
      }
      submitButtonController.reset();
    } else {
      submitButtonController.reset();
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              'Now let’s build your profile and get you started 🚀',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.fontColor,
              ),
            ),

            Form(
              key: profileFormKey,
              child: Column(
                spacing: 14,
                children: [
                  CustomTextField(
                    labelText: 'First Name',
                    controller: firstNameController,
                  ),
                  CustomTextField(
                    labelText: 'Last Name',
                    controller: lastNameController,
                  ),
                  CustomTextField(
                    labelText: 'Phone Number',
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  CustomTextField(
                    labelText: 'Email',
                    controller: emailController,
                    readOnly: true,
                    validator: (p0) {
                      return null;
                    },
                  ),

                  CustomDropdown<String>(
                    labelText: 'Gender',
                    value: selectedGender,
                    items: const [
                      DropdownMenuItem(value: 'male', child: Text('Male')),
                      DropdownMenuItem(value: 'female', child: Text('Female')),
                      DropdownMenuItem(value: 'other', child: Text('Other')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                  ),
                  CustomDatePickerField(
                    labelText: 'Date of Birth',
                    controller: dobController,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  ),
                  CustomDropdown<String>(
                    labelText: 'Purpose of the App',
                    value: selectedAppType,
                    items: const [
                      DropdownMenuItem(value: 'Spark', child: Text('Spark')),
                      DropdownMenuItem(value: 'Linkup', child: Text('Linkup')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedAppType = value;
                      });
                    },
                  ),
                  CustomVideoPickerField(
                    labelText: 'Select Intro Video',
                    onVideoSelected: (video) {
                      print('Selected video: ${video.name}');
                      selectedVideo = video;
                    },
                  ),
                ],
              ),
            ),

            RoundedLoadingButton(
              controller: submitButtonController,
              onPressed: _performCreateUser,
              child: const Text(
                'Submit',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.fontColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
