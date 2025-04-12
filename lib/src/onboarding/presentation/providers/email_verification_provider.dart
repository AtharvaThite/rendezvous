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

  String? _emailSentError;
  String? _codeVerifyError;
  String? _emailSentSuccessMessage;
  String? _codeVerifySuccessMessage;

  String? get emailSentError => _emailSentError;
  String? get codeVerifyError => _codeVerifyError;
  String? get emailSentSuccessMessage => _emailSentSuccessMessage;
  String? get codeVerifySuccessMessage => _codeVerifySuccessMessage;

  Future<void> requestCode(String email) async {
    reset();
    notifyListeners();

    final result = await requestEmailCode(email);

    result.fold(
      (failure) => _emailSentError = failure.message,
      (success) => _emailSentSuccessMessage = success,
    );

    notifyListeners();
  }

  Future<void> verifyCode(VerifyCodeParams verifyCodeParams) async {
    reset();
    notifyListeners();

    final result = await verifyEmailCode(verifyCodeParams);

    result.fold(
      (failure) => _codeVerifyError = failure.message,
      (success) => _codeVerifySuccessMessage = 'Verification Successful',
    );

    notifyListeners();
  }

  void reset() {
    _emailSentError = null;
    _codeVerifyError = null;
    _emailSentSuccessMessage = null;
    notifyListeners();
  }
}
