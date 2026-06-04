import 'package:flutter_result/src/core/result/result.dart';

import 'package:flutter_result/src/services/api_service/failure_type.dart';

final class ApiFailure extends Failure {
  ApiFailure({
    required this.type,
    required this.message,
  });

  final FailureType type;

  final String message;
}
