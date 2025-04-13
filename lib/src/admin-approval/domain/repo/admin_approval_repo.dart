import 'package:rendezvous/core/utils/typedefs.dart';

abstract class AdminApprovalRepo {
  const AdminApprovalRepo();

  ResultFuture<String> checkApprovalStatus();
}
