import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_result/src/core/result/result.dart';
import 'package:flutter_result/src/features/http/http_controller.dart';
import 'package:flutter_result/src/features/http/http_screen.dart';
import 'package:flutter_result/src/features/http/status_codes.dart';
import 'package:flutter_result/src/services/api_service/api_failure.dart';
import 'package:flutter_result/src/services/api_service/api_service.dart';
import 'package:flutter_result/src/services/api_service/failure_type.dart';
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

class _ImmediateFailureApiMethods extends ApiMethods {
  _ImmediateFailureApiMethods() : super(baseUrl: '');

  @override
  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? headers,
  }) async {
    return FailureResult<T>(
      ApiFailure(type: FailureType.notFound, message: 'not found'),
    );
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

  testWidgets('re-enables request button after request completes',
      (tester) async {
    final controller = HttpController(api: _ImmediateFailureApiMethods());

    await tester.pumpWidget(
      MaterialApp(home: HttpScreen(controller: controller)),
    );

    await tester.tap(find.text('Request'));
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(1, 1));
    await tester.pumpAndSettle();

    final button = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Request'),
    );
    expect(button.onPressed, isNotNull);
  });

  testWidgets('selecting a status code updates the dropdown value',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HttpScreen()));

    final otherStatusCode = statusCodes[1];

    await tester.tap(find.text('${statusCodes.first}'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('$otherStatusCode').last);
    await tester.pumpAndSettle();

    expect(find.text('$otherStatusCode'), findsOneWidget);
  });

  testWidgets('back arrow pops the route', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () => Navigator.push<void>(
                context,
                MaterialPageRoute(builder: (_) => const HttpScreen()),
              ),
              child: const Text('open'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byType(HttpScreen), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(HttpScreen), findsNothing);
  });

  testWidgets('didUpdateWidget swaps to the new controller', (tester) async {
    final firstController = HttpController(api: _NeverCompletingApiMethods());
    final secondController = HttpController(api: _ImmediateFailureApiMethods());

    await tester.pumpWidget(
      MaterialApp(home: HttpScreen(controller: firstController)),
    );

    await tester.pumpWidget(
      MaterialApp(home: HttpScreen(controller: secondController)),
    );

    await tester.tap(find.text('Request'));
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(1, 1));
    await tester.pumpAndSettle();

    final button = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Request'),
    );
    expect(button.onPressed, isNotNull);
  });
}
