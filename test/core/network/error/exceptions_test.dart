import 'package:flutter_test/flutter_test.dart';
import 'package:marvel_animation_app/core/network/error/exceptions.dart';

void main() {
  group('ServerException', () {
    group('Constructor', () {
      test('should create instance with message and statusCode', () {
        final exception = ServerException('Server error', 500);

        expect(exception.message, equals('Server error'));
        expect(exception.statusCode, equals(500));
      });

      test('should create instance with message and null statusCode', () {
        final exception = ServerException('Network error', null);

        expect(exception.message, equals('Network error'));
        expect(exception.statusCode, isNull);
      });

      test('should create instance with empty message', () {
        final exception = ServerException('', 400);

        expect(exception.message, equals(''));
        expect(exception.statusCode, equals(400));
      });
    });

    group('Exception implementation', () {
      test('should implement Exception interface', () {
        final exception = ServerException('Test error', 500);

        expect(exception, isA<Exception>());
      });

      test('should be throwable', () {
        expect(
          () => throw ServerException('Test error', 500),
          throwsA(isA<ServerException>()),
        );
      });
    });

    group('Equality operator', () {
      test('should return true for identical instances', () {
        final exception = ServerException('Error', 500);

        expect(exception == exception, isTrue);
      });

      test('should return true for instances with same message and statusCode',
          () {
        final exception1 = ServerException('Server error', 500);
        final exception2 = ServerException('Server error', 500);

        expect(exception1 == exception2, isTrue);
      });

      test(
          'should return true for instances with same message and null statusCode',
          () {
        final exception1 = ServerException('Network error', null);
        final exception2 = ServerException('Network error', null);

        expect(exception1 == exception2, isTrue);
      });

      test('should return false for instances with different messages', () {
        final exception1 = ServerException('Error 1', 500);
        final exception2 = ServerException('Error 2', 500);

        expect(exception1 == exception2, isFalse);
      });

      test('should return false for instances with different statusCodes', () {
        final exception1 = ServerException('Server error', 500);
        final exception2 = ServerException('Server error', 404);

        expect(exception1 == exception2, isFalse);
      });

      test(
          'should return false when one has null statusCode and other does not',
          () {
        final exception1 = ServerException('Error', 500);
        final exception2 = ServerException('Error', null);

        expect(exception1 == exception2, isFalse);
      });

      test('should return false when compared to different type', () {
        final exception = ServerException('Error', 500);
        final otherObject = 'Not an exception';

        expect(exception == otherObject, isFalse);
      });

      test('should return false when compared to null', () {
        final exception = ServerException('Error', 500);

        expect(exception == null, isFalse);
      });

      test('should return false when compared to other Exception type', () {
        final serverException = ServerException('Error', 500);
        final genericException = Exception('Error');

        expect(serverException == genericException, isFalse);
      });
    });

    group('Different HTTP status codes', () {
      test('should handle 400 Bad Request', () {
        final exception = ServerException('Bad Request', 400);

        expect(exception.message, equals('Bad Request'));
        expect(exception.statusCode, equals(400));
      });

      test('should handle 401 Unauthorized', () {
        final exception = ServerException('Unauthorized', 401);

        expect(exception.message, equals('Unauthorized'));
        expect(exception.statusCode, equals(401));
      });

      test('should handle 404 Not Found', () {
        final exception = ServerException('Not Found', 404);

        expect(exception.message, equals('Not Found'));
        expect(exception.statusCode, equals(404));
      });

      test('should handle 500 Internal Server Error', () {
        final exception = ServerException('Internal Server Error', 500);

        expect(exception.message, equals('Internal Server Error'));
        expect(exception.statusCode, equals(500));
      });

      test('should handle custom status codes', () {
        final exception = ServerException('Custom Error', 999);

        expect(exception.message, equals('Custom Error'));
        expect(exception.statusCode, equals(999));
      });
    });

    group('Edge cases', () {
      test('should handle very long error messages', () {
        final longMessage = 'A' * 1000;
        final exception = ServerException(longMessage, 500);

        expect(exception.message, equals(longMessage));
        expect(exception.message.length, equals(1000));
      });

      test('should handle special characters in message', () {
        final message = 'Error: éñáÇü@#\$%^&*(){}[]';
        final exception = ServerException(message, 422);

        expect(exception.message, equals(message));
        expect(exception.statusCode, equals(422));
      });

      test('should handle newlines in message', () {
        final message = 'Line 1\nLine 2\nLine 3';
        final exception = ServerException(message, 503);

        expect(exception.message, equals(message));
        expect(exception.statusCode, equals(503));
      });

      test('should handle zero as status code', () {
        final exception = ServerException('Connection failed', 0);

        expect(exception.message, equals('Connection failed'));
        expect(exception.statusCode, equals(0));
      });

      test('should handle negative status codes', () {
        final exception = ServerException('Invalid status', -1);

        expect(exception.message, equals('Invalid status'));
        expect(exception.statusCode, equals(-1));
      });
    });

    group('Realistic scenarios', () {
      test('should represent timeout error', () {
        final exception = ServerException('Request timeout', 408);

        expect(exception.message, contains('timeout'));
        expect(exception.statusCode, equals(408));
      });

      test('should represent authentication error', () {
        final exception = ServerException('Invalid credentials', 401);

        expect(exception.message, contains('credentials'));
        expect(exception.statusCode, equals(401));
      });

      test('should represent network connectivity error', () {
        final exception = ServerException('No internet connection', null);

        expect(exception.message, contains('connection'));
        expect(exception.statusCode, isNull);
      });

      test('should represent server maintenance error', () {
        final exception =
            ServerException('Service temporarily unavailable', 503);

        expect(exception.message, contains('unavailable'));
        expect(exception.statusCode, equals(503));
      });
    });

    group('Multiple instances comparison', () {
      test('should handle equality chains correctly', () {
        final exception1 = ServerException('Error', 500);
        final exception2 = ServerException('Error', 500);
        final exception3 = ServerException('Error', 500);

        expect(exception1 == exception2, isTrue);
        expect(exception2 == exception3, isTrue);
        expect(exception1 == exception3, isTrue);
      });

      test('should differentiate between similar but different exceptions', () {
        final exceptions = [
          ServerException('Error A', 500),
          ServerException('Error B', 500),
          ServerException('Error A', 404),
          ServerException('Error A', null),
        ];

        for (int i = 0; i < exceptions.length; i++) {
          for (int j = i + 1; j < exceptions.length; j++) {
            expect(exceptions[i] == exceptions[j], isFalse);
          }
        }
      });
    });
  });
}
