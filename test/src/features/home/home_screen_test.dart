import 'package:flutter/material.dart';
import 'package:flutter_result/src/core/routes/routes_names.dart';
import 'package:flutter_result/src/features/home/home_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('navigates to http route when HTTP button is tapped',
      (tester) async {
    final pushedRoutes = <String>[];

    await tester.pumpWidget(
      MaterialApp(
        home: const HomeScreen(),
        onGenerateRoute: (settings) {
          pushedRoutes.add(settings.name!);
          return MaterialPageRoute<void>(
            builder: (context) => const SizedBox(),
          );
        },
      ),
    );

    await tester.tap(find.text('HTTP'));
    await tester.pumpAndSettle();

    expect(pushedRoutes, contains(RouteNames.http));
  });
}
