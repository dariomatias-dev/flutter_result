part of 'api_service.dart';

FailureResult<T> _selectFailure<T>(
  DioException err,
) {
  final (type, message) = switch (err.type) {
    DioExceptionType.cancel => (
        FailureType.cancel,
        'Request cancelled',
      ),
    DioExceptionType.connectionTimeout => (
        FailureType.connectTimeout,
        'Connection timeout',
      ),
    DioExceptionType.receiveTimeout => (
        FailureType.receiveTimeout,
        'Receive timeout',
      ),
    DioExceptionType.sendTimeout => (
        FailureType.sendTimeout,
        'Send timeout',
      ),
    DioExceptionType.badCertificate => (
        FailureType.badCertificate,
        'Bad certificate',
      ),
    DioExceptionType.connectionError => (
        FailureType.connectionError,
        'Connection error',
      ),
    DioExceptionType.badResponse => switch (err.response?.statusCode) {
        400 => (FailureType.badRequest, 'Invalid request.'),
        401 => (
            FailureType.unauthorized,
            'You are not authorized to access this route.',
          ),
        403 => (
            FailureType.forbidden,
            'Access to this resource is forbidden.',
          ),
        404 => (FailureType.notFound, 'Page not found.'),
        405 => (
            FailureType.methodNotAllowed,
            'Method not allowed for this route.',
          ),
        408 => (FailureType.requestTimeout, 'Request timeout.'),
        409 => (FailureType.conflict, 'Conflict in the request.'),
        429 => (
            FailureType.tooManyRequests,
            'Too many requests being made.',
          ),
        500 => (FailureType.internalServerError, 'Internal server error.'),
        502 => (FailureType.badGateway, 'Bad gateway.'),
        503 => (
            FailureType.serviceUnavailable,
            'Service temporarily unavailable.',
          ),
        _ => (
            FailureType.badResponse,
            'Unknown error occurred: ${err.response?.statusCode}',
          ),
      },
    _ => (err.message?.contains('SocketException') ?? false)
        ? (FailureType.networkError, 'Network error: No internet connection')
        : (FailureType.unknownError, 'Unknown error: ${err.message}'),
  };

  return FailureResult(
    ApiFailure(
      type: type,
      message: message,
    ),
  );
}
