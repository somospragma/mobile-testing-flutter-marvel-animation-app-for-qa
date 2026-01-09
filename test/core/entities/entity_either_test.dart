import 'package:flutter_test/flutter_test.dart';
import 'package:marvel_animation_app/core/entities/entity_either.dart';

void main() {
  group('Either', () {
    group('Left', () {
      test('should create Left instance with correct value', () {
        const testValue = 'error message';

        final left = Left<String, int>(testValue);

        expect(left.value, equals(testValue));
        expect(left, isA<Either<String, int>>());
        expect(left, isA<Left<String, int>>());
      });

      test('should execute left callback when calling when()', () {
        const errorMessage = 'Something went wrong';
        final left = Left<String, int>(errorMessage);

        final result = left.when<String>(
          (error) => 'Error: $error',
          (value) => 'Success: $value',
        );

        expect(result, equals('Error: $errorMessage'));
      });

      test('should work with different generic types', () {
        final leftInt = Left<int, String>(404);
        final leftBool = Left<bool, double>(false);
        final leftList = Left<List<String>, Map<String, int>>(['error']);

        expect(leftInt.value, equals(404));
        expect(leftBool.value, equals(false));
        expect(leftList.value, equals(['error']));
      });

      test('should handle complex objects as values', () {
        final error = Exception('Network error');
        final left = Left<Exception, String>(error);

        expect(left.value, equals(error));
        expect(left.value.toString(), contains('Network error'));
      });
    });

    group('Right', () {
      test('should create Right instance with correct value', () {
        const testValue = 42;

        final right = Right<String, int>(testValue);

        expect(right.value, equals(testValue));
        expect(right, isA<Either<String, int>>());
        expect(right, isA<Right<String, int>>());
      });

      test('should execute right callback when calling when()', () {
        const successValue = 100;
        final right = Right<String, int>(successValue);

        final result = right.when<String>(
          (error) => 'Error: $error',
          (value) => 'Success: $value',
        );

        expect(result, equals('Success: $successValue'));
      });

      test('should work with different generic types', () {
        final rightString = Right<int, String>('success');
        final rightDouble = Right<bool, double>(3.14);
        final rightMap = Right<List<String>, Map<String, int>>({'count': 5});

        expect(rightString.value, equals('success'));
        expect(rightDouble.value, equals(3.14));
        expect(rightMap.value, equals({'count': 5}));
      });

      test('should handle complex objects as values', () {
        final user = {'id': 1, 'name': 'John Doe'};
        final right = Right<String, Map<String, dynamic>>(user);

        expect(right.value, equals(user));
        expect(right.value['name'], equals('John Doe'));
      });
    });

    group('when() method', () {
      test('should return correct type from left callback', () {
        final left = Left<String, int>('error');

        final stringResult = left.when<String>(
          (error) => error.toUpperCase(),
          (value) => value.toString(),
        );

        final intResult = left.when<int>(
          (error) => error.length,
          (value) => value,
        );

        expect(stringResult, equals('ERROR'));
        expect(intResult, equals(5));
      });

      test('should return correct type from right callback', () {
        final right = Right<String, int>(42);

        final stringResult = right.when<String>(
          (error) => error,
          (value) => 'Number: $value',
        );

        final doubleResult = right.when<double>(
          (error) => 0.0,
          (value) => value.toDouble(),
        );

        expect(stringResult, equals('Number: 42'));
        expect(doubleResult, equals(42.0));
      });

      test('should handle nullable return types', () {
        final left = Left<String, int>('error');
        final right = Right<String, int>(42);

        final leftResult = left.when<String?>(
          (error) => null,
          (value) => value.toString(),
        );

        final rightResult = right.when<int?>(
          (error) => null,
          (value) => value,
        );

        expect(leftResult, isNull);
        expect(rightResult, equals(42));
      });

      test('should handle Future return types', () async {
        final left = Left<String, int>('async error');
        final right = Right<String, int>(100);

        final leftFuture = left.when<Future<String>>(
          (error) async => 'Async error: $error',
          (value) async => 'Async success: $value',
        );

        final rightFuture = right.when<Future<String>>(
          (error) async => 'Async error: $error',
          (value) async => 'Async success: $value',
        );

        expect(await leftFuture, equals('Async error: async error'));
        expect(await rightFuture, equals('Async success: 100'));
      });
    });

    group('Type safety', () {
      test('should maintain type safety with complex generics', () {
        final leftList =
            Left<List<String>, Map<String, int>>(['error1', 'error2']);
        final rightMap = Right<List<String>, Map<String, int>>({'success': 1});

        expect(leftList.value, isA<List<String>>());
        expect(rightMap.value, isA<Map<String, int>>());

        leftList.when<void>(
          (errors) {
            expect(errors.length, equals(2));
            expect(errors.first, equals('error1'));
          },
          (map) => fail('Should not execute right callback'),
        );

        rightMap.when<void>(
          (errors) => fail('Should not execute left callback'),
          (map) {
            expect(map.keys.first, equals('success'));
            expect(map.values.first, equals(1));
          },
        );
      });

      test('should work with custom classes', () {
        final error = CustomError('Custom error message');
        final success = CustomSuccess(42, 'Success');

        final left = Left<CustomError, CustomSuccess>(error);
        final right = Right<CustomError, CustomSuccess>(success);

        final leftMessage = left.when<String>(
          (err) => err.message,
          (succ) => succ.description,
        );

        final rightValue = right.when<int>(
          (err) => -1,
          (succ) => succ.value,
        );

        expect(leftMessage, equals('Custom error message'));
        expect(rightValue, equals(42));
      });
    });

    group('Edge cases', () {
      test('should handle null values correctly', () {
        final leftWithNull = Left<String?, int>(null);
        final rightWithNull = Right<String, int?>(null);

        expect(leftWithNull.value, isNull);
        expect(rightWithNull.value, isNull);

        final leftResult = leftWithNull.when<String>(
          (error) => error ?? 'null error',
          (value) => value.toString(),
        );

        final rightResult = rightWithNull.when<String>(
          (error) => error,
          (value) => value?.toString() ?? 'null value',
        );

        expect(leftResult, equals('null error'));
        expect(rightResult, equals('null value'));
      });

      test('should handle empty collections', () {
        final leftEmpty = Left<List<String>, Map<String, int>>(<String>[]);
        final rightEmpty =
            Right<List<String>, Map<String, int>>(<String, int>{});

        expect(leftEmpty.value.isEmpty, isTrue);
        expect(rightEmpty.value.isEmpty, isTrue);

        leftEmpty.when<void>(
          (errors) => expect(errors.length, equals(0)),
          (map) => fail('Should not execute right callback'),
        );

        rightEmpty.when<void>(
          (errors) => fail('Should not execute left callback'),
          (map) => expect(map.length, equals(0)),
        );
      });
    });

    group('Practical usage scenarios', () {
      test('should work in network request simulation', () {
        final successResponse = simulateNetworkRequest(true);
        final errorResponse = simulateNetworkRequest(false);

        final successMessage = successResponse.when<String>(
          (error) => 'Request failed: $error',
          (data) => 'Request succeeded: ${data['status']}',
        );

        final errorMessage = errorResponse.when<String>(
          (error) => 'Request failed: $error',
          (data) => 'Request succeeded: ${data['status']}',
        );

        expect(successMessage, equals('Request succeeded: 200'));
        expect(errorMessage, equals('Request failed: Network timeout'));
      });

      test('should work in validation scenario', () {
        final validEmail = validateEmail('user@example.com');
        final invalidEmail = validateEmail('invalid-email');

        validEmail.when<void>(
          (error) => fail('Valid email should not produce error'),
          (email) => expect(email, equals('user@example.com')),
        );

        invalidEmail.when<void>(
          (error) => expect(error, contains('Invalid email')),
          (email) => fail('Invalid email should not produce success'),
        );
      });
    });
  });
}

class CustomError {
  const CustomError(this.message);
  final String message;
}

class CustomSuccess {
  const CustomSuccess(this.value, this.description);
  final int value;
  final String description;
}

Either<String, Map<String, dynamic>> simulateNetworkRequest(
    bool shouldSucceed) {
  if (shouldSucceed) {
    return Right({'status': 200, 'data': 'Success'});
  } else {
    return Left('Network timeout');
  }
}

Either<String, String> validateEmail(String email) {
  if (email.contains('@') && email.contains('.')) {
    return Right(email);
  } else {
    return Left('Invalid email format');
  }
}
