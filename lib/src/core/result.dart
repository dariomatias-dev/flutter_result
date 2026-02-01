sealed class Failure {}

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
}

final class FailureResult<T> extends Result<T> {
  final Failure failure;

  const FailureResult(this.failure);
}

final class SuccessResult<T> extends Result<T> {
  final T value;

  const SuccessResult(this.value);
}
