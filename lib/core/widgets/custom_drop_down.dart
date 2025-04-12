import 'package:flutter/material.dart';
import 'package:rendezvous/core/theme/app_colors.dart';

class CustomDropdown<T> extends StatelessWidget {
  const CustomDropdown({
    required this.labelText,
    required this.items,
    required this.onChanged,
    this.value,
    this.validator,
    this.readOnly = false,
    super.key,
  });

  final String labelText;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;
  final T? value;
  final String? Function(T?)? validator;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: readOnly ? null : onChanged,
      validator:
          validator ??
          (v) {
            if (v == null) {
              return 'This field is required';
            }
            return null;
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
      ),
    );
  }
}
