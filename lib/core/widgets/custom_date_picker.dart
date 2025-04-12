import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rendezvous/core/theme/app_colors.dart';

class CustomDatePickerField extends StatelessWidget {
  const CustomDatePickerField({
    required this.labelText,
    required this.controller,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.validator,
    super.key,
  });

  final String labelText;
  final TextEditingController controller;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;
  final String? Function(String?)? validator;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.borderColor,
              onPrimary: Colors.white,
              onSurface: AppColors.fontColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
      onTap: () => _selectDate(context),
      onTapUpOutside: (_) => FocusScope.of(context).unfocus(),
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
        suffixIcon: const Icon(
          Icons.calendar_today,
          color: AppColors.fontColor,
        ),
      ),
    );
  }
}
