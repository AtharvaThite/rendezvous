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

  EmailVerificationState _state = EmailVerificationInitial();
  EmailVerificationState get state => _state;

  Future<void> requestCode(String email) async {
    _state = EmailVerificationLoading();
    notifyListeners();

    final result = await requestEmailCode(email);

    result.fold(
      (failure) {
        _state = EmailVerificationFailure(failure.message);
        notifyListeners();
      },
      (_) {
        _state = EmailVerificationSuccess('success');
        notifyListeners();
      },
    );
  }

  Future<void> verifyCode(String email, int code) async {
    _state = EmailVerificationLoading();
    notifyListeners();

    final result = await verifyEmailCode(code);

    result.fold(
      (failure) {
        _state = EmailVerificationFailure(failure.message);
        notifyListeners();
      },
      (_) {
        _state = EmailVerificationSuccess('success');
        notifyListeners();
      },
    );
  }

  void reset() {
    _state = EmailVerificationInitial();
    notifyListeners();
  }
}

abstract class EmailVerificationState {}

class EmailVerificationInitial extends EmailVerificationState {}

class EmailVerificationLoading extends EmailVerificationState {}

class EmailVerificationSuccess extends EmailVerificationState {
  EmailVerificationSuccess(this.message);
  final String message;
}

class EmailVerificationFailure extends EmailVerificationState {
  EmailVerificationFailure(this.error);
  final String error;
}
