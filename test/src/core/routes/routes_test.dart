import 'package:flutter/material.dart';
import 'package:flutter_result/src/core/routes/routes.dart';
import 'package:flutter_result/src/core/routes/routes_names.dart';
import 'package:flutter_result/src/features/home/home_screen.dart';
import 'package:flutter_result/src/features/http/http_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('registers HomeScreen for the main route', (tester) async {
    await tester.pumpWidget(
      MaterialApp(routes: routes, initialRoute: RouteNames.main),
    );

    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('registers HttpScreen for the http route', (tester) async {
    await tester.pumpWidget(
      MaterialApp(routes: routes, initialRoute: RouteNames.http),
    );

    expect(find.byType(HttpScreen), findsOneWidget);
  });
}
