// ignore_for_file: avoid_dynamic_calls

import 'package:dio/dio.dart';

import 'exceptions.dart';

/// A custom error interceptor for Dio that processes server errors
/// and transforms them into a `ServerException` before passing them on.
///
/// This interceptor ensures that any errors with a server response are
/// wrapped in a custom exception for more structured error handling.
class ErrorInterceptor extends Interceptor {
  /// Overrides the `onError` method to intercept Dio errors and customize the behavior.
  ///
  /// - If the error contains a server response (`err.response` is not null),
  ///   it extracts the `statusCode` and `message` from the response and
  ///   wraps them in a `ServerException`.
  ///   Then it rejects the error with a new `DioException` containing the custom exception.
  ///
  /// - If there is no server response (`err.response` is null), the original error is passed through unchanged.
  ///
  /// [err] The Dio exception to be processed.
  /// [handler] The `ErrorInterceptorHandler` to control the error flow.
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      // Extract the HTTP status code from the response.
      final int? statusCode = err.response?.statusCode;

      // Extract the error message from the response body.
      final String message = err.response?.data['message'] as String;

      // Create a custom `ServerException` with the extracted details.
      final ServerException serverException =
          ServerException(message, statusCode);

      // Reject the error with a new `DioException` containing the custom exception.
      handler.reject(DioException(
        requestOptions: err.requestOptions,
        error: serverException,
      ));
    } else {
      // Pass the original error through if no server response exists.
      handler.reject(err);
    }
  }
}
