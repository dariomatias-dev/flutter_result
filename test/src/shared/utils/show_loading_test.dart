import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_result/src/shared/utils/show_loading.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'shows an overlay while the request is pending and removes it '
      'after completion', (tester) async {
    final completer = Completer<int>();
    late Future<int> future;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                future = showLoading(context, () => completer.future);
              },
              child: const Text('go'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('go'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(42);
    final result = await future;
    await tester.pump();

    expect(result, 42);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('removes the overlay even when the request throws',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () async {
                try {
                  await showLoading<void>(
                    context,
                    () => Future<void>.error('boom'),
                  );
                } catch (_) {
                  // expected
                }
              },
              child: const Text('go'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
