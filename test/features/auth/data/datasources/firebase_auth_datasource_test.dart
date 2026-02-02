import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marvel_animation_app/core/entities/entity_either.dart';
import 'package:marvel_animation_app/core/network/error/failures.dart';
import 'package:marvel_animation_app/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:marvel_animation_app/features/auth/data/models/user_model.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

void main() {
  group('FirebaseAuthDataSource', () {
    late FirebaseAuthDataSource dataSource;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockFirebaseFirestore mockFirestore;
    late MockUserCredential mockUserCredential;
    late MockUser mockUser;
    late MockCollectionReference mockCollectionReference;
    late MockDocumentReference mockDocumentReference;
    late MockDocumentSnapshot mockDocumentSnapshot;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockFirestore = MockFirebaseFirestore();
      mockUserCredential = MockUserCredential();
      mockUser = MockUser();
      mockCollectionReference = MockCollectionReference();
      mockDocumentReference = MockDocumentReference();
      mockDocumentSnapshot = MockDocumentSnapshot();

      dataSource = FirebaseAuthDataSource(mockFirebaseAuth, mockFirestore);
    });

    group('constructor', () {
      test('should create FirebaseAuthDataSource with required dependencies',
          () {
        final authDataSource =
            FirebaseAuthDataSource(mockFirebaseAuth, mockFirestore);

        expect(authDataSource, isA<FirebaseAuthDataSource>());
      });
    });

    group('signUp', () {
      const testUserModel = UserModel(
        email: 'test@example.com',
        password: 'password123',
        displayName: 'Test User',
        gender: 'male',
      );

      const testUid = 'test-uid-123';
      const testEmail = 'test@example.com';

      test('should return Right with UserModel when signup is successful',
          () async {
        when(() => mockUser.uid).thenReturn(testUid);
        when(() => mockUser.email).thenReturn(testEmail);
        when(() => mockUserCredential.user).thenReturn(mockUser);

        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: testUserModel.email,
              password: testUserModel.password ?? '',
            )).thenAnswer((_) async => mockUserCredential);

        when(() => mockFirestore.collection('users'))
            .thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc(testUid))
            .thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.set(any())).thenAnswer((_) async {});

        final result = await dataSource.signUp(testUserModel);

        expect(result, isA<Right<Failure, UserModel>>());
        result.when(
          (failure) =>
              fail('Expected Right but got Left: ${failure.errorMessage}'),
          (user) {
            expect(user.email, equals(testEmail));
            expect(user.uid, equals(testUid));
            expect(user.displayName, equals(testUserModel.displayName));
            expect(user.gender, equals(testUserModel.gender));
          },
        );

        verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: testUserModel.email,
              password: testUserModel.password ?? '',
            )).called(1);
        verify(() => mockCollectionReference.doc(testUid)).called(1);
        verify(() => mockDocumentReference.set(any())).called(1);
      });

      test(
          'should return Left with ServerFailure when user creation returns null',
          () async {
        when(() => mockUserCredential.user).thenReturn(null);
        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: testUserModel.email,
              password: testUserModel.password ?? '',
            )).thenAnswer((_) async => mockUserCredential);

        final result = await dataSource.signUp(testUserModel);

        expect(result, isA<Left<Failure, UserModel>>());
        result.when(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.errorMessage, equals('User creation failed'));
            if (failure is ServerFailure) {
              expect(failure.statusCode, equals(500));
            }
          },
          (user) => fail('Expected Left but got Right: $user'),
        );
      });

      test(
          'should return Left with ServerFailure when FirebaseAuthException occurs',
          () async {
        final firebaseException = FirebaseAuthException(
          code: 'email-already-in-use',
          message: 'The email address is already in use by another account',
        );

        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: testUserModel.email,
              password: testUserModel.password ?? '',
            )).thenThrow(firebaseException);

        final result = await dataSource.signUp(testUserModel);

        expect(result, isA<Left<Failure, UserModel>>());
        result.when(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.errorMessage,
                contains('email address is already in use'));
          },
          (user) => fail('Expected Left but got Right: $user'),
        );
      });

      test(
          'should return Left with ServerFailure when general exception occurs',
          () async {
        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: testUserModel.email,
              password: testUserModel.password ?? '',
            )).thenThrow(Exception('Network connection failed'));

        final result = await dataSource.signUp(testUserModel);

        expect(result, isA<Left<Failure, UserModel>>());
        result.when(
          (failure) {
            expect(failure, isA<ServerFailure>());
            if (failure is ServerFailure) {
              expect(failure.statusCode, equals(500));
            }
          },
          (user) => fail('Expected Left but got Right: $user'),
        );
      });

      test('should handle empty password gracefully', () async {
        const userWithoutPassword = UserModel(
          email: 'test@example.com',
          displayName: 'Test User',
          gender: 'female',
        );

        when(() => mockUser.uid).thenReturn(testUid);
        when(() => mockUser.email).thenReturn(testEmail);
        when(() => mockUserCredential.user).thenReturn(mockUser);

        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: userWithoutPassword.email,
              password: '',
            )).thenAnswer((_) async => mockUserCredential);

        when(() => mockFirestore.collection('users'))
            .thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc(testUid))
            .thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.set(any())).thenAnswer((_) async {});

        final result = await dataSource.signUp(userWithoutPassword);

        expect(result, isA<Right<Failure, UserModel>>());
        result.when(
          (failure) =>
              fail('Expected Right but got Left: ${failure.errorMessage}'),
          (user) {
            expect(user.email, equals(testEmail));
            expect(user.gender, equals('female'));
          },
        );
      });
    });

    group('logIn', () {
      const testEmail = 'test@example.com';
      const testPassword = 'password123';
      const testUid = 'test-uid-123';

      final testUserData = {
        'uid': testUid,
        'email': testEmail,
        'name': 'Test User',
        'gender': 'male',
      };

      test('should return Right with UserModel when login is successful',
          () async {
        when(() => mockUser.uid).thenReturn(testUid);
        when(() => mockUserCredential.user).thenReturn(mockUser);
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: testEmail,
              password: testPassword,
            )).thenAnswer((_) async => mockUserCredential);

        when(() => mockFirestore.collection('users'))
            .thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc(testUid))
            .thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.get())
            .thenAnswer((_) async => mockDocumentSnapshot);
        when(() => mockDocumentSnapshot.exists).thenReturn(true);
        when(() => mockDocumentSnapshot.data()).thenReturn(testUserData);

        final result = await dataSource.logIn(testEmail, testPassword);

        expect(result, isA<Right<Failure, UserModel>>());
        result.when(
          (failure) =>
              fail('Expected Right but got Left: ${failure.errorMessage}'),
          (user) {
            expect(user.email, equals(testEmail));
            expect(user.uid, equals(testUid));
            expect(user.displayName, equals('Test User'));
            expect(user.gender, equals('male'));
          },
        );

        verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: testEmail,
              password: testPassword,
            )).called(1);
        verify(() => mockDocumentReference.get()).called(1);
      });

      test(
          'should return Left with ServerFailure when FirebaseAuthException occurs',
          () async {
        final firebaseException = FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user found for that email',
        );

        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: testEmail,
              password: testPassword,
            )).thenThrow(firebaseException);

        final result = await dataSource.logIn(testEmail, testPassword);

        expect(result, isA<Left<Failure, UserModel>>());
        result.when(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.errorMessage, contains('No user found'));
          },
          (user) => fail('Expected Left but got Right: $user'),
        );
      });

      test(
          'should return Left with ServerFailure when user not found in Firestore',
          () async {
        when(() => mockUser.uid).thenReturn(testUid);
        when(() => mockUserCredential.user).thenReturn(mockUser);
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: testEmail,
              password: testPassword,
            )).thenAnswer((_) async => mockUserCredential);

        when(() => mockFirestore.collection('users'))
            .thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc(testUid))
            .thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.get())
            .thenAnswer((_) async => mockDocumentSnapshot);
        when(() => mockDocumentSnapshot.exists).thenReturn(false);

        final result = await dataSource.logIn(testEmail, testPassword);

        expect(result, isA<Left<Failure, UserModel>>());
        result.when(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(
                failure.errorMessage, contains('User not found in Firestore'));
          },
          (user) => fail('Expected Left but got Right: $user'),
        );
      });

      test(
          'should return Left with ServerFailure when general exception occurs',
          () async {
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: testEmail,
              password: testPassword,
            )).thenThrow(Exception('Network error'));

        final result = await dataSource.logIn(testEmail, testPassword);

        expect(result, isA<Left<Failure, UserModel>>());
        result.when(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.errorMessage, contains('Network error'));
          },
          (user) => fail('Expected Left but got Right: $user'),
        );
      });
    });

    group('logOut', () {
      test('should call Firebase Auth signOut method', () async {
        when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

        await dataSource.logOut();

        verify(() => mockFirebaseAuth.signOut()).called(1);
      });

      test('should handle signOut exceptions gracefully', () async {
        when(() => mockFirebaseAuth.signOut())
            .thenThrow(Exception('Sign out failed'));

        expect(
          () async => await dataSource.logOut(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getCurrentUser', () {
      const testUid = 'current-user-uid';
      final testUserData = {
        'uid': testUid,
        'email': 'current@example.com',
        'name': 'Current User',
        'gender': 'female',
      };

      test(
          'should return UserModel when user is authenticated and exists in Firestore',
          () async {
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.uid).thenReturn(testUid);

        when(() => mockFirestore.collection('users'))
            .thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc(testUid))
            .thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.get())
            .thenAnswer((_) async => mockDocumentSnapshot);
        when(() => mockDocumentSnapshot.exists).thenReturn(true);
        when(() => mockDocumentSnapshot.data()).thenReturn(testUserData);

        final result = await dataSource.getCurrentUser();

        expect(result, isNotNull);
        expect(result!.uid, equals(testUid));
        expect(result.email, equals('current@example.com'));
        expect(result.displayName, equals('Current User'));
        expect(result.gender, equals('female'));

        verify(() => mockDocumentReference.get()).called(1);
      });

      test('should return null when no user is authenticated', () async {
        when(() => mockFirebaseAuth.currentUser).thenReturn(null);

        final result = await dataSource.getCurrentUser();

        expect(result, isNull);

        verifyNever(() => mockFirestore.collection('users'));
      });

      test(
          'should throw exception when user exists in auth but not in Firestore',
          () async {
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.uid).thenReturn(testUid);

        when(() => mockFirestore.collection('users'))
            .thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc(testUid))
            .thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.get())
            .thenAnswer((_) async => mockDocumentSnapshot);
        when(() => mockDocumentSnapshot.exists).thenReturn(false);

        expect(
          () async => await dataSource.getCurrentUser(),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle Firestore exceptions when fetching current user',
          () async {
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.uid).thenReturn(testUid);

        when(() => mockFirestore.collection('users'))
            .thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc(testUid))
            .thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.get())
            .thenThrow(Exception('Firestore connection error'));

        expect(
          () async => await dataSource.getCurrentUser(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('_fetchUserFromFirestore', () {
      const testUid = 'fetch-test-uid';
      final testUserData = {
        'uid': testUid,
        'email': 'fetch@example.com',
        'name': 'Fetch Test User',
        'gender': 'non-binary',
      };

      test('should return UserModel when document exists', () async {
        when(() => mockFirestore.collection('users'))
            .thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc(testUid))
            .thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.get())
            .thenAnswer((_) async => mockDocumentSnapshot);
        when(() => mockDocumentSnapshot.exists).thenReturn(true);
        when(() => mockDocumentSnapshot.data()).thenReturn(testUserData);

        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.uid).thenReturn(testUid);

        final result = await dataSource.getCurrentUser();

        expect(result, isNotNull);
        expect(result!.uid, equals(testUid));
        expect(result.email, equals('fetch@example.com'));
        expect(result.displayName, equals('Fetch Test User'));
        expect(result.gender, equals('non-binary'));
      });

      test('should throw exception when document does not exist', () async {
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.uid).thenReturn(testUid);

        when(() => mockFirestore.collection('users'))
            .thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc(testUid))
            .thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.get())
            .thenAnswer((_) async => mockDocumentSnapshot);
        when(() => mockDocumentSnapshot.exists).thenReturn(false);

        expect(
          () async => await dataSource.getCurrentUser(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('edge cases and error handling', () {
      test('should handle invalid user data from Firestore gracefully',
          () async {
        const testUid = 'invalid-data-uid';
        final invalidUserData = {
          'invalid_field': 'invalid_value',
          'email': null,
        };

        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.uid).thenReturn(testUid);

        when(() => mockFirestore.collection('users'))
            .thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc(testUid))
            .thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.get())
            .thenAnswer((_) async => mockDocumentSnapshot);
        when(() => mockDocumentSnapshot.exists).thenReturn(true);
        when(() => mockDocumentSnapshot.data()).thenReturn(invalidUserData);

        final result = await dataSource.getCurrentUser();

        expect(result, isNotNull);
        expect(result!.email, equals('null'));
      });

      test('should throw TypeError when user data is null from Firestore',
          () async {
        const testUid = 'null-data-uid';

        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.uid).thenReturn(testUid);

        when(() => mockFirestore.collection('users'))
            .thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc(testUid))
            .thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.get())
            .thenAnswer((_) async => mockDocumentSnapshot);
        when(() => mockDocumentSnapshot.exists).thenReturn(true);
        when(() => mockDocumentSnapshot.data()).thenReturn(null);

        expect(
          () async => await dataSource.getCurrentUser(),
          throwsA(isA<TypeError>()),
        );
      });
    });
  });
}
