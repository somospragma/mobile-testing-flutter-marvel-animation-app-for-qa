import 'package:flutter_test/flutter_test.dart';
import 'package:marvel_animation_app/core/network/error/failures.dart';

void main() {
  group('Failure', () {
    group('Abstract class behavior', () {
      test('should be extended by concrete implementations', () {
        final serverFailure = ServerFailure('Server error', 500);
        expect(serverFailure, isA<Failure>());
      });
    });

    group('props getter', () {
      test('should return list containing errorMessage', () {
        final failure = ServerFailure('Test error', 500);
        final props = failure.props;

        expect(props, isA<List<Object>>());
        expect(props.length, equals(1));
        expect(props.first, equals('Test error'));
      });

      test('should return list with String type', () {
        final failure = ServerFailure('Another error', 404);
        final props = failure.props;

        expect(props, isA<List<String>>());
        expect(props.first, isA<String>());
      });

      test('should handle empty error message', () {
        final failure = ServerFailure('', 400);
        final props = failure.props;

        expect(props.length, equals(1));
        expect(props.first, equals(''));
      });
    });
  });

  group('ServerFailure', () {
    group('Constructor', () {
      test('should create instance with errorMessage and statusCode', () {
        final failure = ServerFailure('Server error', 500);

        expect(failure.errorMessage, equals('Server error'));
        expect(failure.statusCode, equals(500));
      });

      test('should create instance with errorMessage and null statusCode', () {
        final failure = ServerFailure('Network error', null);

        expect(failure.errorMessage, equals('Network error'));
        expect(failure.statusCode, isNull);
      });

      test('should create const instance', () {
        const failure = ServerFailure('Const error', 503);

        expect(failure.errorMessage, equals('Const error'));
        expect(failure.statusCode, equals(503));
      });
    });

    group('Inheritance', () {
      test('should extend Failure class', () {
        final failure = ServerFailure('Test', 500);

        expect(failure, isA<Failure>());
        expect(failure, isA<ServerFailure>());
      });

      test('should have access to parent properties', () {
        final failure = ServerFailure('Parent test', 400);

        expect(failure.errorMessage, equals('Parent test'));
        expect(failure.props.first, equals('Parent test'));
      });

      test('should call super constructor correctly', () {
        final failure = ServerFailure('Super constructor test', 422);

        expect(failure.errorMessage, equals('Super constructor test'));
        expect(failure.statusCode, equals(422));
      });
    });

    group('Properties', () {
      test('should store errorMessage correctly', () {
        final failure = ServerFailure('Property test message', 200);

        expect(failure.errorMessage, equals('Property test message'));
      });

      test('should store statusCode correctly', () {
        final failure = ServerFailure('Status test', 418);

        expect(failure.statusCode, equals(418));
      });

      test('should handle null statusCode', () {
        final failure = ServerFailure('Null status test', null);

        expect(failure.statusCode, isNull);
      });
    });

    group('HTTP status codes', () {
      test('should handle 400 Bad Request', () {
        final failure = ServerFailure('Bad Request', 400);

        expect(failure.errorMessage, equals('Bad Request'));
        expect(failure.statusCode, equals(400));
      });

      test('should handle 401 Unauthorized', () {
        final failure = ServerFailure('Unauthorized access', 401);

        expect(failure.errorMessage, equals('Unauthorized access'));
        expect(failure.statusCode, equals(401));
      });

      test('should handle 403 Forbidden', () {
        final failure = ServerFailure('Forbidden resource', 403);

        expect(failure.errorMessage, equals('Forbidden resource'));
        expect(failure.statusCode, equals(403));
      });

      test('should handle 404 Not Found', () {
        final failure = ServerFailure('Resource not found', 404);

        expect(failure.errorMessage, equals('Resource not found'));
        expect(failure.statusCode, equals(404));
      });

      test('should handle 500 Internal Server Error', () {
        final failure = ServerFailure('Internal server error', 500);

        expect(failure.errorMessage, equals('Internal server error'));
        expect(failure.statusCode, equals(500));
      });

      test('should handle 502 Bad Gateway', () {
        final failure = ServerFailure('Bad gateway', 502);

        expect(failure.errorMessage, equals('Bad gateway'));
        expect(failure.statusCode, equals(502));
      });

      test('should handle 503 Service Unavailable', () {
        final failure = ServerFailure('Service unavailable', 503);

        expect(failure.errorMessage, equals('Service unavailable'));
        expect(failure.statusCode, equals(503));
      });
    });

    group('Edge cases', () {
      test('should handle empty error message', () {
        final failure = ServerFailure('', 500);

        expect(failure.errorMessage, equals(''));
        expect(failure.statusCode, equals(500));
      });

      test('should handle very long error messages', () {
        final longMessage = 'Very long error message: ' + 'x' * 1000;
        final failure = ServerFailure(longMessage, 413);

        expect(failure.errorMessage, equals(longMessage));
        expect(failure.errorMessage.length, greaterThan(1000));
      });

      test('should handle special characters in error message', () {
        final message = 'Error: éñ@#\$%^&*()[]{}';
        final failure = ServerFailure(message, 422);

        expect(failure.errorMessage, equals(message));
        expect(failure.statusCode, equals(422));
      });

      test('should handle multiline error messages', () {
        final message = 'Line 1\nLine 2\nLine 3';
        final failure = ServerFailure(message, 400);

        expect(failure.errorMessage, equals(message));
        expect(failure.errorMessage.contains('\n'), isTrue);
      });

      test('should handle zero status code', () {
        final failure = ServerFailure('Zero status', 0);

        expect(failure.errorMessage, equals('Zero status'));
        expect(failure.statusCode, equals(0));
      });

      test('should handle negative status codes', () {
        final failure = ServerFailure('Negative status', -1);

        expect(failure.errorMessage, equals('Negative status'));
        expect(failure.statusCode, equals(-1));
      });

      test('should handle very large status codes', () {
        final failure = ServerFailure('Large status', 999999);

        expect(failure.errorMessage, equals('Large status'));
        expect(failure.statusCode, equals(999999));
      });
    });

    group('Realistic scenarios', () {
      test('should represent timeout failure', () {
        final failure = ServerFailure('Request timeout after 30 seconds', 408);

        expect(failure.errorMessage, contains('timeout'));
        expect(failure.statusCode, equals(408));
      });

      test('should represent authentication failure', () {
        final failure =
            ServerFailure('Invalid authentication credentials', 401);

        expect(failure.errorMessage, contains('authentication'));
        expect(failure.statusCode, equals(401));
      });

      test('should represent network connectivity failure', () {
        final failure = ServerFailure('No internet connection available', null);

        expect(failure.errorMessage, contains('connection'));
        expect(failure.statusCode, isNull);
      });

      test('should represent rate limiting failure', () {
        final failure =
            ServerFailure('Too many requests, try again later', 429);

        expect(failure.errorMessage, contains('Too many requests'));
        expect(failure.statusCode, equals(429));
      });

      test('should represent maintenance failure', () {
        final failure = ServerFailure('Server is under maintenance', 503);

        expect(failure.errorMessage, contains('maintenance'));
        expect(failure.statusCode, equals(503));
      });

      test('should represent validation failure', () {
        final failure = ServerFailure('Invalid request data format', 422);

        expect(failure.errorMessage, contains('Invalid'));
        expect(failure.statusCode, equals(422));
      });
    });

    group('props inheritance', () {
      test('should inherit props from parent Failure class', () {
        final failure = ServerFailure('Props test', 500);
        final props = failure.props;

        expect(props, isA<List<Object>>());
        expect(props, isA<List<String>>());
        expect(props.length, equals(1));
        expect(props.first, equals('Props test'));
      });

      test('should maintain props consistency across instances', () {
        final failure1 = ServerFailure('Same message', 400);
        final failure2 = ServerFailure('Same message', 500);

        expect(failure1.props.first, equals(failure2.props.first));
        expect(failure1.props.first, equals('Same message'));
      });

      test('should reflect errorMessage changes in props', () {
        final failure1 = ServerFailure('Message 1', 500);
        final failure2 = ServerFailure('Message 2', 500);

        expect(failure1.props.first, equals('Message 1'));
        expect(failure2.props.first, equals('Message 2'));
        expect(failure1.props.first, isNot(equals(failure2.props.first)));
      });
    });

    group('Type safety', () {
      test('should maintain type safety for statusCode', () {
        final failure = ServerFailure('Type test', 200);

        expect(failure.statusCode, isA<int>());
        expect(failure.statusCode, isA<int?>());
      });

      test('should maintain type safety for errorMessage', () {
        final failure = ServerFailure('String test', 404);

        expect(failure.errorMessage, isA<String>());
      });

      test('should handle nullable statusCode type safely', () {
        final failureWithNull = ServerFailure('Null test', null);
        final failureWithInt = ServerFailure('Int test', 500);

        expect(failureWithNull.statusCode, isNull);
        expect(failureWithInt.statusCode, isNotNull);
        expect(failureWithInt.statusCode, isA<int>());
      });
    });
  });
}
