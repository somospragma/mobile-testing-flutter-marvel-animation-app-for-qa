import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marvel_animation_app/features/maps/data/mappers/marker_data_mapper.dart';
import 'package:marvel_animation_app/features/maps/data/models/marker_data_model.dart';
import 'package:marvel_animation_app/features/maps/domain/entities/marker.dart';

void main() {
  group('MarkerDataMapper', () {
    group('fromJsonToModel', () {
      test('should convert valid JSON to MarkerDataModel successfully', () {
        final json = {
          "id": 1,
          "latitude": 4.6097,
          "longitude": -74.0817,
        };

        final result = MarkerDataMapper.fromJsonToModel(json);

        expect(result, isA<MarkerDataModel>());
        expect(result.id, equals(1));
        expect(result.position.latitude, equals(4.6097));
        expect(result.position.longitude, equals(-74.0817));
        expect(result.markerUrl, isNull);
      });

      test('should handle integer coordinates by converting to double', () {
        final json = {
          "id": 2,
          "latitude": 10,
          "longitude": 20,
        };

        expect(
          () => MarkerDataMapper.fromJsonToModel(json),
          throwsA(isA<TypeError>()),
        );
      });

      test('should handle zero coordinates', () {
        final json = {
          "id": 0,
          "latitude": 0.0,
          "longitude": 0.0,
        };

        final result = MarkerDataMapper.fromJsonToModel(json);

        expect(result.id, equals(0));
        expect(result.position.latitude, equals(0.0));
        expect(result.position.longitude, equals(0.0));
      });

      test('should handle negative coordinates', () {
        final json = {
          "id": 3,
          "latitude": -45.5,
          "longitude": -90.25,
        };

        final result = MarkerDataMapper.fromJsonToModel(json);

        expect(result.id, equals(3));
        expect(result.position.latitude, equals(-45.5));
        expect(result.position.longitude, equals(-90.25));
      });

      test('should handle extreme coordinate values', () {
        final json = {
          "id": 4,
          "latitude": 90.0,
          "longitude": 179.0,
        };

        final result = MarkerDataMapper.fromJsonToModel(json);

        expect(result.id, equals(4));
        expect(result.position.latitude, equals(90.0));
        expect(result.position.longitude, equals(179.0));
      });

      test('should handle negative extreme coordinate values', () {
        final json = {
          "id": 5,
          "latitude": -90.0,
          "longitude": -179.0,
        };

        final result = MarkerDataMapper.fromJsonToModel(json);

        expect(result.id, equals(5));
        expect(result.position.latitude, equals(-90.0));
        expect(result.position.longitude, equals(-179.0));
      });

      test('should handle negative id values', () {
        final json = {
          "id": -1,
          "latitude": 0.0,
          "longitude": 0.0,
        };

        final result = MarkerDataMapper.fromJsonToModel(json);

        expect(result.id, equals(-1));
      });

      test('should handle large id values', () {
        final json = {
          "id": 999999999,
          "latitude": 1.0,
          "longitude": 1.0,
        };

        final result = MarkerDataMapper.fromJsonToModel(json);

        expect(result.id, equals(999999999));
      });

      test('should throw error when id is missing', () {
        final json = {
          "latitude": 4.6097,
          "longitude": -74.0817,
        };

        expect(
          () => MarkerDataMapper.fromJsonToModel(json),
          throwsA(isA<TypeError>()),
        );
      });

      test('should throw error when latitude is missing', () {
        final json = {
          "id": 1,
          "longitude": -74.0817,
        };

        expect(
          () => MarkerDataMapper.fromJsonToModel(json),
          throwsA(isA<TypeError>()),
        );
      });

      test('should throw error when longitude is missing', () {
        final json = {
          "id": 1,
          "latitude": 4.6097,
        };

        expect(
          () => MarkerDataMapper.fromJsonToModel(json),
          throwsA(isA<TypeError>()),
        );
      });

      test('should throw error when id is null', () {
        final json = {
          "id": null,
          "latitude": 4.6097,
          "longitude": -74.0817,
        };

        expect(
          () => MarkerDataMapper.fromJsonToModel(json),
          throwsA(isA<TypeError>()),
        );
      });

      test('should throw error when latitude is null', () {
        final json = {
          "id": 1,
          "latitude": null,
          "longitude": -74.0817,
        };

        expect(
          () => MarkerDataMapper.fromJsonToModel(json),
          throwsA(isA<TypeError>()),
        );
      });

      test('should throw error when longitude is null', () {
        final json = {
          "id": 1,
          "latitude": 4.6097,
          "longitude": null,
        };

        expect(
          () => MarkerDataMapper.fromJsonToModel(json),
          throwsA(isA<TypeError>()),
        );
      });

      test('should handle empty JSON', () {
        final json = <String, dynamic>{};

        expect(
          () => MarkerDataMapper.fromJsonToModel(json),
          throwsA(isA<TypeError>()),
        );
      });

      test('should handle JSON with additional fields', () {
        final json = {
          "id": 1,
          "latitude": 4.6097,
          "longitude": -74.0817,
          "name": "Test Marker",
          "description": "A test marker",
          "extra": "field",
        };

        final result = MarkerDataMapper.fromJsonToModel(json);

        expect(result.id, equals(1));
        expect(result.position.latitude, equals(4.6097));
        expect(result.position.longitude, equals(-74.0817));
      });

      test('should handle string numbers in JSON', () {
        final json = {
          "id": "123",
          "latitude": "45.5",
          "longitude": "-90.25",
        };

        expect(
          () => MarkerDataMapper.fromJsonToModel(json),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('fromModelToEntity', () {
      test('should convert MarkerDataModel to MarkerEntity successfully', () {
        final model = MarkerDataModel(
          id: 1,
          position: const LatLng(4.6097, -74.0817),
        );

        final result = MarkerDataMapper.fromModelToEntity(model);

        expect(result, isA<MarkerEntity>());
        expect(result.id, equals(1));
        expect(result.position.latitude, equals(4.6097));
        expect(result.position.longitude, equals(-74.0817));
      });

      test('should convert model with markerUrl to entity', () {
        final model = MarkerDataModel(
          id: 2,
          position: const LatLng(10.0, 20.0),
          markerUrl: BitmapDescriptor.defaultMarker,
        );

        final result = MarkerDataMapper.fromModelToEntity(model);

        expect(result.id, equals(2));
        expect(result.position.latitude, equals(10.0));
        expect(result.position.longitude, equals(20.0));
      });

      test('should handle zero coordinates in conversion', () {
        final model = MarkerDataModel(
          id: 0,
          position: const LatLng(0.0, 0.0),
        );

        final result = MarkerDataMapper.fromModelToEntity(model);

        expect(result.id, equals(0));
        expect(result.position.latitude, equals(0.0));
        expect(result.position.longitude, equals(0.0));
      });

      test('should handle negative coordinates in conversion', () {
        final model = MarkerDataModel(
          id: 3,
          position: const LatLng(-45.5, -90.25),
        );

        final result = MarkerDataMapper.fromModelToEntity(model);

        expect(result.id, equals(3));
        expect(result.position.latitude, equals(-45.5));
        expect(result.position.longitude, equals(-90.25));
      });

      test('should handle extreme coordinate values in conversion', () {
        final model = MarkerDataModel(
          id: 4,
          position: const LatLng(90.0, 179.0),
        );

        final result = MarkerDataMapper.fromModelToEntity(model);

        expect(result.id, equals(4));
        expect(result.position.latitude, equals(90.0));
        expect(result.position.longitude, equals(179.0));
      });

      test('should handle negative id in conversion', () {
        final model = MarkerDataModel(
          id: -1,
          position: const LatLng(1.0, 1.0),
        );

        final result = MarkerDataMapper.fromModelToEntity(model);

        expect(result.id, equals(-1));
      });

      test('should handle large id values in conversion', () {
        final model = MarkerDataModel(
          id: 999999999,
          position: const LatLng(1.0, 1.0),
        );

        final result = MarkerDataMapper.fromModelToEntity(model);

        expect(result.id, equals(999999999));
      });

      test('should preserve LatLng object reference in conversion', () {
        const position = LatLng(4.6097, -74.0817);
        final model = MarkerDataModel(
          id: 1,
          position: position,
        );

        final result = MarkerDataMapper.fromModelToEntity(model);

        expect(result.position, same(position));
      });
    });

    group('integration tests', () {
      test('should convert from JSON to model to entity successfully', () {
        final json = {
          "id": 1,
          "latitude": 4.6097,
          "longitude": -74.0817,
        };

        final model = MarkerDataMapper.fromJsonToModel(json);
        final entity = MarkerDataMapper.fromModelToEntity(model);

        expect(entity.id, equals(1));
        expect(entity.position.latitude, equals(4.6097));
        expect(entity.position.longitude, equals(-74.0817));
      });

      test('should handle multiple conversions with different data', () {
        final jsonData = [
          {"id": 1, "latitude": 4.6097, "longitude": -74.0817},
          {"id": 2, "latitude": 0.0, "longitude": 0.0},
          {"id": 3, "latitude": -90.0, "longitude": 179.0},
        ];

        final entities = jsonData
            .map((json) => MarkerDataMapper.fromJsonToModel(json))
            .map((model) => MarkerDataMapper.fromModelToEntity(model))
            .toList();

        expect(entities.length, equals(3));
        expect(entities[0].id, equals(1));
        expect(entities[1].id, equals(2));
        expect(entities[2].id, equals(3));
        expect(entities[2].position.latitude, equals(-90.0));
        expect(entities[2].position.longitude, equals(179.0));
      });

      test('should maintain data integrity through conversions', () {
        final originalData = {
          "id": 42,
          "latitude": 25.7617,
          "longitude": -80.1918,
        };

        final model = MarkerDataMapper.fromJsonToModel(originalData);
        final entity = MarkerDataMapper.fromModelToEntity(model);

        expect(model.id, equals(originalData["id"]));
        expect(model.position.latitude, equals(originalData["latitude"]));
        expect(model.position.longitude, equals(originalData["longitude"]));

        expect(entity.id, equals(model.id));
        expect(entity.position.latitude, equals(model.position.latitude));
        expect(entity.position.longitude, equals(model.position.longitude));
      });
    });
  });
}
