import 'package:flutter/material.dart';

import 'package:flutter_result/src/services/api_service/api_failure.dart';
import 'package:flutter_result/src/services/api_service/api_service.dart';
import 'package:flutter_result/src/services/api_service/failure_type.dart';
import 'package:flutter_result/src/shared/utils/handle_error.dart';
import 'package:flutter_result/src/shared/utils/show_loading.dart';

class ApiSuccessResult {
  ApiSuccessResult({
    required this.statusCode,
    required this.message,
  });

  factory ApiSuccessResult.fromJson(Map<String, dynamic> json) {
    return ApiSuccessResult(
      statusCode: json['status'] as int,
      message: json['message'] as String,
    );
  }

  final int statusCode;
  final String message;
}

class HttpController {
  HttpController({ApiMethods? api}) : _api = api ?? ApiService.http;

  final ApiMethods _api;

  Future<void> request(BuildContext context, int statusCode) async {
    final result = await showLoading(
      context,
      () => _api.get<Map<String, dynamic>>('$statusCode'),
    );

    await result.whenAsync(
      onSuccess: (value) async {
        try {
          final apiSuccess = ApiSuccessResult.fromJson(value);
          await _handleSuccess(context, apiSuccess);
        } catch (_) {
          if (!context.mounted) return;
          await handleError(
            context,
            ApiFailure(
              type: FailureType.unknownError,
              message: 'Failed to parse response body',
            ),
          );
        }
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
    ApiSuccessResult apiSuccess,
  ) async {
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            'Success',
            textAlign: TextAlign.center,
          ),
          children: <Widget>[
            Text(
              'Status: ${apiSuccess.statusCode}\nResult: ${apiSuccess.message}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
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
    // Only badGateway gets bespoke handling here, as an example of local
    // error handling; every other FailureType falls back to handleError.
    switch (failure.type) {
      case FailureType.badGateway:
        if (!context.mounted) return;
        await showDialog<void>(
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
      case _:
        await handleError(context, failure);
    }
  }
}
