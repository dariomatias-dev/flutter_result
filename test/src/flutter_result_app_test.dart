import 'package:flutter/material.dart';
import 'package:flutter_result/src/features/home/home_screen.dart';
import 'package:flutter_result/src/flutter_result_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'boots with HomeScreen as the initial screen and no debug banner',
      (tester) async {
    await tester.pumpWidget(const FlutterResultApp());

    expect(find.byType(HomeScreen), findsOneWidget);

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.debugShowCheckedModeBanner, isFalse);
  });
}
