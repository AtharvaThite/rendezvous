import 'package:rendezvous/core/usecase/usecase.dart';
import 'package:rendezvous/core/utils/typedefs.dart';
import 'package:rendezvous/src/admin-approval/domain/repo/admin_approval_repo.dart';

class CheckApprovalStatus extends UsecaseWithoutParams<String> {
  const CheckApprovalStatus(this._repo);

  final AdminApprovalRepo _repo;

  @override
  ResultFuture<String> call() async => _repo.checkApprovalStatus();
}
