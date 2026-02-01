import 'dart:async';

import 'package:flutter/material.dart';

Future<T> showLoading<T>(
  BuildContext context,
  Future<T> Function() request,
) async {
  final overlayEntry = OverlayEntry(
    builder: (context) {
      return Container(
        color: Colors.black.withAlpha(204),
        constraints: const BoxConstraints.expand(),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    },
  );

  Overlay.of(context).insert(overlayEntry);

  final result = await request();

  overlayEntry.remove();

  return result;
}
