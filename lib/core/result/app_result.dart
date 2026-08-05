/// A typed failure suitable for presentation without exposing implementation details.
sealed class AppError {
  const AppError(this.message);
  final String message;
}

class NetworkAppError extends AppError {
  const NetworkAppError(super.message);
}

class ValidationAppError extends AppError {
  const ValidationAppError(super.message);
}

class PermissionAppError extends AppError {
  const PermissionAppError(super.message);
}

class NotFoundAppError extends AppError {
  const NotFoundAppError(super.message);
}

class UnknownAppError extends AppError {
  const UnknownAppError(super.message);
}

/// Represents a successful value or a safe, displayable application error.
sealed class AppResult<T> {
  const AppResult();
}

class AppSuccess<T> extends AppResult<T> {
  const AppSuccess(this.data);
  final T data;
}

class AppFailure<T> extends AppResult<T> {
  const AppFailure(this.error);
  final AppError error;
}
