part of 'api_service.dart';

class ApiMethods {
  ApiMethods({
    required String baseUrl,
  }) : _baseUrl = baseUrl;

  final String _baseUrl;

  final _dio = Dio();
  final _logger = Logger();

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

  void close() {
    _dio.close();
    _logger.close();
  }
}
