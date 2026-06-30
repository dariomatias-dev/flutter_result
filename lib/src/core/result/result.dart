import 'dart:async';

abstract class Failure {}

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

  Future<R> foldAsync<R>({
    required Future<R> Function(T value) onSuccess,
    required Future<R> Function(Failure failure) onFailure,
  }) async {
    return switch (this) {
      SuccessResult(value: final v) => await onSuccess(v),
      FailureResult(failure: final e) => await onFailure(e),
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

  Future<void> whenAsync({
    Future<void> Function(T value)? onSuccess,
    Future<void> Function(Failure failure)? onFailure,
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
  const FailureResult(this.failure);

  final Failure failure;
}

final class SuccessResult<T> extends Result<T> {
  const SuccessResult(this.value);

  final T value;
}
