import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marvel_animation_app/core/entities/entity_either.dart';
import 'package:marvel_animation_app/core/network/error/failures.dart';
import 'package:marvel_animation_app/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:marvel_animation_app/features/auth/data/models/user_model.dart';
import 'package:marvel_animation_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:marvel_animation_app/features/auth/domain/entities/user.dart';

class MockFirebaseAuthDataSource extends Mock
    implements FirebaseAuthDataSource {}

class FakeUserModel extends Fake implements UserModel {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeUserModel());
  });

  group('AuthRepositoryImpl', () {
    late AuthRepositoryImpl repository;
    late MockFirebaseAuthDataSource mockDataSource;

    setUp(() {
      mockDataSource = MockFirebaseAuthDataSource();
      repository = AuthRepositoryImpl(dataSource: mockDataSource);
    });

    group('constructor', () {
      test('should create AuthRepositoryImpl with required datasource', () {
        final authRepository = AuthRepositoryImpl(dataSource: mockDataSource);

        expect(authRepository, isA<AuthRepositoryImpl>());
        expect(authRepository.dataSource, equals(mockDataSource));
      });
    });

    group('logIn', () {
      const testUser = User(
        email: 'test@example.com',
        password: 'password123',
      );

      const testUserModel = UserModel(
        email: 'test@example.com',
        uid: 'test-uid-123',
        displayName: 'Test User',
        gender: 'male',
      );

      test('should return Right with User entity when datasource succeeds',
          () async {
        when(() =>
                mockDataSource.logIn(testUser.email, testUser.password ?? ''))
            .thenAnswer((_) async => Right<Failure, UserModel>(testUserModel));

        final result = await repository.logIn(testUser);

        expect(result, isA<Right<Failure, User>>());
        result.when(
          (failure) =>
              fail('Expected Right but got Left: ${failure.errorMessage}'),
          (user) {
            expect(user.email, equals(testUserModel.email));
            expect(user.uid, equals(testUserModel.uid));
            expect(user.displayName, equals(testUserModel.displayName));
            expect(user.gender, equals(testUserModel.gender));
          },
        );

        verify(() =>
                mockDataSource.logIn(testUser.email, testUser.password ?? ''))
            .called(1);
      });

      test('should return Left with Failure when datasource fails', () async {
        const testFailure = ServerFailure('Invalid credentials', 401);
        when(() =>
                mockDataSource.logIn(testUser.email, testUser.password ?? ''))
            .thenAnswer((_) async => Left<Failure, UserModel>(testFailure));

        final result = await repository.logIn(testUser);

        expect(result, isA<Left<Failure, User>>());
        result.when(
          (failure) {
            expect(failure, equals(testFailure));
            expect(failure.errorMessage, equals('Invalid credentials'));
            if (failure is ServerFailure) {
              expect(failure.statusCode, equals(401));
            }
          },
          (user) => fail('Expected Left but got Right: $user'),
        );

        verify(() =>
                mockDataSource.logIn(testUser.email, testUser.password ?? ''))
            .called(1);
      });

      test('should handle empty password correctly', () async {
        const userWithoutPassword = User(email: 'test@example.com');

        when(() => mockDataSource.logIn(userWithoutPassword.email, ''))
            .thenAnswer((_) async => Right<Failure, UserModel>(testUserModel));

        final result = await repository.logIn(userWithoutPassword);

        expect(result, isA<Right<Failure, User>>());
        result.when(
          (failure) =>
              fail('Expected Right but got Left: ${failure.errorMessage}'),
          (user) => expect(user.email, equals(testUserModel.email)),
        );

        verify(() => mockDataSource.logIn(userWithoutPassword.email, ''))
            .called(1);
      });

      test('should handle different failure types from datasource', () async {
        const networkFailure = ServerFailure('Network connection lost', 500);
        when(() =>
                mockDataSource.logIn(testUser.email, testUser.password ?? ''))
            .thenAnswer((_) async => Left<Failure, UserModel>(networkFailure));

        final result = await repository.logIn(testUser);

        expect(result, isA<Left<Failure, User>>());
        result.when(
          (failure) {
            expect(failure.errorMessage, equals('Network connection lost'));
            if (failure is ServerFailure) {
              expect(failure.statusCode, equals(500));
            }
          },
          (user) => fail('Expected Left but got Right: $user'),
        );
      });
    });

    group('signUp', () {
      const testUser = User(
        email: 'signup@example.com',
        password: 'newpassword123',
        displayName: 'New User',
        gender: 'female',
      );

      const testUserModel = UserModel(
        email: 'signup@example.com',
        uid: 'new-uid-456',
        displayName: 'New User',
        gender: 'female',
      );

      test('should return Right with User entity when datasource succeeds',
          () async {
        when(() => mockDataSource.signUp(any()))
            .thenAnswer((_) async => Right<Failure, UserModel>(testUserModel));

        final result = await repository.signUp(testUser);

        expect(result, isA<Right<Failure, User>>());
        result.when(
          (failure) =>
              fail('Expected Right but got Left: ${failure.errorMessage}'),
          (user) {
            expect(user.email, equals(testUserModel.email));
            expect(user.uid, equals(testUserModel.uid));
            expect(user.displayName, equals(testUserModel.displayName));
            expect(user.gender, equals(testUserModel.gender));
          },
        );

        verify(() => mockDataSource.signUp(any())).called(1);
      });

      test('should return Left with Failure when datasource fails', () async {
        const testFailure = ServerFailure('Email already exists', 409);
        when(() => mockDataSource.signUp(any()))
            .thenAnswer((_) async => Left<Failure, UserModel>(testFailure));

        final result = await repository.signUp(testUser);

        expect(result, isA<Left<Failure, User>>());
        result.when(
          (failure) {
            expect(failure, equals(testFailure));
            expect(failure.errorMessage, equals('Email already exists'));
            if (failure is ServerFailure) {
              expect(failure.statusCode, equals(409));
            }
          },
          (user) => fail('Expected Left but got Right: $user'),
        );

        verify(() => mockDataSource.signUp(any())).called(1);
      });

      test('should convert User entity to UserModel correctly for datasource',
          () async {
        const testUser = User(
          email: 'convert@example.com',
          password: 'password',
          displayName: 'Convert User',
          uid: 'convert-uid',
          gender: 'non-binary',
          token: 'test-token',
        );

        when(() => mockDataSource.signUp(any()))
            .thenAnswer((_) async => Right<Failure, UserModel>(testUserModel));

        await repository.signUp(testUser);

        final captured =
            verify(() => mockDataSource.signUp(captureAny())).captured;
        final capturedUserModel = captured.first as UserModel;

        expect(capturedUserModel.email, equals(testUser.email));
        expect(capturedUserModel.password, equals(testUser.password));
        expect(capturedUserModel.displayName, equals(testUser.displayName));
        expect(capturedUserModel.uid, equals(testUser.uid));
        expect(capturedUserModel.gender, equals(testUser.gender));
        expect(capturedUserModel.token, equals(testUser.token));
      });

      test('should handle partial user data correctly', () async {
        const minimalUser = User(email: 'minimal@example.com');

        when(() => mockDataSource.signUp(any()))
            .thenAnswer((_) async => Right<Failure, UserModel>(testUserModel));

        final result = await repository.signUp(minimalUser);

        expect(result, isA<Right<Failure, User>>());

        final captured =
            verify(() => mockDataSource.signUp(captureAny())).captured;
        final capturedUserModel = captured.first as UserModel;

        expect(capturedUserModel.email, equals(minimalUser.email));
        expect(capturedUserModel.password, isNull);
        expect(capturedUserModel.displayName, isNull);
        expect(capturedUserModel.uid, isNull);
        expect(capturedUserModel.gender, isNull);
        expect(capturedUserModel.token, isNull);
      });
    });

    group('logOut', () {
      test('should return Right with null when datasource succeeds', () async {
        when(() => mockDataSource.logOut()).thenAnswer((_) async {});

        final result = await repository.logOut();

        expect(result, isA<Right<Failure, void>>());
        result.when(
          (failure) =>
              fail('Expected Right but got Left: ${failure.errorMessage}'),
          (success) {},
        );

        verify(() => mockDataSource.logOut()).called(1);
      });

      test(
          'should return Left with ServerFailure when datasource throws exception',
          () async {
        when(() => mockDataSource.logOut())
            .thenThrow(Exception('Logout failed'));

        final result = await repository.logOut();

        expect(result, isA<Left<Failure, void>>());
        result.when(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.errorMessage, contains('Logout failed'));
            if (failure is ServerFailure) {
              expect(failure.statusCode, equals(500));
            }
          },
          (success) => fail('Expected Left but got Right'),
        );

        verify(() => mockDataSource.logOut()).called(1);
      });

      test('should handle different types of exceptions during logout',
          () async {
        when(() => mockDataSource.logOut())
            .thenThrow(ArgumentError('Invalid state'));

        final result = await repository.logOut();

        expect(result, isA<Left<Failure, void>>());
        result.when(
          (failure) {
            expect(failure.errorMessage, contains('Invalid argument'));
          },
          (success) => fail('Expected failure'),
        );
      });

      test('should handle timeout exceptions during logout', () async {
        when(() => mockDataSource.logOut()).thenThrow(TimeoutException(
            'Connection timeout', const Duration(seconds: 10)));

        final result = await repository.logOut();

        expect(result, isA<Left<Failure, void>>());
        result.when(
          (failure) {
            expect(failure.errorMessage, contains('TimeoutException'));
          },
          (success) => fail('Expected failure'),
        );
      });
    });

    group('getCurrentUser', () {
      const testUserModel = UserModel(
        email: 'current@example.com',
        uid: 'current-uid-789',
        displayName: 'Current User',
        gender: 'male',
        token: 'current-token',
      );

      test('should return Right with User entity when datasource returns user',
          () async {
        when(() => mockDataSource.getCurrentUser())
            .thenAnswer((_) async => testUserModel);

        final result = await repository.getCurrentUser();

        expect(result, isA<Right<Failure, User?>>());
        result.when(
          (failure) =>
              fail('Expected Right but got Left: ${failure.errorMessage}'),
          (user) {
            expect(user, isNotNull);
            expect(user!.email, equals(testUserModel.email));
            expect(user.uid, equals(testUserModel.uid));
            expect(user.displayName, equals(testUserModel.displayName));
            expect(user.gender, equals(testUserModel.gender));
            expect(user.token, equals(testUserModel.token));
          },
        );

        verify(() => mockDataSource.getCurrentUser()).called(1);
      });

      test('should return Right with null when datasource returns null',
          () async {
        when(() => mockDataSource.getCurrentUser())
            .thenAnswer((_) async => null);

        final result = await repository.getCurrentUser();

        expect(result, isA<Right<Failure, User?>>());
        result.when(
          (failure) =>
              fail('Expected Right but got Left: ${failure.errorMessage}'),
          (user) => expect(user, isNull),
        );

        verify(() => mockDataSource.getCurrentUser()).called(1);
      });

      test(
          'should return Left with ServerFailure when datasource throws exception',
          () async {
        when(() => mockDataSource.getCurrentUser())
            .thenThrow(Exception('Failed to get current user'));

        final result = await repository.getCurrentUser();

        expect(result, isA<Left<Failure, User?>>());
        result.when(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(
                failure.errorMessage, contains('Failed to get current user'));
            if (failure is ServerFailure) {
              expect(failure.statusCode, equals(500));
            }
          },
          (user) => fail('Expected Left but got Right: $user'),
        );

        verify(() => mockDataSource.getCurrentUser()).called(1);
      });

      test(
          'should handle different types of exceptions when getting current user',
          () async {
        when(() => mockDataSource.getCurrentUser())
            .thenThrow(FormatException('Invalid user format'));

        final result = await repository.getCurrentUser();

        expect(result, isA<Left<Failure, User?>>());
        result.when(
          (failure) {
            expect(failure.errorMessage, contains('FormatException'));
          },
          (user) => fail('Expected failure'),
        );
      });

      test('should properly map all user properties from UserModel to User',
          () async {
        const complexUserModel = UserModel(
          email: 'complex@example.com',
          uid: 'complex-uid',
          displayName: 'Complex User Name',
          password: 'should-not-be-in-result',
          token: 'auth-token-123',
          gender: 'prefer-not-to-say',
        );

        when(() => mockDataSource.getCurrentUser())
            .thenAnswer((_) async => complexUserModel);

        final result = await repository.getCurrentUser();

        result.when(
          (failure) => fail('Expected success'),
          (user) {
            expect(user!.email, equals(complexUserModel.email));
            expect(user.uid, equals(complexUserModel.uid));
            expect(user.displayName, equals(complexUserModel.displayName));
            expect(user.password, equals(complexUserModel.password));
            expect(user.token, equals(complexUserModel.token));
            expect(user.gender, equals(complexUserModel.gender));
          },
        );
      });
    });

    group('data transformation', () {
      test('should correctly transform User to UserModel in signUp', () async {
        const testUser = User(
          email: 'transform@example.com',
          password: 'transform123',
          displayName: 'Transform User',
          uid: 'transform-uid',
          gender: 'other',
          token: 'transform-token',
        );

        const resultUserModel = UserModel(
          email: 'transform@example.com',
          uid: 'result-uid',
          displayName: 'Result User',
        );

        when(() => mockDataSource.signUp(any())).thenAnswer(
            (_) async => Right<Failure, UserModel>(resultUserModel));

        await repository.signUp(testUser);

        final captured =
            verify(() => mockDataSource.signUp(captureAny())).captured;
        final sentUserModel = captured.first as UserModel;

        expect(sentUserModel.email, equals(testUser.email));
        expect(sentUserModel.password, equals(testUser.password));
        expect(sentUserModel.displayName, equals(testUser.displayName));
        expect(sentUserModel.uid, equals(testUser.uid));
        expect(sentUserModel.gender, equals(testUser.gender));
        expect(sentUserModel.token, equals(testUser.token));
      });

      test('should correctly transform UserModel to User in responses',
          () async {
        const testUserModel = UserModel(
          email: 'response@example.com',
          uid: 'response-uid',
          displayName: 'Response User',
          password: 'response-password',
          token: 'response-token',
          gender: 'response-gender',
        );

        when(() => mockDataSource.getCurrentUser())
            .thenAnswer((_) async => testUserModel);

        final result = await repository.getCurrentUser();

        result.when(
          (failure) => fail('Expected success'),
          (user) {
            expect(user!.email, equals(testUserModel.email));
            expect(user.uid, equals(testUserModel.uid));
            expect(user.displayName, equals(testUserModel.displayName));
            expect(user.password, equals(testUserModel.password));
            expect(user.token, equals(testUserModel.token));
            expect(user.gender, equals(testUserModel.gender));
          },
        );
      });
    });

    group('error propagation', () {
      test('should propagate all failure types from datasource in logIn',
          () async {
        const customFailure = ServerFailure('Custom login error', 422);
        const testUser = User(email: 'error@example.com', password: 'password');

        when(() => mockDataSource.logIn(testUser.email, testUser.password!))
            .thenAnswer((_) async => Left<Failure, UserModel>(customFailure));

        final result = await repository.logIn(testUser);

        result.when(
          (failure) {
            expect(failure, equals(customFailure));
            expect(failure.errorMessage, equals('Custom login error'));
          },
          (user) => fail('Expected failure'),
        );
      });

      test('should propagate all failure types from datasource in signUp',
          () async {
        const validationFailure = ServerFailure('Validation failed', 400);
        const testUser = User(email: 'validation@example.com');

        when(() => mockDataSource.signUp(any())).thenAnswer(
            (_) async => Left<Failure, UserModel>(validationFailure));

        final result = await repository.signUp(testUser);

        result.when(
          (failure) {
            expect(failure, equals(validationFailure));
            expect(failure.errorMessage, equals('Validation failed'));
          },
          (user) => fail('Expected failure'),
        );
      });
    });

    group('edge cases', () {
      test('should handle extremely long email addresses', () async {
        final longEmail = '${'a' * 100}@${'b' * 50}.com';
        final testUser = User(email: longEmail, password: 'password');
        const testUserModel =
            UserModel(email: 'result@example.com', uid: 'test-uid');

        when(() => mockDataSource.logIn(longEmail, 'password'))
            .thenAnswer((_) async => Right<Failure, UserModel>(testUserModel));

        final result = await repository.logIn(testUser);

        expect(result, isA<Right<Failure, User>>());
        verify(() => mockDataSource.logIn(longEmail, 'password')).called(1);
      });

      test('should handle special characters in user data', () async {
        const specialUser = User(
          email: 'test+special@example-domain.co.uk',
          displayName: 'User with émoji 🚀 and âccénts',
          gender: 'non-binary/fluid',
        );

        const resultUserModel =
            UserModel(email: 'test@example.com', uid: 'special-uid');

        when(() => mockDataSource.signUp(any())).thenAnswer(
            (_) async => Right<Failure, UserModel>(resultUserModel));

        final result = await repository.signUp(specialUser);

        expect(result, isA<Right<Failure, User>>());

        final captured =
            verify(() => mockDataSource.signUp(captureAny())).captured;
        final sentUserModel = captured.first as UserModel;
        expect(sentUserModel.email, equals(specialUser.email));
        expect(sentUserModel.displayName, equals(specialUser.displayName));
        expect(sentUserModel.gender, equals(specialUser.gender));
      });
    });
  });
}
