import 'dart:async';

import 'package:flutter_result/src/core/result/failure_type.dart';

sealed class Failure {}

final class ApiFailure extends Failure {
  ApiFailure({
    required this.type,
    required this.message,
  });

  final FailureType type;

  final String message;
}

sealed class Result<T> {
  const Result();

  bool get isSuccess => this is SuccessResult<T>;

  bool get isFailure => this is FailureResult<T>;

  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    return switch (this) {
      SuccessResult(value: final v) => onSuccess(v),
      FailureResult(failure: final e) => onFailure(e),
    };
  }

  void when({
    void Function(T value)? onSuccess,
    void Function(Failure failure)? onFailure,
  }) {
    switch (this) {
      case SuccessResult(value: final v):
        onSuccess?.call(v);
      case FailureResult(failure: final e):
        onFailure?.call(e);
    }
  }

  Future whenAsync({
    Future Function(T value)? onSuccess,
    Future Function(Failure failure)? onFailure,
  }) async {
    switch (this) {
      case SuccessResult(value: final v):
        await onSuccess?.call(v);
      case FailureResult(failure: final e):
        await onFailure?.call(e);
    }
  }
}

final class FailureResult<T> extends Result<T> {
  final Failure failure;

  const FailureResult(this.failure);
}

final class SuccessResult<T> extends Result<T> {
  final T value;

  const SuccessResult(this.value);
}
