import 'package:flutter/material.dart';
import 'package:rendezvous/core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.labelText,
    required this.controller,
    this.overrideValidator = false,
    this.obscureText = false,
    this.validator,
    this.suffixIcon,
    super.key,
  });

  final String? Function(String?)? validator;
  final TextEditingController controller;
  final String labelText;
  final bool overrideValidator;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator:
          overrideValidator
              ? validator
              : (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return validator?.call(value);
              },
      onTapUpOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.fontColor,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(width: 2, color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(width: 2, color: AppColors.borderColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(width: 2, color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(width: 2, color: AppColors.borderColor),
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(width: 2, color: AppColors.borderColor),
        ),

        suffixIcon: suffixIcon,
      ),
    );
  }
}
