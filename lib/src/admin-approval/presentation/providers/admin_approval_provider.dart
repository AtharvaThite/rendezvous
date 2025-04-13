import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rendezvous/src/admin-approval/domain/usecase/check_approval_status.dart';

class AdminApprovalProvider with ChangeNotifier {
  AdminApprovalProvider(this.checkStatus);
  final CheckApprovalStatus checkStatus;

  Timer? _pollingTimer;
  String _status = 'pending';
  String? _error;

  String get status => _status;
  String? get error => _error;

  void startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 20), (timer) async {
      print('object');

      await checkApproval();
    });
  }

  Future<void> checkApproval() async {
    print('provider check status');
    final result = await checkStatus();
    result.fold(
      (failure) => _error = failure.message,
      (status) => _status = status,
    );
    notifyListeners();
    if (_status == 'User approved successfully.') {
      _pollingTimer?.cancel();
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}
