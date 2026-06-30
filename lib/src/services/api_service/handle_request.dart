part of 'api_service.dart';

Future<Result<T>> _handleRequest<T>(
  Logger logger,
  Future<Response<T>> Function() request,
) async {
  try {
    final result = await request();

    final isSuccessStatusCode = result.statusCode != null &&
        result.statusCode! >= 200 &&
        result.statusCode! < 300;

    if (isSuccessStatusCode) {
      if (result.data == null) {
        return FailureResult(
          ApiFailure(
            type: FailureType.unknownError,
            message: 'Response body is null',
          ),
        );
      }

      return SuccessResult<T>(result.data as T);
    }

    var message = 'Status Code: ${result.statusCode}.';

    if (result.data.toString().isNotEmpty) {
      message += '\n${result.data}';
    }

    logger.w(
      'Warning Log',
      error: message,
    );

    return FailureResult(
      ApiFailure(
        type: FailureType.unknownError,
        message: message,
      ),
    );
  } on DioException catch (err, stackTrace) {
    logger.e(
      'Error Log',
      error: err,
      stackTrace: stackTrace,
    );

    return _selectFailure(err);
  } catch (err, stackTrace) {
    logger.e(
      'Error Log',
      error: err,
      stackTrace: stackTrace,
    );

    return FailureResult(
      ApiFailure(
        type: FailureType.unknownError,
        message: err.toString(),
      ),
    );
  }
}
