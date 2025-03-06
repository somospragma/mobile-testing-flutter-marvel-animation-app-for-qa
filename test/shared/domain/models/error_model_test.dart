import 'package:marvel_animation_app/shared/domain/models/error_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  group('AlertModel', () {
    test('should create an instance with default values', () {
      final alert = AlertModel();
      expect(alert.message, isNull);
      expect(alert.backgroundColor, isNull);
      expect(alert.currentAlert, isFalse);
    });

    test('should create an instance with given values', () {
      final alert = AlertModel(
        message: 'Test message',
        backgroundColor: Colors.red,
        currentAlert: true,
      );

      expect(alert.message, 'Test message');
      expect(alert.backgroundColor, Colors.red);
      expect(alert.currentAlert, isTrue);
    });

    test('copyWith should return a new instance with updated values', () {
      final alert = AlertModel(
        message: 'Original message',
        backgroundColor: Colors.blue,
        currentAlert: false,
      );

      final updatedAlert = alert.copyWith(
        message: 'Updated message',
        currentAlert: true,
      );

      expect(updatedAlert.message, 'Updated message');
      expect(updatedAlert.backgroundColor, Colors.blue);
      expect(updatedAlert.currentAlert, isTrue);
    });

    test('copyWith should retain original values if no new values are provided', () {
      final alert = AlertModel(
        message: 'Keep message',
        backgroundColor: Colors.green,
        currentAlert: true,
      );

      final sameAlert = alert.copyWith();

      expect(sameAlert.message, 'Keep message');
      expect(sameAlert.backgroundColor, Colors.green);
      expect(sameAlert.currentAlert, isTrue);
    });
  });
}
