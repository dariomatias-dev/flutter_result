<br>
<div align="center">
<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
<img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
</div>
<br>

<p align="center">
<strong>Language:</strong>
English | <a href="README.pt.md">Português</a>
</p>

<h1 align="center">Result Management in Flutter</h1>

<p align="center">
A custom, simple, and extensible solution for handling results in Flutter applications, based on the <strong>Result</strong> concept (success or failure).
<br>
<a href="#about-the-project"><strong>Explore the documentation »</strong></a>
</p>

## Table of Contents

- [About the Project](#about-the-project)
- [Solution Objective](#solution-objective)
- [Core Concepts](#core-concepts)
- [Request Configuration](#request-configuration)
- [Result Handling](#result-handling)
- [Local vs Global Handling](#local-vs-global-handling)
- [License](#license)
- [Author](#author)

## About the Project

This project proposes a clear and predictable approach to result management in Flutter applications, using a custom abstraction based on `Result`, inspired by the `Either` concept, but adapted to Flutter’s ecosystem and the extensive use of asynchronous operations and UI feedback.

The focus of this solution is not to reduce code, but to make success and failure flows explicit, easy to understand, and simple to maintain, even in medium- and large-scale applications.

## Solution Objective

The main objectives of this solution are:

- Standardize the return of asynchronous operations
- Avoid excessive use of `try/catch`
- Make error flows predictable and controllable
- Facilitate local handling of specific errors
- Improve code readability and maintainability

This solution does not replace internal exceptions, but provides a clear semantic layer for consuming results within the application.

## Core Concepts

### Result

`Result<T>` represents the outcome of an operation and can assume two states:

- `SuccessResult<T>`: the operation completed successfully
- `FailureResult<T>`: the operation failed for some reason

This separation removes the need to check for null values or catch exceptions at the usage point.

### Failure

`Failure` represents **known, expected, and treatable** failures within the application.
It forms the foundation of the domain error model and **must not be instantiated directly**.

Any error that the application recognizes and knows how to handle should be modeled as a subtype of `Failure`.

#### Sealed class

`Failure` is defined as a **`sealed class`**, ensuring that **all possible failures are explicitly controlled by the application domain**.

```dart
sealed class Failure {}
```

This approach provides:

- Exhaustiveness guarantees when handling failures
- Greater predictability of error flows
- Clear and implicit documentation of the error domain

#### Creating customizable failures

Each failure must be represented by a **concrete class** extending `Failure`.
These classes may carry specific information, such as:

- Error type (`FailureType`)
- User-friendly message
- Additional data for decision-making, logging, or metrics

Example:

```dart
final class ApiFailure extends Failure {
  final FailureType type;
  final String message;

  ApiFailure({
    required this.type,
    required this.message,
  });
}
```

#### When to create a new `Failure`

A new `Failure` implementation should be created when:

- The error is known and expected
- There is a clear action associated with the error
- The error is part of the application’s domain rules

Common examples include:

- `ApiFailure`
- `ValidationFailure`
- `CacheFailure`

#### Model purpose

The use of `Failure` aims to:

- Centralize and standardize failure handling
- Prioritize readability, clarity, and predictability of the code

## Request Configuration

### URL Definition

Base URLs used by requests should be defined separately:

```dart
class Urls {
  static const httpUrl = 'https://dummyjson.com/http';
}
```

### API Service

The service responsible for HTTP requests encapsulates the base URL:

```dart
class ApiService {
  static ApiMethods get http => ApiMethods(
        baseUrl: Urls.httpUrl,
      );
}
```

### Creating an Instance

```dart
final _api = ApiService.http;
```

### Performing Requests

Simple request:

```dart
final result = await _api.get('[path]');
```

With headers:

```dart
final result = await _api.get(
  '[path]',
  headers: <String, dynamic>{},
);
```

With body:

```dart
final result = await _api.post(
  '[path]',
  headers: <String, dynamic>{},
  data: <String, dynamic>{},
);
```

## Result Handling

### fold

Used when it is necessary to **return a value** from the result:

```dart
final value = result.fold(
  onSuccess: (data) => data,
  onFailure: (failure) => null,
);
```

### when

Used for **synchronous side effects**, such as state updates:

```dart
result.when(
  onSuccess: (value) {
    // State update
  },
  onFailure: (failure) {
    // Synchronous handling
  },
);
```

### whenAsync

Used for **asynchronous side effects**, such as dialogs, navigation, or additional calls:

```dart
await result.whenAsync(
  onFailure: (failure) async {
    // Visual feedback or navigation
  },
);
```

The separation between `when` and `whenAsync` is intentional and avoids ambiguities related to `FutureOr`, making the flow explicit and predictable.

## Local vs Global Handling

The solution allows errors to be handled locally whenever necessary, keeping control at the point where the action occurs and enabling context-specific responses.

### Local Handling

Local handling should be used when the screen or flow has a specific response for a given error.

```dart
await result.whenAsync(
  onFailure: (failure) async {
    switch (failure) {
      case ApiFailure():
        // Specific local handling
        break;
    }
  },
);
```

This type of handling is recommended when:

- The corrective action is known in that context
- User feedback depends on the current screen
- The error requires a specific interaction (e.g., dialog, redirect, retry)

## Global Error Handler

When there is no specific handling in the current context, the failure should be delegated to a **global error handler**.

```dart
await handleError(context, failure);
```

The global handler is responsible for:

- Providing standardized and consistent user feedback
- Centralizing the presentation of unhandled errors
- Avoiding logic duplication across screens
- Ensuring a uniform experience throughout the application

This mechanism acts as a **fallback**, triggered only when the failure is not resolved at the local level.

### Responsibility of the global handler

The global handler **does not decide business rules**.
Its responsibility is exclusively to:

- Translate failures into understandable messages
- Display alerts, dialogs, snackbars, or error screens
- Maintain visual and behavioral consistency of feedback

This keeps the domain isolated from the presentation layer, while the UI remains clear, predictable, and consistent.

## License

Distributed under the **MIT License**. See the [LICENSE](LICENSE) file for more information.

## Author

Developed by **Dário Matias**:

- **Portfolio**: [https://dariomatias-dev.com](https://dariomatias-dev.com)
- **GitHub**: [https://github.com/dariomatias-dev](https://github.com/dariomatias-dev)
- **Email**: [matiasdario75@gmail.com](mailto:matiasdario75@gmail.com)
- **Instagram**: [https://instagram.com/dariomatias_dev](https://instagram.com/dariomatias_dev)
- **LinkedIn**: [https://linkedin.com/in/dariomatias-dev](https://linkedin.com/in/dariomatias-dev)
