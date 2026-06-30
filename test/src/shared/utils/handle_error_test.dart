import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_result/src/core/result/result.dart';
import 'package:flutter_result/src/services/api_service/api_failure.dart';
import 'package:flutter_result/src/services/api_service/failure_type.dart';
import 'package:flutter_result/src/shared/utils/handle_error.dart';
import 'package:flutter_test/flutter_test.dart';

class _OtherFailure extends Failure {}

void main() {
  testWidgets('shows the failure message for an ApiFailure', (tester) async {
    late BuildContext savedContext;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            savedContext = context;
            return const SizedBox();
          },
        ),
      ),
    );

    unawaited(
      handleError(
        savedContext,
        ApiFailure(type: FailureType.notFound, message: 'not found'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Error'), findsOneWidget);
    expect(find.text('not found'), findsOneWidget);
  });

  testWidgets('shows a generic message for other failure types',
      (tester) async {
    late BuildContext savedContext;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            savedContext = context;
            return const SizedBox();
          },
        ),
      ),
    );

    unawaited(handleError(savedContext, _OtherFailure()));
    await tester.pumpAndSettle();

    expect(find.text('Error'), findsOneWidget);
    expect(find.text('An unexpected error occurred.'), findsOneWidget);
  });

  testWidgets('does nothing when the context is no longer mounted',
      (tester) async {
    late BuildContext savedContext;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            savedContext = context;
            return const SizedBox();
          },
        ),
      ),
    );

    await tester.pumpWidget(const SizedBox());

    await handleError(
      savedContext,
      ApiFailure(type: FailureType.notFound, message: 'not found'),
    );
    await tester.pump();

    expect(find.byType(AlertDialog), findsNothing);
  });
}
