import 'package:flutter/material.dart';

import 'package:flutter_error_handling/src/core/result/result.dart';

Future<void> handleError<T>(
  BuildContext context,
  Failure failure,
) async {
  if (!context.mounted) return;

  switch (failure) {
    case ApiFailure():
      await showDialog(
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
      break;
  }
}
