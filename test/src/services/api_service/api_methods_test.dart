import 'package:dio/dio.dart';
import 'package:flutter_result/src/core/result/result.dart';
import 'package:flutter_result/src/services/api_service/api_failure.dart';
import 'package:flutter_result/src/services/api_service/api_service.dart';
import 'package:flutter_result/src/services/api_service/failure_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

ApiMethods _apiWithInterceptor(
  void Function(RequestOptions options, RequestInterceptorHandler handler)
      onRequest,
) {
  final dio = Dio()
    ..interceptors.add(InterceptorsWrapper(onRequest: onRequest));
  return ApiMethods(
    baseUrl: 'https://example.com',
    dio: dio,
    logger: Logger(level: Level.off),
  );
}

Future<ApiFailure> _failureFor(
  DioException Function(RequestOptions options) build,
) async {
  final api = _apiWithInterceptor((options, handler) {
    handler.reject(build(options));
  });

  final result = await api.get<Map<String, dynamic>>('users');
  return (result as FailureResult<Map<String, dynamic>>).failure as ApiFailure;
}

void main() {
  group('successful responses', () {
    test('returns SuccessResult when status is 2xx and data is present',
        () async {
      final api = _apiWithInterceptor((options, handler) {
        handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {'ok': true},
          ),
        );
      });

      final result = await api.get<Map<String, dynamic>>('users');

      expect(result, isA<SuccessResult<Map<String, dynamic>>>());
      expect(
        (result as SuccessResult<Map<String, dynamic>>).value,
        {'ok': true},
      );
    });

    test('returns FailureResult when status is 2xx but data is null',
        () async {
      final api = _apiWithInterceptor((options, handler) {
        handler.resolve(Response(requestOptions: options, statusCode: 204));
      });

      final result = await api.get<Map<String, dynamic>>('users');

      final failure =
          (result as FailureResult<Map<String, dynamic>>).failure
              as ApiFailure;
      expect(failure.type, FailureType.unknownError);
      expect(failure.message, 'Response body is null');
    });
  });

  group('unexpected non-Dio errors', () {
    test('returns FailureResult when response data does not match type T',
        () async {
      final api = _apiWithInterceptor((options, handler) {
        handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {'unexpected': 'shape'},
          ),
        );
      });

      final result = await api.get<String>('users');

      final failure = (result as FailureResult<String>).failure as ApiFailure;
      expect(failure.type, FailureType.unknownError);
      expect(failure.message, isNotEmpty);
    });
  });

  group('DioException handling', () {
    test('cancel', () async {
      final failure = await _failureFor(
        (options) => DioException(
          requestOptions: options,
          type: DioExceptionType.cancel,
        ),
      );
      expect(failure.type, FailureType.cancel);
      expect(failure.message, 'Request cancelled');
    });

    test('connectionTimeout', () async {
      final failure = await _failureFor(
        (options) => DioException(
          requestOptions: options,
          type: DioExceptionType.connectionTimeout,
        ),
      );
      expect(failure.type, FailureType.connectTimeout);
    });

    test('receiveTimeout', () async {
      final failure = await _failureFor(
        (options) => DioException(
          requestOptions: options,
          type: DioExceptionType.receiveTimeout,
        ),
      );
      expect(failure.type, FailureType.receiveTimeout);
    });

    test('sendTimeout', () async {
      final failure = await _failureFor(
        (options) => DioException(
          requestOptions: options,
          type: DioExceptionType.sendTimeout,
        ),
      );
      expect(failure.type, FailureType.sendTimeout);
    });

    test('badCertificate', () async {
      final failure = await _failureFor(
        (options) => DioException(
          requestOptions: options,
          type: DioExceptionType.badCertificate,
        ),
      );
      expect(failure.type, FailureType.badCertificate);
    });

    test('connectionError', () async {
      final failure = await _failureFor(
        (options) => DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
        ),
      );
      expect(failure.type, FailureType.connectionError);
    });

    test('unknown type with SocketException message maps to networkError',
        () async {
      final failure = await _failureFor(
        (options) => DioException(
          requestOptions: options,
          message: 'SocketException: Failed host lookup',
        ),
      );
      expect(failure.type, FailureType.networkError);
      expect(failure.message, 'Network error: No internet connection');
    });

    test('unknown type without SocketException message maps to unknownError',
        () async {
      final failure = await _failureFor(
        (options) => DioException(
          requestOptions: options,
          message: 'boom',
        ),
      );
      expect(failure.type, FailureType.unknownError);
      expect(failure.message, 'Unknown error: boom');
    });

    const badResponseCases = <int, FailureType>{
      400: FailureType.badRequest,
      401: FailureType.unauthorized,
      403: FailureType.forbidden,
      404: FailureType.notFound,
      405: FailureType.methodNotAllowed,
      408: FailureType.requestTimeout,
      409: FailureType.conflict,
      429: FailureType.tooManyRequests,
      500: FailureType.internalServerError,
      502: FailureType.badGateway,
      503: FailureType.serviceUnavailable,
      418: FailureType.badResponse,
    };

    for (final entry in badResponseCases.entries) {
      test('badResponse ${entry.key} maps to ${entry.value}', () async {
        final failure = await _failureFor(
          (options) => DioException(
            requestOptions: options,
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: options,
              statusCode: entry.key,
            ),
          ),
        );
        expect(failure.type, entry.value);
      });
    }
  });

  group('request building', () {
    test('get, post, patch, put and delete hit the right path and method',
        () async {
      final captured = <String, String>{};
      final api = _apiWithInterceptor((options, handler) {
        captured[options.method] = options.path;
        handler.resolve(
          Response<Map<String, dynamic>>(
            requestOptions: options,
            statusCode: 200,
            data: <String, dynamic>{},
          ),
        );
      });

      await api.get<Map<String, dynamic>>('a');
      await api.post<Map<String, dynamic>>('b');
      await api.patch<Map<String, dynamic>>('c');
      await api.put<Map<String, dynamic>>('d');
      await api.delete<Map<String, dynamic>>('e');

      expect(captured['GET'], 'https://example.com/a');
      expect(captured['POST'], 'https://example.com/b');
      expect(captured['PATCH'], 'https://example.com/c');
      expect(captured['PUT'], 'https://example.com/d');
      expect(captured['DELETE'], 'https://example.com/e');
    });
  });
}
