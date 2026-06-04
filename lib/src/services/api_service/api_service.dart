import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import 'package:flutter_result/src/core/constants/urls.dart';
import 'package:flutter_result/src/core/result/result.dart';
import 'package:flutter_result/src/services/api_service/api_failure.dart';
import 'package:flutter_result/src/services/api_service/failure_type.dart';

part 'api_methods.dart';
part 'select_failure.dart';
part 'handle_request.dart';

class ApiService {
  static ApiMethods get http => ApiMethods(
        baseUrl: Urls.httpUrl,
      );
}
