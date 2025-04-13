import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:rendezvous/core/routes/route_names.dart';
import 'package:rendezvous/core/theme/app_colors.dart';
import 'package:rendezvous/core/utils/core_utils.dart';
import 'package:rendezvous/core/utils/extensions.dart';
import 'package:rendezvous/src/admin-approval/presentation/providers/admin_approval_provider.dart';

class AdminApprovalScreen extends StatefulWidget {
  const AdminApprovalScreen({super.key});

  @override
  State<AdminApprovalScreen> createState() => _AdminApprovalScreenState();
}

class _AdminApprovalScreenState extends State<AdminApprovalScreen> {
  @override
  void initState() {
    super.initState();
    final _ = Provider.of<AdminApprovalProvider>(context, listen: false)
      ..startPolling();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Consumer<AdminApprovalProvider>(
          builder: (context, provider, _) {
            if (provider.status == 'User approved successfully.') {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacementNamed(context, RouteNames.dashboard);
              });
            }

            if (provider.error != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                CoreUtils.showErrorSnackbar(context, provider.error!);
              });
            }

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: const Center(
                    child: AutoSizeText(
                      minFontSize: 24,
                      maxFontSize: 28,
                      'Waiting for Approval',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.fontColor,
                      ),
                    ),
                  ),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 100),
                            Center(
                              child: DotLottieLoader.fromAsset(
                                'assets/lottie/approval_waiting.lottie',
                                frameBuilder: (
                                  BuildContext context,
                                  DotLottie? dotlottie,
                                ) {
                                  if (dotlottie != null) {
                                    return Lottie.memory(
                                      dotlottie.animations.values.single,
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 40),
                            const AutoSizeText(
                              minFontSize: 24,
                              maxFontSize: 28,
                              textAlign: TextAlign.center,
                              'Your account is awaiting admin approval. '
                              'Please wait...',
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
            );
          },
        ),
      ),
    );
  }
}
