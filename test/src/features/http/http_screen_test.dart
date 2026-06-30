import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_result/src/core/result/result.dart';
import 'package:flutter_result/src/features/http/http_controller.dart';
import 'package:flutter_result/src/features/http/http_screen.dart';
import 'package:flutter_result/src/features/http/status_codes.dart';
import 'package:flutter_result/src/services/api_service/api_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _NeverCompletingApiMethods extends ApiMethods {
  _NeverCompletingApiMethods() : super(baseUrl: '');

  @override
  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? headers,
  }) {
    return Completer<Result<T>>().future;
  }
}

void main() {
  testWidgets('shows first status code by default', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HttpScreen()));

    expect(find.text('${statusCodes.first}'), findsOneWidget);
  });

  testWidgets('disables request button while loading', (tester) async {
    final controller = HttpController(api: _NeverCompletingApiMethods());

    await tester.pumpWidget(
      MaterialApp(home: HttpScreen(controller: controller)),
    );

    await tester.tap(find.text('Request'));
    await tester.pump();

    final button = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Request'),
    );
    expect(button.onPressed, isNull);
  });
}
