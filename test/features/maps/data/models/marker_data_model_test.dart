import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marvel_animation_app/features/maps/data/models/marker_data_model.dart';

void main() {
  group('MarkerDataModel', () {
    test('should create instance with required parameters', () {
      const id = 1;
      const position = LatLng(4.6097, -74.0817);

      final marker = MarkerDataModel(id: id, position: position);

      expect(marker.id, equals(id));
      expect(marker.position, equals(position));
      expect(marker.markerUrl, isNull);
    });

    test('should create instance with all parameters including markerUrl', () {
      const id = 2;
      const position = LatLng(10.0, 20.0);
      const markerUrl = BitmapDescriptor.defaultMarker;

      final marker = MarkerDataModel(
        id: id,
        position: position,
        markerUrl: markerUrl,
      );

      expect(marker.id, equals(id));
      expect(marker.position, equals(position));
      expect(marker.markerUrl, equals(markerUrl));
    });

    test('should create marker with positive coordinates', () {
      final marker = MarkerDataModel(
        id: 1,
        position: const LatLng(45.5, 90.25),
      );

      expect(marker.position.latitude, equals(45.5));
      expect(marker.position.longitude, equals(90.25));
    });

    test('should create marker with negative coordinates', () {
      final marker = MarkerDataModel(
        id: 1,
        position: const LatLng(-45.5, -90.25),
      );

      expect(marker.position.latitude, equals(-45.5));
      expect(marker.position.longitude, equals(-90.25));
    });

    test('should create marker with zero coordinates', () {
      final marker = MarkerDataModel(
        id: 0,
        position: const LatLng(0.0, 0.0),
      );

      expect(marker.id, equals(0));
      expect(marker.position.latitude, equals(0.0));
      expect(marker.position.longitude, equals(0.0));
    });

    test('should create marker with large id values', () {
      const largeId = 999999999;
      final marker = MarkerDataModel(
        id: largeId,
        position: const LatLng(1.0, 1.0),
      );

      expect(marker.id, equals(largeId));
    });

    test('should create marker with negative id', () {
      final marker = MarkerDataModel(
        id: -1,
        position: const LatLng(0.0, 0.0),
      );

      expect(marker.id, equals(-1));
    });

    group('copyWith', () {
      late MarkerDataModel originalMarker;

      setUp(() {
        originalMarker = MarkerDataModel(
          id: 1,
          position: const LatLng(4.6097, -74.0817),
          markerUrl: BitmapDescriptor.defaultMarker,
        );
      });

      test('should return same instance when no parameters provided', () {
        final copiedMarker = originalMarker.copyWith();

        expect(copiedMarker.id, equals(originalMarker.id));
        expect(copiedMarker.position, equals(originalMarker.position));
        expect(copiedMarker.markerUrl, equals(originalMarker.markerUrl));
      });

      test('should update only id when provided', () {
        const newId = 999;
        final copiedMarker = originalMarker.copyWith(id: newId);

        expect(copiedMarker.id, equals(newId));
        expect(copiedMarker.position, equals(originalMarker.position));
        expect(copiedMarker.markerUrl, equals(originalMarker.markerUrl));
      });

      test('should update only position when provided', () {
        const newPosition = LatLng(10.0, 20.0);
        final copiedMarker = originalMarker.copyWith(position: newPosition);

        expect(copiedMarker.id, equals(originalMarker.id));
        expect(copiedMarker.position, equals(newPosition));
        expect(copiedMarker.markerUrl, equals(originalMarker.markerUrl));
      });

      test('should update only markerUrl when provided', () {
        final newMarkerUrl =
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
        final copiedMarker = originalMarker.copyWith(markerUrl: newMarkerUrl);

        expect(copiedMarker.id, equals(originalMarker.id));
        expect(copiedMarker.position, equals(originalMarker.position));
        expect(copiedMarker.markerUrl, equals(newMarkerUrl));
      });

      test('should update all parameters when provided', () {
        const newId = 555;
        const newPosition = LatLng(50.0, 100.0);
        final newMarkerUrl =
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);

        final copiedMarker = originalMarker.copyWith(
          id: newId,
          position: newPosition,
          markerUrl: newMarkerUrl,
        );

        expect(copiedMarker.id, equals(newId));
        expect(copiedMarker.position, equals(newPosition));
        expect(copiedMarker.markerUrl, equals(newMarkerUrl));
      });

      test('should update multiple parameters selectively', () {
        const newId = 777;
        const newPosition = LatLng(-30.0, -60.0);

        final copiedMarker = originalMarker.copyWith(
          id: newId,
          position: newPosition,
        );

        expect(copiedMarker.id, equals(newId));
        expect(copiedMarker.position, equals(newPosition));
        expect(copiedMarker.markerUrl, equals(originalMarker.markerUrl));
      });

      test('should handle null markerUrl in original and copy', () {
        final markerWithoutUrl = MarkerDataModel(
          id: 1,
          position: const LatLng(0.0, 0.0),
        );

        final copiedMarker = markerWithoutUrl.copyWith(id: 2);

        expect(copiedMarker.id, equals(2));
        expect(copiedMarker.position, equals(markerWithoutUrl.position));
        expect(copiedMarker.markerUrl, isNull);
      });

      test('should update from null markerUrl to non-null', () {
        final markerWithoutUrl = MarkerDataModel(
          id: 1,
          position: const LatLng(0.0, 0.0),
        );

        const newMarkerUrl = BitmapDescriptor.defaultMarker;
        final copiedMarker = markerWithoutUrl.copyWith(markerUrl: newMarkerUrl);

        expect(copiedMarker.markerUrl, equals(newMarkerUrl));
      });

      test(
          'should maintain markerUrl when null is passed due to copyWith limitation',
          () {
        final markerWithUrl = MarkerDataModel(
          id: 1,
          position: const LatLng(0.0, 0.0),
          markerUrl: BitmapDescriptor.defaultMarker,
        );

        final copiedMarker = markerWithUrl.copyWith(markerUrl: null);

        expect(copiedMarker.markerUrl, equals(BitmapDescriptor.defaultMarker));
      });

      test('should work with zero and negative values', () {
        final copiedMarker = originalMarker.copyWith(
          id: 0,
          position: const LatLng(-90.0, -180.0),
        );

        expect(copiedMarker.id, equals(0));
        expect(copiedMarker.position.latitude, equals(-90.0));
        expect(copiedMarker.position.longitude, equals(-180.0));
      });
    });

    group('edge cases', () {
      test('should handle extreme coordinate values', () {
        final marker = MarkerDataModel(
          id: 1,
          position: const LatLng(90.0, 179.0),
        );

        expect(marker.position.latitude, equals(90.0));
        expect(marker.position.longitude, equals(179.0));
      });

      test('should handle extreme negative coordinate values', () {
        final marker = MarkerDataModel(
          id: 1,
          position: const LatLng(-90.0, -179.0),
        );

        expect(marker.position.latitude, equals(-90.0));
        expect(marker.position.longitude, equals(-179.0));
      });

      test('should work with different BitmapDescriptor types', () {
        final markers = [
          MarkerDataModel(
            id: 1,
            position: const LatLng(0.0, 0.0),
            markerUrl: BitmapDescriptor.defaultMarker,
          ),
          MarkerDataModel(
            id: 2,
            position: const LatLng(1.0, 1.0),
            markerUrl:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        ];

        expect(markers[0].markerUrl, equals(BitmapDescriptor.defaultMarker));
        expect(markers[1].markerUrl, isNotNull);
      });

      test('should create multiple markers with different properties', () {
        final markers = [
          MarkerDataModel(id: 1, position: const LatLng(0.0, 0.0)),
          MarkerDataModel(id: 2, position: const LatLng(10.0, 20.0)),
          MarkerDataModel(
            id: 3,
            position: const LatLng(-10.0, -20.0),
            markerUrl: BitmapDescriptor.defaultMarker,
          ),
        ];

        expect(markers.length, equals(3));
        expect(markers[0].markerUrl, isNull);
        expect(markers[1].markerUrl, isNull);
        expect(markers[2].markerUrl, isNotNull);
      });

      test('should handle copyWith with same values as original', () {
        final original = MarkerDataModel(
          id: 100,
          position: const LatLng(25.0, 50.0),
          markerUrl: BitmapDescriptor.defaultMarker,
        );

        final copied = original.copyWith(
          id: 100,
          position: const LatLng(25.0, 50.0),
          markerUrl: BitmapDescriptor.defaultMarker,
        );

        expect(copied.id, equals(original.id));
        expect(copied.position, equals(original.position));
        expect(copied.markerUrl, equals(original.markerUrl));
      });
    });
  });
}
