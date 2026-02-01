import 'package:flutter/material.dart';

import 'package:flutter_result/src/core/result/failure_type.dart';
import 'package:flutter_result/src/core/result/result.dart';

import 'package:flutter_result/src/features/http/status_codes.dart';

import 'package:flutter_result/src/services/api_service/api_service.dart';
import 'package:flutter_result/src/shared/utils/handle_error.dart';

import 'package:flutter_result/src/shared/utils/show_loading.dart';

class ApiSuccessResult {
  final int statusCode;
  final String message;

  ApiSuccessResult({
    required this.statusCode,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
    };
  }

  factory ApiSuccessResult.fromJson(Map<String, dynamic> json) {
    return ApiSuccessResult(
      statusCode: json['status'],
      message: json['message'],
    );
  }
}

class HttpController {
  final _api = ApiService.http;

  int statusCode = statusCodes.first;

  Future<void> request(BuildContext context) async {
    final result = await showLoading(
      context,
      () => _api.get<Map<String, dynamic>>('$statusCode'),
    );

    await result.whenAsync(
      onSuccess: (value) async {
        await _handleSuccess(context, value);
      },
      onFailure: (failure) async {
        switch (failure) {
          case ApiFailure():
            await _handleApiFailure(context, failure);
        }
      },
    );
  }

  Future<void> _handleSuccess(
    BuildContext context,
    Map<String, dynamic>? value,
  ) async {
    final apiSuccess = ApiSuccessResult.fromJson(value!);

    await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            'Success',
            textAlign: TextAlign.center,
          ),
          children: <Widget>[
            Text(
              'Result: ${apiSuccess.message}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            Align(
              alignment: AlignmentGeometry.bottomRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Ok'),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleApiFailure(
    BuildContext context,
    ApiFailure failure,
  ) async {
    switch (failure.type) {
      case FailureType.badGateway:
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Local Treatment',
                textAlign: TextAlign.center,
              ),
              content: const Text(
                'Local error handling',
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
        break;
      default:
        await handleError(context, failure);
    }
  }

  void dispose() {
    _api.close();
  }
}
