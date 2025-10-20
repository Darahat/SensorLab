/// Base class for all failures in the application.
///
/// All domain-specific failures should extend this class.
abstract class Failure {
  /// Creates a [Failure] with a message describing the error.
  const Failure({required this.message});

  /// A message describing the error.
  final String message;

  @override
  String toString() => message;
}

/// Represents a failure that occurred when communicating with the server.
class ServerFailure extends Failure {
  /// Creates a [ServerFailure] with a message describing the server error.
  ///
  /// Optionally includes a [statusCode] from the HTTP response.
  const ServerFailure({required super.message, this.statusCode});

  /// The HTTP status code associated with the failure, if available.
  final int? statusCode;

  @override
  String toString() => statusCode != null
      ? 'Server error: $message (Status code: $statusCode)'
      : 'Server error: $message';
}

/// Represents a failure that occurred when accessing local cache.
class CacheFailure extends Failure {
  /// Creates a [CacheFailure] with a message describing the cache error.
  const CacheFailure({required super.message});
  @override
  String toString() => 'Cache error: $message';
}

/// Represents a failure due to network connectivity issues.
class NetworkFailure extends Failure {
  /// Creates a [NetworkFailure] with a message describing the network error.
  const NetworkFailure({required super.message});

  @override
  String toString() => 'Network error: $message';
}

/// Represents a failure due to invalid input or validation errors.
class ValidationFailure extends Failure {
  /// Creates a [ValidationFailure] with a message describing the validation error.
  ///
  /// Optionally includes a map of [fieldErrors] for specific field validation failures.
  const ValidationFailure({
    required super.message,
    this.fieldErrors = const {},
  });

  /// A map of field names to error messages for field-specific validation errors.
  final Map<String, String> fieldErrors;

  @override
  String toString() {
    if (fieldErrors.isEmpty) {
      return 'Validation error: $message';
    }

    final fieldsWithErrors = fieldErrors.entries
        .map((entry) => '${entry.key}: ${entry.value}')
        .join(', ');

    return 'Validation error: $message (Fields: $fieldsWithErrors)';
  }
}

/// Represents a failure when a requested resource is not found.
class NotFoundFailure extends Failure {
  /// Creates a [NotFoundFailure] with details about the resource that wasn't found.
  const NotFoundFailure({required this.resourceType, required this.identifier})
    : super(message: '$resourceType with identifier $identifier not found');

  /// The type of resource that wasn't found (e.g., "User", "Task").
  final String resourceType;

  /// The identifier that was used to look up the resource.
  final String identifier;

  @override
  String toString() => 'Not found: $resourceType with ID $identifier';
}

/// Represents a failure due to authentication issues.
class AuthFailure extends Failure {
  /// Creates an [AuthFailure] with a message describing the authentication error.
  const AuthFailure({required super.message});

  @override
  String toString() => 'Authentication error: $message';
}

/// Represents a failure due to insufficient permissions.
class PermissionFailure extends Failure {
  /// Creates a [PermissionFailure] with details about the permission that was denied.
  const PermissionFailure({required this.permission, required super.message});

  /// The permission that was denied.
  final String permission;

  @override
  String toString() => 'Permission denied: $permission - $message';
}

// return Left(CacheFailure(message: 'Cache error'));
// return Left(NetworkFailure(message: 'No internet'));
// return Left(ValidationFailure(message: 'Invalid input'));
// return Left(NotFoundFailure(resourceType: 'Task', identifier: '123'));
// return Left(AuthFailure(message: 'Invalid credentials'));
// return Left(PermissionFailure(permission: 'admin', message: 'Denied'));
