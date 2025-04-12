import 'package:auto_size_text/auto_size_text.dart' show AutoSizeText;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rendezvous/core/theme/app_colors.dart';
import 'package:rendezvous/core/widgets/custom_date_picker.dart';
import 'package:rendezvous/core/widgets/custom_drop_down.dart';
import 'package:rendezvous/core/widgets/custom_textfield.dart';
import 'package:rendezvous/core/widgets/custom_video_picker.dart';
import 'package:rendezvous/src/onboarding/presentation/providers/onboarding_state_manager.dart';

class ProfileCreationPage extends StatefulWidget {
  const ProfileCreationPage({super.key});

  @override
  State<ProfileCreationPage> createState() => _ProfileCreationPageState();
}

class _ProfileCreationPageState extends State<ProfileCreationPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  String? selectedGender;
  String? selectedAppType;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
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

            Column(
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
                ),
                CustomTextField(
                  labelText: 'Email',
                  controller: emailController,
                ),

                CustomDropdown<String>(
                  labelText: 'Gender',
                  value: selectedGender,
                  items: const [
                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                    DropdownMenuItem(value: 'Female', child: Text('Female')),
                    DropdownMenuItem(value: 'Other', child: Text('Other')),
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
                  },
                ),
              ],
            ),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<OnboardingStateManager>().prevPage();
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
                  'Submit',
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
