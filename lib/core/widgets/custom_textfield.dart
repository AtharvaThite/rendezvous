import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rendezvous/core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.labelText,
    required this.controller,
    this.overrideValidator = false,
    this.obscureText = false,
    this.readOnly = false,
    this.validator,
    this.suffixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.initailValue,
    super.key,
  });

  final String? Function(String?)? validator;
  final TextEditingController controller;
  final String labelText;
  final bool overrideValidator;
  final bool obscureText;
  final Widget? suffixIcon;
  final bool readOnly;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? initailValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initailValue,
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
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
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.fontColor,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(width: 2, color: AppColors.borderColor),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(width: 2, color: AppColors.borderColor),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(width: 2, color: AppColors.error),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(width: 2, color: AppColors.borderColor),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(width: 2, color: AppColors.borderColor),
        ),

        suffixIcon: suffixIcon,
      ),
    );
  }
}
