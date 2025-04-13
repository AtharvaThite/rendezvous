import 'package:dartz/dartz.dart';
import 'package:rendezvous/core/errors/exceptions.dart';
import 'package:rendezvous/core/errors/failure.dart';
import 'package:rendezvous/core/utils/typedefs.dart';
import 'package:rendezvous/src/admin-approval/data/data_source/admin_approval_remote_data_source.dart';
import 'package:rendezvous/src/admin-approval/domain/repo/admin_approval_repo.dart';

class AdminApprovalRepoImpl extends AdminApprovalRepo {
  const AdminApprovalRepoImpl(this._remoteDataSource);
  final AdminApprovalRemoteDataSource _remoteDataSource;
  @override
  ResultFuture<String> checkApprovalStatus() async {
    try {
      final result = await _remoteDataSource.checkApprovalStatus();
      return Right(result);
    } on APIException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }
}
