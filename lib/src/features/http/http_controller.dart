import 'package:flutter/material.dart';

import 'package:flutter_error_handling/src/core/result/failure_type.dart';
import 'package:flutter_error_handling/src/core/result/result.dart';

import 'package:flutter_error_handling/src/features/http/status_codes.dart';

import 'package:flutter_error_handling/src/services/api_service/api_service.dart';
import 'package:flutter_error_handling/src/shared/utils/handle_error.dart';

import 'package:flutter_error_handling/src/shared/utils/show_loading.dart';

class HttpController {
  final _api = ApiService.http;

  int statusCode = statusCodes.first;

  Future<void> request(BuildContext context) async {
    final result = await showLoading(
      context,
      () => _api.get('$statusCode'),
    );

    await result.whenAsync(
      onFailure: (failure) async {
        switch (failure) {
          case ApiFailure():
            await _handleApiFailure(context, failure);
        }
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
