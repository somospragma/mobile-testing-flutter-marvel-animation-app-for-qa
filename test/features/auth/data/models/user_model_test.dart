import 'package:flutter_test/flutter_test.dart';
import 'package:marvel_animation_app/features/auth/data/models/user_model.dart';
import 'package:marvel_animation_app/features/auth/domain/entities/user.dart';

void main() {
  group('UserModel', () {
    test('should be a subclass of User entity', () {
      const userModel = UserModel(email: 'test@test.com');
      expect(userModel, isA<User>());
    });

    test('should convert to JSON correctly', () {
      const userModel = UserModel(
        email: 'test@example.com',
        displayName: 'John Doe',
        uid: '123',
        gender: 'M',
      );

      final json = userModel.toJson();

      final expectedJson = {
        'email': 'test@example.com',
        'name': 'John Doe',
        'uid': '123',
        'gender': 'M',
      };
      expect(json, expectedJson);
    });

    test('should create UserModel from JSON', () {
      final json = {
        'email': 'test@example.com',
        'password': '123456',
        'token': 'abc123',
        'name': 'John Doe',
        'uid': 'xyz789',
        'gender': 'F'
      };

      final userModel = UserModel.fromJson(json);

      expect(userModel.email, 'test@example.com');
      expect(userModel.password, '123456');
      expect(userModel.token, 'abc123');
      expect(userModel.displayName, 'John Doe');
      expect(userModel.uid, 'xyz789');
      expect(userModel.gender, 'F');
    });

    test('should copyWith return a new instance with updated values', () {
      const userModel = UserModel(
          email: 'test@example.com',
          password: '123456',
          token: 'abc123',
          displayName: 'John Doe',
          uid: 'xyz789',
          gender: 'F');

      final updatedUserModel = userModel.copyWith(
        email: 'new@example.com',
        token: 'newToken',
      );

      expect(updatedUserModel.email, 'new@example.com');
      expect(updatedUserModel.token, 'newToken');
      expect(updatedUserModel.password, '123456'); // Debería ser el mismo
      expect(updatedUserModel.displayName, 'John Doe'); // Debería ser el mismo
      expect(updatedUserModel.uid, 'xyz789'); // Debería ser el mismo
      expect(updatedUserModel.gender, 'F'); // Debería ser el mismo
    });
  });
}
