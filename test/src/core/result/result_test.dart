import 'package:flutter_result/src/core/result/result.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestFailure extends Failure {
  _TestFailure(this.message);

  final String message;
}

void main() {
  group('SuccessResult', () {
    test('isSuccess is true and isFailure is false', () {
      const result = SuccessResult<int>(1);

      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
    });

    test('holds the provided value', () {
      const result = SuccessResult<int>(42);

      expect(result.value, 42);
    });
  });

  group('FailureResult', () {
    test('isFailure is true and isSuccess is false', () {
      final result = FailureResult<int>(_TestFailure('error'));

      expect(result.isFailure, isTrue);
      expect(result.isSuccess, isFalse);
    });

    test('holds the provided failure', () {
      final failure = _TestFailure('error');
      final result = FailureResult<int>(failure);

      expect(result.failure, failure);
    });
  });

  group('fold', () {
    test('calls onSuccess for SuccessResult', () {
      const result = SuccessResult<int>(10);

      final output = result.fold(
        onSuccess: (value) => 'success: $value',
        onFailure: (failure) => 'failure',
      );

      expect(output, 'success: 10');
    });

    test('calls onFailure for FailureResult', () {
      final result = FailureResult<int>(_TestFailure('oops'));

      final output = result.fold(
        onSuccess: (value) => 'success',
        onFailure: (failure) => 'failure: ${(failure as _TestFailure).message}',
      );

      expect(output, 'failure: oops');
    });
  });

  group('foldAsync', () {
    test('calls onSuccess for SuccessResult', () async {
      const result = SuccessResult<int>(10);

      final output = await result.foldAsync(
        onSuccess: (value) async => 'success: $value',
        onFailure: (failure) async => 'failure',
      );

      expect(output, 'success: 10');
    });

    test('calls onFailure for FailureResult', () async {
      final result = FailureResult<int>(_TestFailure('oops'));

      final output = await result.foldAsync(
        onSuccess: (value) async => 'success',
        onFailure: (failure) async =>
            'failure: ${(failure as _TestFailure).message}',
      );

      expect(output, 'failure: oops');
    });
  });

  group('when', () {
    test('calls onSuccess for SuccessResult', () {
      const result = SuccessResult<int>(10);
      var called = false;

      result.when(
        onSuccess: (value) => called = true,
        onFailure: (failure) => fail('onFailure should not be called'),
      );

      expect(called, isTrue);
    });

    test('calls onFailure for FailureResult', () {
      final result = FailureResult<int>(_TestFailure('oops'));
      var called = false;

      result.when(
        onSuccess: (value) => fail('onSuccess should not be called'),
        onFailure: (failure) => called = true,
      );

      expect(called, isTrue);
    });

    test('does not throw when callbacks are null', () {
      const success = SuccessResult<int>(10);
      final failureResult = FailureResult<int>(_TestFailure('oops'));

      expect(success.when, returnsNormally);
      expect(failureResult.when, returnsNormally);
    });
  });

  group('whenAsync', () {
    test('calls onSuccess for SuccessResult', () async {
      const result = SuccessResult<int>(10);
      var called = false;

      await result.whenAsync(
        onSuccess: (value) async => called = true,
        onFailure: (failure) async => fail('onFailure should not be called'),
      );

      expect(called, isTrue);
    });

    test('calls onFailure for FailureResult', () async {
      final result = FailureResult<int>(_TestFailure('oops'));
      var called = false;

      await result.whenAsync(
        onSuccess: (value) async => fail('onSuccess should not be called'),
        onFailure: (failure) async => called = true,
      );

      expect(called, isTrue);
    });

    test('does not throw when callbacks are null', () async {
      const success = SuccessResult<int>(10);
      final failureResult = FailureResult<int>(_TestFailure('oops'));

      await expectLater(success.whenAsync(), completes);
      await expectLater(failureResult.whenAsync(), completes);
    });
  });
}
