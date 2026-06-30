part of 'api_service.dart';

class ApiMethods {
  ApiMethods({
    required String baseUrl,
    Dio? dio,
    Logger? logger,
  })  : _baseUrl = baseUrl,
        _dio = dio ?? Dio(),
        _logger = logger ?? Logger();

  final String _baseUrl;

  final Dio _dio;
  final Logger _logger;

  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? headers,
  }) async {
    return _handleRequest(
      _logger,
      () => _dio.get(
        '$_baseUrl/$path',
        options: Options(headers: headers),
      ),
    );
  }

  Future<Result<T>> post<T>(
    String path, {
    Map<String, dynamic>? headers,
    T? data,
  }) async {
    return _handleRequest(
      _logger,
      () => _dio.post(
        '$_baseUrl/$path',
        options: Options(headers: headers),
        data: data,
      ),
    );
  }

  Future<Result<T>> patch<T>(
    String path, {
    Map<String, dynamic>? headers,
    T? data,
  }) async {
    return _handleRequest(
      _logger,
      () => _dio.patch(
        '$_baseUrl/$path',
        options: Options(headers: headers),
        data: data,
      ),
    );
  }

  Future<Result<T>> put<T>(
    String path, {
    Map<String, dynamic>? headers,
    T? data,
  }) async {
    return _handleRequest(
      _logger,
      () => _dio.put(
        '$_baseUrl/$path',
        options: Options(headers: headers),
        data: data,
      ),
    );
  }

  Future<Result<T>> delete<T>(
    String path, {
    Map<String, dynamic>? headers,
  }) async {
    return _handleRequest(
      _logger,
      () => _dio.delete(
        '$_baseUrl/$path',
        options: Options(headers: headers),
      ),
    );
  }
}
