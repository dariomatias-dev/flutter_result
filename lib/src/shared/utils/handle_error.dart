import 'package:flutter/material.dart';

import 'package:flutter_result/src/core/result/result.dart';

import 'package:flutter_result/src/services/api_service/api_failure.dart';

Future<void> handleError(
  BuildContext context,
  Failure failure,
) async {
  if (!context.mounted) return;

  switch (failure) {
    case ApiFailure():
      await showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Error',
              textAlign: TextAlign.center,
            ),
            content: Text(
              failure.message,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      );
    case _:
      await showDialog<void>(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text(
              'Error',
              textAlign: TextAlign.center,
            ),
            content: Text(
              'An unexpected error occurred.',
              textAlign: TextAlign.center,
            ),
          );
        },
      );
  }
}
