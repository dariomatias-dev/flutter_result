import 'package:flutter/material.dart';
import 'package:flutter_result/src/core/result/result.dart';
import 'package:flutter_result/src/features/http/http_controller.dart';
import 'package:flutter_result/src/services/api_service/api_failure.dart';
import 'package:flutter_result/src/services/api_service/api_service.dart';
import 'package:flutter_result/src/services/api_service/failure_type.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeApiMethods extends ApiMethods {
  _FakeApiMethods({this.successJson, this.failure})
      : assert(
          successJson != null || failure != null,
          '_FakeApiMethods requires successJson or failure',
        ),
        super(baseUrl: '');

  final Map<String, dynamic>? successJson;
  final ApiFailure? failure;

  @override
  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? headers,
  }) async {
    if (failure != null) {
      return FailureResult<T>(failure!);
    }
    return SuccessResult<T>(successJson! as T);
  }
}

Future<void> _pumpRequestButton(
  WidgetTester tester,
  HttpController controller,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () => controller.request(context, 200),
            child: const Text('go'),
          );
        },
      ),
    ),
  );

  await tester.tap(find.text('go'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows success dialog with status code and message',
      (tester) async {
    final controller = HttpController(
      api: _FakeApiMethods(
        successJson: {'status': 200, 'message': 'OK'},
      ),
    );

    await _pumpRequestButton(tester, controller);

    expect(find.text('Success'), findsOneWidget);
    expect(find.text('Status: 200\nResult: OK'), findsOneWidget);
  });

  testWidgets('shows local dialog for bad gateway failure', (tester) async {
    final controller = HttpController(
      api: _FakeApiMethods(
        failure: ApiFailure(
          type: FailureType.badGateway,
          message: 'bad gateway',
        ),
      ),
    );

    await _pumpRequestButton(tester, controller);

    expect(find.text('Local Treatment'), findsOneWidget);
    expect(find.text('Local error handling'), findsOneWidget);
  });

  testWidgets('shows generic error dialog for other failures', (tester) async {
    final controller = HttpController(
      api: _FakeApiMethods(
        failure: ApiFailure(
          type: FailureType.notFound,
          message: 'not found',
        ),
      ),
    );

    await _pumpRequestButton(tester, controller);

    expect(find.text('Error'), findsOneWidget);
    expect(find.text('not found'), findsOneWidget);
  });
}
