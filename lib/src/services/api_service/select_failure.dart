part of 'api_service.dart';

FailureResult<T> _selectFailure<T>(
  DioException err,
) {
  FailureType? type;
  String? message;

  switch (err.type) {
    case DioExceptionType.cancel:
      type = FailureType.cancel;
      message = 'Request cancelled';
    case DioExceptionType.connectionTimeout:
      type = FailureType.connectTimeout;
      message = 'Connection timeout';
    case DioExceptionType.receiveTimeout:
      type = FailureType.receiveTimeout;
      message = 'Receive timeout';
    case DioExceptionType.sendTimeout:
      type = FailureType.sendTimeout;
      message = 'Send timeout';
    case DioExceptionType.badCertificate:
      type = FailureType.badCertificate;
      message = 'Bad certificate';
    case DioExceptionType.connectionError:
      type = FailureType.connectionError;
      message = 'Connection error';
    case DioExceptionType.badResponse:
      switch (err.response?.statusCode) {
        case 400:
          type = FailureType.badRequest;
          message = 'Invalid request.';
        case 401:
          type = FailureType.unauthorized;
          message = 'You are not authorized to access this route.';
        case 403:
          type = FailureType.forbidden;
          message = 'Access to this resource is forbidden.';
        case 404:
          type = FailureType.notFound;
          message = 'Page not found.';
        case 405:
          type = FailureType.methodNotAllowed;
          message = 'Method not allowed for this route.';
        case 408:
          type = FailureType.requestTimeout;
          message = 'Request timeout.';
        case 409:
          type = FailureType.conflict;
          message = 'Conflict in the request.';
        case 429:
          type = FailureType.tooManyRequests;
          message = 'Too many requests being made.';
        case 500:
          type = FailureType.internalServerError;
          message = 'Internal server error.';
        case 502:
          type = FailureType.badGateway;
          message = 'Bad gateway.';
        case 503:
          type = FailureType.serviceUnavailable;
          message = 'Service temporarily unavailable.';
        default:
          type = FailureType.networkError;
          message = 'Unknown error occurred: ${err.response?.statusCode}';
      }
    case _:
      if (err.message?.contains('SocketException') ?? false) {
        type = FailureType.networkError;
        message = 'Network error: No internet connection';
      } else {
        type = FailureType.unknownError;
        message = 'Unknown error: ${err.message}';
      }
  }

  return FailureResult(
    ApiFailure(
      type: type,
      message: message,
    ),
  );
}
