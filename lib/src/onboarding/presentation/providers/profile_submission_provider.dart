import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rendezvous/src/onboarding/domain/usecases/create_user.dart';

class ProfileSubmissionProvider with ChangeNotifier {
  ProfileSubmissionProvider({required this.createUser});
  final CreateUser createUser;

  String? _errorMessage;
  String? _successMessage;

  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<void> submitUser(FormData data) async {
    reset();
    notifyListeners();

    final result = await createUser(data);

    result.fold(
      (failure) => _errorMessage = failure.message,
      (success) => _successMessage = 'Profile Created',
    );

    notifyListeners();
  }

  void reset() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}
