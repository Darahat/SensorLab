library;

/// Base class for all custom exceptions in the application
///
/// All app-specific exceptions should extend this class

/// Base class for all custom exceptions in the application
///
/// All app-specific exceptions should extend this class

/// Base class for all custom exceptions in the application
///
/// All app-specific exceptions should extend this class
abstract class AppException implements Exception {
  /// Creates an [AppException]
  ///
  /// Requires [message] to describe the error
  /// [innerException] is optional
  const AppException(this.message, [this.innerException]);

  /// A message describing the error
  final String message;

  /// The underlying exception that caused this error
  final Exception? innerException;

  @override
  String toString() => innerException != null
      ? '$message (Inner exception: $innerException)'
      : message;
}

/// Thrown when there's an error communication with the server
class ServerException extends AppException {
  /// Creates a [ServerException] with an error message.
  const ServerException(super.message, [super.innerException]);

  @override
  String toString() => 'ServerException: $message';
}

/// Exception thrown when a cache operation fails.
class CacheException extends AppException {
  /// Creates a [CacheException] with an error message.
  const CacheException(super.message, [super.innerException]);

  @override
  String toString() => 'CacheException: $message';
}

/// Thrown when there's a network connectivity issue
class NetworkException extends AppException {
  /// Construction of NetworkException function so that it can be called from anywhere of this project
  const NetworkException(super.message, [super.innerException]);
}

/// Thrown when there's an error in input validation
class ValidationException extends AppException {
  /// Construction of this function so that it can be called from anywhere of this project

  const ValidationException(super.message, [super.innerException]);
}

/// Thrown when a requested resource is not found
class NotFoundException extends AppException {
  /// Construction of this function so that it can be called from anywhere of this project

  const NotFoundException(this.resourceType, this.identifier)
    : super('$resourceType with identifier $identifier not found');

  /// resourceType of identifier
  final String resourceType;

  /// carry value of  the identifier name
  final String identifier;
}

/// Thrown when authentication fails
class AuthenticationException extends AppException {
  /// Construction of this function so that it can be called from anywhere of this project

  const AuthenticationException(super.message);
}

/// Thrown when a user doesn't have permission to perform an action
class PermissionException extends AppException {
  /// Construction of this function so that it can be called from anywhere of this project

  const PermissionException(this.permission, String message) : super(message);

  /// variable which carry which kind of permission
  final String permission;

  @override
  String toString() => 'PermissionException for $permission: $message';
}

/// General-purpose custom exception
class CustomException extends AppException {
  /// Construction of this function so that it can be called from anywhere of this project

  const CustomException(super.message, [super.innerException]);
}

/// How you will call these exception

// throw NetworkException('🚀 ~No internet connection');
// throw ValidationException('🚀 ~Invalid email address');
// throw AuthenticationException('🚀 ~Invalid credentials');
// throw PermissionException('admin', '🚀 ~You do not have admin rights');
// throw NotFoundException('User', '🚀 ~1234');
// throw CacheException(message: '🚀 ~Failed to read from cache');
// throw ServerException(message: '🚀 ~Server error occurred');
