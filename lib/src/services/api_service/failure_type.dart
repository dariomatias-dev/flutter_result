// Mapped Failure Types
enum FailureType {
  /// 400
  badRequest,

  /// 401
  unauthorized,

  /// 403
  forbidden,

  /// 404
  notFound,

  /// 405
  methodNotAllowed,

  /// 408
  requestTimeout,

  /// 409
  conflict,

  /// 429
  tooManyRequests,

  /// 500
  internalServerError,

  /// 502
  badGateway,

  /// 503
  serviceUnavailable,

  /// For request cancellation
  cancel,

  /// For connection timeout errors
  connectTimeout,

  /// For receiving timeout errors
  receiveTimeout,

  /// For sending timeout errors
  sendTimeout,

  /// For network related errors
  networkError,

  /// For bad certificate errors
  badCertificate,

  /// For bad response errors
  badResponse,

  /// For connection errors
  connectionError,

  /// For unspecified errors
  unknownError,
}
