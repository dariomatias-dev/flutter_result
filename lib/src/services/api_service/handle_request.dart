part of 'api_service.dart';

Future<Result<T?>> _handleRequest<T>(
  Logger logger,
  Future<Response<T>> Function() request,
) async {
  try {
    final result = await request();

    if (result.statusCode == 200 || result.statusCode == 201) {
      return SuccessResult<T?>(result.data);
    }

    String message = 'Status Code: ${result.statusCode}.';

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
