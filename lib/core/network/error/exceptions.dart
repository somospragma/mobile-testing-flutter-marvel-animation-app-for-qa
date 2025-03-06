class ServerException implements Exception {
  /// Constructs a `ServerException` with the given error [message] and [statusCode].
  ///
  /// - [message]: A description of the server error.
  /// - [statusCode]: The HTTP status code returned by the server, if available.
  ServerException(this.message, this.statusCode);

  /// A descriptive error message explaining the server failure.
  final String message;

  /// The HTTP status code associated with the server error, if provided.
  final int? statusCode;

  /// Compares two `ServerException` instances for equality.
  ///
  /// Returns `true` if the other object is also a `ServerException` and
  /// both the [message] and [statusCode] are equal.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    if (other is ServerException) {
      return other.message == message && other.statusCode == statusCode;
    }
    return false;
  }
    
}
