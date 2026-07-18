part of 'api_service.dart';

Future<Result<T>> _handleRequest<T>(
  Logger logger,
  Future<Response<T>> Function() request,
) async {
  try {
    final result = await request();

    if (result.data == null) {
      return FailureResult(
        ApiFailure(
          type: FailureType.unknownError,
          message: 'Response body is null',
        ),
      );
    }

    return SuccessResult<T>(result.data as T);
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
