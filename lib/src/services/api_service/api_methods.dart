part of 'api_service.dart';

class ApiMethods {
  ApiMethods({
    required String baseUrl,
  }) : _baseUrl = baseUrl;

  final String _baseUrl;

  final _dio = Dio();
  final _logger = Logger();

  Future<Result<T?>> get<T>(
    String path, {
    Map<String, dynamic>? headers,
  }) async {
    return await _callHandleRequest(
      _dio.get(
        options: Options(
          headers: headers,
        ),
        '$_baseUrl/$path',
      ),
    );
  }

  Future<Result<T?>> post<T>(
    String path, {
    Map<String, dynamic>? headers,
    T? data,
  }) async {
    return await _callHandleRequest(
      _dio.post(
        options: Options(
          headers: headers,
        ),
        '$_baseUrl/$path',
        data: data,
      ),
    );
  }

  Future<Result<T?>> patch<T>(
    String path, {
    Map<String, dynamic>? headers,
    T? data,
  }) async {
    return await _callHandleRequest(
      _dio.patch(
        options: Options(
          headers: headers,
        ),
        '$_baseUrl/$path',
        data: data,
      ),
    );
  }

  Future<Result<T?>> put<T>(
    String path, {
    Map<String, dynamic>? headers,
    T? data,
  }) async {
    return await _callHandleRequest(
      _dio.put(
        options: Options(
          headers: headers,
        ),
        '$_baseUrl/$path',
        data: data,
      ),
    );
  }

  Future<Result<T?>> delete<T>(
    String path, {
    Map<String, dynamic>? headers,
  }) async {
    return await _callHandleRequest(
      _dio.delete(
        options: Options(
          headers: headers,
        ),
        '$_baseUrl/$path',
      ),
    );
  }

  Future<Result<T?>> _callHandleRequest<T>(
    Future<Response<T>> request,
  ) async {
    return _handleRequest(
      _logger,
      () => request,
    );
  }

  void close() {
    _dio.close();
    _logger.close();
  }
}
