import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rendezvous/core/theme/app_colors.dart';
import 'package:rendezvous/core/utils/extensions.dart';
import 'package:rendezvous/src/onboarding/presentation/widgets/onboarding_header.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 100),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/rendezvous_app_logo.png',
                            height: 100,
                            width: 100,
                          ),
                        ),
                        const SizedBox(height: 40),
                        const AutoSizeText(
                          minFontSize: 24,
                          maxFontSize: 28,
                          'Rendezvous',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.fontColor,
                          ),
                        ),
                      ],
                    ),
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
