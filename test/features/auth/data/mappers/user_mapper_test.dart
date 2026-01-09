import 'package:flutter_test/flutter_test.dart';
import 'package:marvel_animation_app/features/auth/data/mappers/user_mapper.dart';
import 'package:marvel_animation_app/features/auth/data/models/user_model.dart';
import 'package:marvel_animation_app/features/auth/domain/entities/user.dart';

void main() {
  group('UserMapper', () {
    group('toEntity', () {
      test('should convert UserModel to User entity with all fields', () {
        const userModel = UserModel(
          email: 'test@example.com',
          uid: 'user123',
          displayName: 'John Doe',
          password: 'password123',
          token: 'token123',
          gender: 'male',
        );

        final userEntity = UserMapper.toEntity(userModel);

        expect(userEntity.email, equals('test@example.com'));
        expect(userEntity.uid, equals('user123'));
        expect(userEntity.displayName, equals('John Doe'));
        expect(userEntity.password, equals('password123'));
        expect(userEntity.token, equals('token123'));
        expect(userEntity.gender, equals('male'));
      });

      test('should convert UserModel with only required email field', () {
        const userModel = UserModel(
          email: 'required@example.com',
        );

        final userEntity = UserMapper.toEntity(userModel);

        expect(userEntity.email, equals('required@example.com'));
        expect(userEntity.uid, isNull);
        expect(userEntity.displayName, isNull);
        expect(userEntity.password, isNull);
        expect(userEntity.token, isNull);
        expect(userEntity.gender, isNull);
      });

      test('should convert UserModel with null optional fields', () {
        const userModel = UserModel(
          email: 'nullfields@example.com',
          uid: null,
          displayName: null,
          password: null,
          token: null,
          gender: null,
        );

        final userEntity = UserMapper.toEntity(userModel);

        expect(userEntity.email, equals('nullfields@example.com'));
        expect(userEntity.uid, isNull);
        expect(userEntity.displayName, isNull);
        expect(userEntity.password, isNull);
        expect(userEntity.token, isNull);
        expect(userEntity.gender, isNull);
      });

      test('should convert UserModel with empty string values', () {
        const userModel = UserModel(
          email: 'empty@example.com',
          uid: '',
          displayName: '',
          password: '',
          token: '',
          gender: '',
        );

        final userEntity = UserMapper.toEntity(userModel);

        expect(userEntity.email, equals('empty@example.com'));
        expect(userEntity.uid, equals(''));
        expect(userEntity.displayName, equals(''));
        expect(userEntity.password, equals(''));
        expect(userEntity.token, equals(''));
        expect(userEntity.gender, equals(''));
      });

      test('should convert UserModel with partial data', () {
        const userModel = UserModel(
          email: 'partial@example.com',
          uid: 'uid123',
          displayName: 'Partial User',
        );

        final userEntity = UserMapper.toEntity(userModel);

        expect(userEntity.email, equals('partial@example.com'));
        expect(userEntity.uid, equals('uid123'));
        expect(userEntity.displayName, equals('Partial User'));
        expect(userEntity.password, isNull);
        expect(userEntity.token, isNull);
        expect(userEntity.gender, isNull);
      });

      test('should return User entity instance', () {
        const userModel = UserModel(
          email: 'instance@example.com',
        );

        final userEntity = UserMapper.toEntity(userModel);

        expect(userEntity, isA<User>());
        expect(userEntity, isNotNull);
      });

      test('should preserve email field exactly', () {
        const email = 'preserve.email+test@domain.co.uk';
        const userModel = UserModel(email: email);

        final userEntity = UserMapper.toEntity(userModel);

        expect(userEntity.email, equals(email));
      });

      test('should handle special characters in fields', () {
        const userModel = UserModel(
          email: 'special@example.com',
          displayName: 'José María O\'Connor',
          password: 'P@ssw0rd!#\$',
          gender: 'non-binary',
        );

        final userEntity = UserMapper.toEntity(userModel);

        expect(userEntity.email, equals('special@example.com'));
        expect(userEntity.displayName, equals('José María O\'Connor'));
        expect(userEntity.password, equals('P@ssw0rd!#\$'));
        expect(userEntity.gender, equals('non-binary'));
      });

      test('should handle very long string values', () {
        final longString = 'a' * 1000;
        final userModel = UserModel(
          email: 'long@example.com',
          displayName: longString,
          password: longString,
          token: longString,
        );

        final userEntity = UserMapper.toEntity(userModel);

        expect(userEntity.email, equals('long@example.com'));
        expect(userEntity.displayName, equals(longString));
        expect(userEntity.password, equals(longString));
        expect(userEntity.token, equals(longString));
      });

      test('should handle different email formats', () {
        final emails = [
          'simple@example.com',
          'user.name+tag@domain.co.uk',
          'user_123@sub.domain.org',
          'test-email@domain-name.com',
          '123@456.789',
        ];

        for (final email in emails) {
          final userModel = UserModel(email: email);
          final userEntity = UserMapper.toEntity(userModel);
          expect(userEntity.email, equals(email));
        }
      });

      test('should handle different uid formats', () {
        final uids = [
          'simple123',
          'uuid-1234-5678-9abc-def0',
          'firebase:auth:uid',
          '1234567890',
          'UID_WITH_UNDERSCORES',
        ];

        for (final uid in uids) {
          final userModel = UserModel(email: 'test@example.com', uid: uid);
          final userEntity = UserMapper.toEntity(userModel);
          expect(userEntity.uid, equals(uid));
        }
      });

      test('should handle different display names', () {
        final names = [
          'Simple Name',
          'José María',
          'O\'Connor-Smith',
          '王小明',
          'محمد الأحمد',
          'Александр',
          'François Müller',
        ];

        for (final name in names) {
          final userModel =
              UserModel(email: 'test@example.com', displayName: name);
          final userEntity = UserMapper.toEntity(userModel);
          expect(userEntity.displayName, equals(name));
        }
      });

      test('should handle different password formats', () {
        final passwords = [
          'simple123',
          'Complex@Password123',
          'VeryLongPasswordWithManyCharacters123!@#',
          '密码123',
          '1234567890',
          'P@ssW0rd!',
        ];

        for (final password in passwords) {
          final userModel =
              UserModel(email: 'test@example.com', password: password);
          final userEntity = UserMapper.toEntity(userModel);
          expect(userEntity.password, equals(password));
        }
      });

      test('should handle different token formats', () {
        final tokens = [
          'jwt.token.here',
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9',
          'simple-token-123',
          'firebase-token-abc123',
          'oauth2-access-token-xyz',
        ];

        for (final token in tokens) {
          final userModel = UserModel(email: 'test@example.com', token: token);
          final userEntity = UserMapper.toEntity(userModel);
          expect(userEntity.token, equals(token));
        }
      });

      test('should handle different gender values', () {
        final genders = [
          'male',
          'female',
          'non-binary',
          'prefer not to say',
          'other',
          'M',
          'F',
          'NB',
        ];

        for (final gender in genders) {
          final userModel =
              UserModel(email: 'test@example.com', gender: gender);
          final userEntity = UserMapper.toEntity(userModel);
          expect(userEntity.gender, equals(gender));
        }
      });

      test('should maintain field mapping consistency', () {
        const userModel = UserModel(
          email: 'mapping@example.com',
          uid: 'uid-mapping',
          displayName: 'Mapping Test',
          password: 'mapping-password',
          token: 'mapping-token',
          gender: 'mapping-gender',
        );

        final userEntity = UserMapper.toEntity(userModel);

        expect(userEntity.email, equals(userModel.email));
        expect(userEntity.uid, equals(userModel.uid));
        expect(userEntity.displayName, equals(userModel.displayName));
        expect(userEntity.password, equals(userModel.password));
        expect(userEntity.token, equals(userModel.token));
        expect(userEntity.gender, equals(userModel.gender));
      });
    });

    group('Edge cases and error handling', () {
      test('should handle UserModel with whitespace-only fields', () {
        const userModel = UserModel(
          email: 'whitespace@example.com',
          displayName: '   ',
          password: '\t\n',
          gender: '  \t  ',
        );

        final userEntity = UserMapper.toEntity(userModel);

        expect(userEntity.email, equals('whitespace@example.com'));
        expect(userEntity.displayName, equals('   '));
        expect(userEntity.password, equals('\t\n'));
        expect(userEntity.gender, equals('  \t  '));
      });

      test('should handle UserModel created from different constructors', () {
        final userModelFromJson = UserModel.fromJson({
          'email': 'json@example.com',
          'name': 'From JSON',
          'uid': 'json-uid',
          'gender': 'json-gender',
        });

        final userEntity = UserMapper.toEntity(userModelFromJson);

        expect(userEntity.email, equals('json@example.com'));
        expect(userEntity.displayName, equals('From JSON'));
        expect(userEntity.uid, equals('json-uid'));
        expect(userEntity.gender, equals('json-gender'));
      });

      test('should handle UserModel created with copyWith', () {
        const originalModel = UserModel(
          email: 'original@example.com',
          displayName: 'Original Name',
        );

        final copiedModel = originalModel.copyWith(
          displayName: 'Copied Name',
          uid: 'copied-uid',
        );

        final userEntity = UserMapper.toEntity(copiedModel);

        expect(userEntity.email, equals('original@example.com'));
        expect(userEntity.displayName, equals('Copied Name'));
        expect(userEntity.uid, equals('copied-uid'));
        expect(userEntity.password, isNull);
        expect(userEntity.token, isNull);
        expect(userEntity.gender, isNull);
      });

      test('should handle multiple consecutive mappings', () {
        const userModel = UserModel(
          email: 'consecutive@example.com',
          displayName: 'Consecutive Test',
        );

        final userEntity1 = UserMapper.toEntity(userModel);
        final userEntity2 = UserMapper.toEntity(userModel);
        final userEntity3 = UserMapper.toEntity(userModel);

        expect(userEntity1.email, equals(userEntity2.email));
        expect(userEntity2.email, equals(userEntity3.email));
        expect(userEntity1.displayName, equals(userEntity2.displayName));
        expect(userEntity2.displayName, equals(userEntity3.displayName));
      });

      test('should create independent User instances', () {
        const userModel = UserModel(
          email: 'independent@example.com',
          displayName: 'Independent Test',
        );

        final userEntity1 = UserMapper.toEntity(userModel);
        final userEntity2 = UserMapper.toEntity(userModel);

        expect(userEntity1, isNot(same(userEntity2)));
        expect(userEntity1.email, equals(userEntity2.email));
        expect(userEntity1.displayName, equals(userEntity2.displayName));
      });

      test('should handle UserModel with mixed null and non-null fields', () {
        const userModel = UserModel(
          email: 'mixed@example.com',
          uid: 'mixed-uid',
          displayName: null,
          password: 'mixed-password',
          token: null,
          gender: 'mixed-gender',
        );

        final userEntity = UserMapper.toEntity(userModel);

        expect(userEntity.email, equals('mixed@example.com'));
        expect(userEntity.uid, equals('mixed-uid'));
        expect(userEntity.displayName, isNull);
        expect(userEntity.password, equals('mixed-password'));
        expect(userEntity.token, isNull);
        expect(userEntity.gender, equals('mixed-gender'));
      });
    });

    group('Type safety and immutability', () {
      test('should return const User instance properties', () {
        const userModel = UserModel(
          email: 'const@example.com',
          uid: 'const-uid',
        );

        final userEntity = UserMapper.toEntity(userModel);

        expect(() => userEntity.email, returnsNormally);
        expect(() => userEntity.uid, returnsNormally);
        expect(() => userEntity.displayName, returnsNormally);
        expect(() => userEntity.password, returnsNormally);
        expect(() => userEntity.token, returnsNormally);
        expect(() => userEntity.gender, returnsNormally);
      });

      test('should maintain type safety for all fields', () {
        const userModel = UserModel(
          email: 'type@example.com',
          uid: 'type-uid',
          displayName: 'Type Test',
          password: 'type-password',
          token: 'type-token',
          gender: 'type-gender',
        );

        final userEntity = UserMapper.toEntity(userModel);

        expect(userEntity.email, isA<String>());
        expect(userEntity.uid, isA<String?>());
        expect(userEntity.displayName, isA<String?>());
        expect(userEntity.password, isA<String?>());
        expect(userEntity.token, isA<String?>());
        expect(userEntity.gender, isA<String?>());
      });

      test('should create new User instance each time', () {
        const userModel = UserModel(email: 'instance@example.com');

        final userEntity1 = UserMapper.toEntity(userModel);
        final userEntity2 = UserMapper.toEntity(userModel);

        expect(identical(userEntity1, userEntity2), isFalse);
        expect(userEntity1.runtimeType, equals(userEntity2.runtimeType));
      });
    });
  });
}
