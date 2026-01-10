import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marvel_animation_app/features/maps/domain/entities/marker.dart';

void main() {
  group('MarkerEntity', () {
    testWidgets('should create instance with correct properties',
        (tester) async {
      const id = 123;
      const position = LatLng(4.6097, -74.0817);

      final marker = MarkerEntity(id: id, position: position);

      expect(marker.id, equals(id));
      expect(marker.position, equals(position));
    });

    test('should create marker with positive coordinates', () {
      final marker = MarkerEntity(
        id: 1,
        position: const LatLng(10.5, 20.3),
      );

      expect(marker.id, equals(1));
      expect(marker.position.latitude, equals(10.5));
      expect(marker.position.longitude, equals(20.3));
    });

    test('should create marker with negative coordinates', () {
      final marker = MarkerEntity(
        id: 2,
        position: const LatLng(-10.5, -20.3),
      );

      expect(marker.id, equals(2));
      expect(marker.position.latitude, equals(-10.5));
      expect(marker.position.longitude, equals(-20.3));
    });

    test('should create marker with zero coordinates', () {
      final marker = MarkerEntity(
        id: 0,
        position: const LatLng(0.0, 0.0),
      );

      expect(marker.id, equals(0));
      expect(marker.position.latitude, equals(0.0));
      expect(marker.position.longitude, equals(0.0));
    });

    test('should create marker with large id value', () {
      const largeId = 999999999;
      final marker = MarkerEntity(
        id: largeId,
        position: const LatLng(1.0, 1.0),
      );

      expect(marker.id, equals(largeId));
    });

    test('should create marker with extreme coordinate values', () {
      final marker = MarkerEntity(
        id: 1,
        position: const LatLng(90.0, 179.0),
      );

      expect(marker.position.latitude, equals(90.0));
      expect(marker.position.longitude, equals(179.0));
    });

    group('equality', () {
      test('should be equal when id and position are the same', () {
        final marker1 = MarkerEntity(
          id: 1,
          position: const LatLng(4.6097, -74.0817),
        );

        final marker2 = MarkerEntity(
          id: 1,
          position: const LatLng(4.6097, -74.0817),
        );

        expect(marker1, equals(marker2));
        expect(marker1 == marker2, isTrue);
      });

      test('should not be equal when id is different', () {
        final marker1 = MarkerEntity(
          id: 1,
          position: const LatLng(4.6097, -74.0817),
        );

        final marker2 = MarkerEntity(
          id: 2,
          position: const LatLng(4.6097, -74.0817),
        );

        expect(marker1, isNot(equals(marker2)));
        expect(marker1 == marker2, isFalse);
      });

      test('should not be equal when position is different', () {
        final marker1 = MarkerEntity(
          id: 1,
          position: const LatLng(4.6097, -74.0817),
        );

        final marker2 = MarkerEntity(
          id: 1,
          position: const LatLng(5.0, -75.0),
        );

        expect(marker1, isNot(equals(marker2)));
        expect(marker1 == marker2, isFalse);
      });

      test('should not be equal when both id and position are different', () {
        final marker1 = MarkerEntity(
          id: 1,
          position: const LatLng(4.6097, -74.0817),
        );

        final marker2 = MarkerEntity(
          id: 2,
          position: const LatLng(5.0, -75.0),
        );

        expect(marker1, isNot(equals(marker2)));
      });

      test('should be equal to itself', () {
        final marker = MarkerEntity(
          id: 1,
          position: const LatLng(4.6097, -74.0817),
        );

        expect(marker, equals(marker));
        expect(identical(marker, marker), isTrue);
      });

      test('should not be equal to null', () {
        final marker = MarkerEntity(
          id: 1,
          position: const LatLng(4.6097, -74.0817),
        );

        expect(marker == null, isFalse);
      });

      test('should not be equal to different type', () {
        final marker = MarkerEntity(
          id: 1,
          position: const LatLng(4.6097, -74.0817),
        );

        expect(marker == 'string', isFalse);
        expect(marker == 123, isFalse);
      });

      test('should handle very small coordinate differences', () {
        final marker1 = MarkerEntity(
          id: 1,
          position: const LatLng(4.6097, -74.0817),
        );

        final marker2 = MarkerEntity(
          id: 1,
          position: const LatLng(4.6098, -74.0817),
        );

        expect(marker1, isNot(equals(marker2)));
      });
    });

    group('hashCode', () {
      test('should have same hashCode for equal objects', () {
        final marker1 = MarkerEntity(
          id: 1,
          position: const LatLng(4.6097, -74.0817),
        );

        final marker2 = MarkerEntity(
          id: 1,
          position: const LatLng(4.6097, -74.0817),
        );

        expect(marker1.hashCode, equals(marker2.hashCode));
      });

      test('should have different hashCode for different objects', () {
        final marker1 = MarkerEntity(
          id: 1,
          position: const LatLng(4.6097, -74.0817),
        );

        final marker2 = MarkerEntity(
          id: 2,
          position: const LatLng(4.6097, -74.0817),
        );

        expect(marker1.hashCode, isNot(equals(marker2.hashCode)));
      });

      test('should have consistent hashCode across multiple calls', () {
        final marker = MarkerEntity(
          id: 1,
          position: const LatLng(4.6097, -74.0817),
        );

        final hash1 = marker.hashCode;
        final hash2 = marker.hashCode;

        expect(hash1, equals(hash2));
      });

      test('should generate different hashCode for different positions', () {
        final marker1 = MarkerEntity(
          id: 1,
          position: const LatLng(4.6097, -74.0817),
        );

        final marker2 = MarkerEntity(
          id: 1,
          position: const LatLng(5.0, -75.0),
        );

        expect(marker1.hashCode, isNot(equals(marker2.hashCode)));
      });
    });

    group('edge cases', () {
      test('should handle negative id', () {
        final marker = MarkerEntity(
          id: -1,
          position: const LatLng(0.0, 0.0),
        );

        expect(marker.id, equals(-1));
      });

      test('should work with Set collections', () {
        final marker1 = MarkerEntity(
          id: 1,
          position: const LatLng(4.6097, -74.0817),
        );

        final marker2 = MarkerEntity(
          id: 1,
          position: const LatLng(4.6097, -74.0817),
        );

        final marker3 = MarkerEntity(
          id: 2,
          position: const LatLng(4.6097, -74.0817),
        );

        final markerSet = {marker1, marker2, marker3};

        expect(markerSet.length, equals(2));
        expect(markerSet.contains(marker1), isTrue);
        expect(markerSet.contains(marker2), isTrue);
        expect(markerSet.contains(marker3), isTrue);
      });

      test('should work with Map keys', () {
        final marker1 = MarkerEntity(
          id: 1,
          position: const LatLng(4.6097, -74.0817),
        );

        final marker2 = MarkerEntity(
          id: 1,
          position: const LatLng(4.6097, -74.0817),
        );

        final markerMap = <MarkerEntity, String>{
          marker1: 'First marker',
        };

        markerMap[marker2] = 'Second marker';

        expect(markerMap.length, equals(1));
        expect(markerMap[marker1], equals('Second marker'));
        expect(markerMap[marker2], equals('Second marker'));
      });

      test('should handle extreme latitude and longitude values', () {
        final marker = MarkerEntity(
          id: 1,
          position: const LatLng(-90.0, -180.0),
        );

        expect(marker.position.latitude, equals(-90.0));
        expect(marker.position.longitude, equals(-180.0));
      });

      test('should create multiple markers with different properties', () {
        final markers = [
          MarkerEntity(id: 1, position: const LatLng(0.0, 0.0)),
          MarkerEntity(id: 2, position: const LatLng(10.0, 20.0)),
          MarkerEntity(id: 3, position: const LatLng(-10.0, -20.0)),
        ];

        expect(markers.length, equals(3));
        expect(markers[0].id, equals(1));
        expect(markers[1].id, equals(2));
        expect(markers[2].id, equals(3));
      });
    });
  });
}
