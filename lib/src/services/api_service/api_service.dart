import 'package:dio/dio.dart';
import 'package:flutter_result/src/core/result/failure_type.dart';
import 'package:logger/logger.dart';

import 'package:flutter_result/src/core/constants/urls.dart';
import 'package:flutter_result/src/core/result/result.dart';

part 'api_methods.dart';
part 'select_failure.dart';
part 'handle_request.dart';

class ApiService {
  static ApiMethods get http => ApiMethods(
        baseUrl: Urls.httpUrl,
      );
}
