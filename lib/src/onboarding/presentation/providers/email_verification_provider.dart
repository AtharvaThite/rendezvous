import 'package:flutter/material.dart';
import 'package:rendezvous/src/onboarding/domain/usecases/request_email_code.dart';
import 'package:rendezvous/src/onboarding/domain/usecases/verify_email_code.dart';

class EmailVerificationProvider with ChangeNotifier {
  EmailVerificationProvider({
    required this.requestEmailCode,
    required this.verifyEmailCode,
  });
  final RequestEmailCode requestEmailCode;
  final VerifyEmailCode verifyEmailCode;

  String? _error;
  String? _successMessage;

  String? get error => _error;
  String? get successMessage => _successMessage;

  Future<void> requestCode(String email) async {
    _error = null;
    _successMessage = null;
    notifyListeners();

    final result = await requestEmailCode(email);

    result.fold(
      (failure) => _error = failure.message,
      (success) => _successMessage = success,
    );

    notifyListeners();
  }

  Future<void> verifyCode(String email, int code) async {
    _error = null;
    _successMessage = null;
    notifyListeners();

    final result = await verifyEmailCode(code);

    result.fold(
      (failure) => _error = failure.message,
      (success) => _successMessage = 'success',
    );

    notifyListeners();
  }

  void reset() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }
}
