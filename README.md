<br>
<div align="center">
<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
<img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
</div>
<br>

<p align="center">
<strong>Language:</strong> English | <a href="README.pt.md">Português</a>
</p>

<h1 align="center">Result Management in Flutter</h1>

<p align="center">
A simple and extensible architecture for handling results in Flutter applications, based on the <strong>Result</strong> concept (success or failure).
<br>
<a href="#about-the-project"><strong>Explore the documentation »</strong></a>
</p>

## Table of Contents

- [About the Project](#about-the-project)
- [The Problem](#the-problem)
- [Objectives](#objectives)
- [Core Concepts](#core-concepts)
- [Result Handling](#result-handling)
- [Error Handling Strategy](#error-handling-strategy)
- [License](#license)
- [Author](#author)

</br>

## About the Project

This project demonstrates a clear and predictable approach to result management in Flutter applications, using an abstraction based on `Result`, adapted to Flutter’s ecosystem and the extensive use of asynchronous operations and UI feedback.

The focus of the architecture is not only to reduce code, but to make success and failure flows explicit, predictable, easy to understand, and simple to maintain, even in medium- and large-scale applications.

</br>

## The Problem

In any application, it is common to deal with operations that may fail.  
Without a standardized approach, code often becomes repetitive, difficult to understand and maintain, and inconsistent in error handling.

Common issues include:

- Excessive use of `try/catch`
- Inconsistent error handling
- Unpredictable execution flows
- Constant null checks
- Difficulty maintaining and scaling larger applications

The lack of standardization makes code harder to read and increases the risk of unhandled errors or unexpected behavior.

</br>

## Objectives

The architecture aims to solve these problems by:

- Standardizing asynchronous operation results
- Avoiding excessive use of `try/catch`
- Making error flows predictable and controllable
- Facilitating local handling of specific errors
- Improving readability and maintainability

This approach does not replace internal exceptions but provides a clear semantic layer for managing results in the application.

</br>

## Core Concepts

### Result

`Result<T>` represents the outcome of an operation and can assume two states:

- `SuccessResult<T>`: operation completed successfully
- `FailureResult<T>`: operation failed

This separation removes the need to check for null values or catch exceptions at the point of use.

### Failure

`Failure` represents **known, expected, and treatable** failures in the application.

It forms the foundation of the domain error model and **must not be instantiated directly**.

Any error the application recognizes and knows how to handle should be modeled as a subtype of `Failure`.

### Sealed Class

`Failure` is defined as a **`sealed class`**, ensuring all possible failures are explicitly controlled by the application domain.

```dart
sealed class Failure {}
```

This approach provides:

- Exhaustiveness guarantees in failure handling
- Greater predictability of error flows
- Clear and explicit identification of failure reasons

### Concrete Implementations of Failure

Each failure must be represented by a concrete class extending `Failure`.

These classes can include:

- Error type (`FailureType`)
- User-friendly message
- Additional data for logs or metrics

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

#### When to Create a New Failure

A new `Failure` implementation should be created when:

- The error is known and expected
- There is a clear action associated with the error
- The error is part of the application domain rules

Common examples:

- API Failure (`ApiFailure`)
- Validation Failure (`ValidationFailure`)
- Cache Failure (`CacheFailure`)
- Authentication Failure (`AuthFailure`)
- Parsing Failure (`ParsingFailure`)

Purpose of the model:

- Centralize and standardize failure handling
- Prioritize clarity and predictability

</br>

## Result Handling

The API provides different methods depending on the need:

1. Returning a value from the result
2. Executing side effects

The central distinction is:

- `fold` and `foldAsync` return a value
- `when` and `whenAsync` do not return a value

Synchronous and asynchronous versions differ only in whether the callback requires `await`.

</br>

### Methods Returning Values

#### fold (Synchronous)

Executes synchronous callbacks and returns a value.

```dart
final value = result.fold(
  onSuccess: (data) => data,
  onFailure: (failure) => null,
);
```

#### foldAsync (Asynchronous)

Executes asynchronous callbacks and returns a `Future<T>`.

```dart
final value = await result.foldAsync(
  onSuccess: (data) async => data,
  onFailure: (failure) async => null,
);
```

</br>

### Methods for Side Effects

Used when the goal is to perform actions without producing a value.

Examples:

- State updates
- Showing messages
- Navigation
- Additional commands

#### when (Synchronous)

Executes synchronous callbacks without returning a value.

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

#### whenAsync (Asynchronous)

Executes asynchronous callbacks and returns `Future<void>`.

```dart
await result.whenAsync(
  onFailure: (failure) async {
    // Dialog, navigation, or other side effects
  },
);
```

</br>

## Error Handling Strategy

The architecture supports two levels of failure handling: local and global.

### Local Handling

Local handling should be used when the current context has a specific response to a failure.
It allows corrective action to be taken directly where the error occurs.

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

Local handling enables:

- Screen state updates
- Custom messages or dialogs
- Redirection or retry of operations

### Global Handling

Global handling acts as a **fallback** for failures not handled locally or unknown.
It ensures any unhandled error receives a consistent response, maintaining predictability and standardization in the UI.

The global handler logic:

- Receives failures not handled locally
- Identifies the type of failure
- Converts the failure into a user-friendly message
- Shows standard visual feedback (dialog, alert, snackbar)
- Avoids business logic decisions; domain remains isolated

Example:

```dart
Future<void> handleError(BuildContext context, Failure failure) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(failure.message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ok'),
          ),
        ],
      );
    },
  );
}
```

Usage in a result flow:

```dart
await result.whenAsync(
  onFailure: (failure) async {
    switch (failure) {
      case ApiFailure():
        // Local handling
        break;
      default:
        await handleError(context, failure);
    }
  },
);
```

This flow ensures:

- Failures are checked in the local context first
- Specific rules are applied when defined
- Unhandled failures are delegated to the global handler
- The global handler provides consistent feedback without duplicating logic

</br>

## License

Distributed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

</br>

## Author

Developed by **Dário Matias**:

- Portfolio: [https://dariomatias-dev.com](https://dariomatias-dev.com)
- GitHub: [https://github.com/dariomatias-dev](https://github.com/dariomatias-dev)
- Email: [matiasdario75@gmail.com](mailto:matiasdario75@gmail.com)
- Instagram: [https://instagram.com/dariomatias_dev](https://instagram.com/dariomatias_dev)
- LinkedIn: [https://linkedin.com/in/dariomatias-dev](https://linkedin.com/in/dariomatias-dev)
