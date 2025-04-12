import 'package:equatable/equatable.dart';
import 'package:rendezvous/core/errors/exceptions.dart';

// Abstract base class for handling failures in the application.
abstract class Failure extends Equatable {
  Failure({required this.message, required this.statusCode})
    : assert(
        statusCode is String || statusCode is int,
        'StatusCode cannot be a${statusCode.runtimeType}',
      );

  final String message;
  final dynamic statusCode;

  String get errorMessage => message;

  @override
  List<Object?> get props => [message, statusCode];
}

// Represents failures related to API calls.
class ApiFailure extends Failure {
  ApiFailure({required super.message, required super.statusCode});

  ApiFailure.fromException(APIException exception)
    : this(message: exception.message, statusCode: exception.statusCode);
}

// Represents failures related to caching operations.
class CacheFailure extends Failure {
  CacheFailure({required super.message, required super.statusCode});

  CacheFailure.fromException(CacheException exception)
    : this(message: exception.message, statusCode: exception.statusCode);
}
