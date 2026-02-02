import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marvel_animation_app/core/entities/entity_either.dart';
import 'package:marvel_animation_app/core/network/error/failures.dart';
import 'package:marvel_animation_app/features/maps/data/repositories/maps_repository_impl.dart';
import 'package:marvel_animation_app/features/maps/domain/entities/marker.dart';
import 'package:marvel_animation_app/features/maps/domain/usecases/maps_usecase.dart';

class MockMapsRepositoryImpl extends Mock implements MapsRepositoryImpl {}

void main() {
  group('MapsUsecase', () {
    late MapsUsecase mapsUsecase;
    late MockMapsRepositoryImpl mockMapsRepository;

    setUp(() {
      mockMapsRepository = MockMapsRepositoryImpl();
      mapsUsecase = MapsUsecase(mapsRepository: mockMapsRepository);
    });

    group('constructor', () {
      test('should create MapsUsecase with required repository', () {
        final usecase = MapsUsecase(mapsRepository: mockMapsRepository);

        expect(usecase, isA<MapsUsecase>());
        expect(usecase.mapsRepository, equals(mockMapsRepository));
      });
    });

    group('getLocation', () {
      const testLatLng = LatLng(4.60971, -74.08175);
      final testMarkerEntity = MarkerEntity(
        id: 1,
        position: testLatLng,
      );

      test('should return Right with MarkerEntity when repository succeeds',
          () async {
        when(() => mockMapsRepository.getLocation()).thenAnswer(
            (_) async => Right<Failure, MarkerEntity?>(testMarkerEntity));

        final result = await mapsUsecase.getLocation();

        expect(result, isA<Right<Failure, MarkerEntity?>>());
        result.when(
          (failure) => fail(
              'Expected Right but got Left with failure: ${failure.errorMessage}'),
          (marker) {
            expect(marker, equals(testMarkerEntity));
            expect(marker?.id, equals(1));
            expect(marker?.position, equals(testLatLng));
          },
        );

        verify(() => mockMapsRepository.getLocation()).called(1);
      });

      test('should return Right with null when repository returns null',
          () async {
        when(() => mockMapsRepository.getLocation())
            .thenAnswer((_) async => Right<Failure, MarkerEntity?>(null));

        final result = await mapsUsecase.getLocation();

        expect(result, isA<Right<Failure, MarkerEntity?>>());
        result.when(
          (failure) => fail(
              'Expected Right but got Left with failure: ${failure.errorMessage}'),
          (marker) => expect(marker, isNull),
        );

        verify(() => mockMapsRepository.getLocation()).called(1);
      });

      test('should return Left with ServerFailure when repository fails',
          () async {
        const testFailure = ServerFailure('Connection error', 500);
        when(() => mockMapsRepository.getLocation())
            .thenAnswer((_) async => Left<Failure, MarkerEntity?>(testFailure));

        final result = await mapsUsecase.getLocation();

        expect(result, isA<Left<Failure, MarkerEntity?>>());
        result.when(
          (failure) {
            expect(failure, equals(testFailure));
            expect(failure.errorMessage, equals('Connection error'));
            if (failure is ServerFailure) {
              expect(failure.statusCode, equals(500));
            }
          },
          (marker) => fail('Expected Left but got Right with marker: $marker'),
        );

        verify(() => mockMapsRepository.getLocation()).called(1);
      });

      test(
          'should return Left with generic Failure when repository fails with generic error',
          () async {
        const testFailure = ServerFailure('Generic error', null);
        when(() => mockMapsRepository.getLocation())
            .thenAnswer((_) async => Left<Failure, MarkerEntity?>(testFailure));

        final result = await mapsUsecase.getLocation();

        expect(result, isA<Left<Failure, MarkerEntity?>>());
        result.when(
          (failure) {
            expect(failure, equals(testFailure));
            expect(failure.errorMessage, equals('Generic error'));
          },
          (marker) => fail('Expected Left but got Right with marker: $marker'),
        );

        verify(() => mockMapsRepository.getLocation()).called(1);
      });

      test('should handle multiple consecutive calls correctly', () async {
        final testMarkerEntity1 =
            MarkerEntity(id: 1, position: const LatLng(1.0, 1.0));
        final testMarkerEntity2 =
            MarkerEntity(id: 2, position: const LatLng(2.0, 2.0));

        when(() => mockMapsRepository.getLocation()).thenAnswer(
            (_) async => Right<Failure, MarkerEntity?>(testMarkerEntity1));

        final result1 = await mapsUsecase.getLocation();

        when(() => mockMapsRepository.getLocation()).thenAnswer(
            (_) async => Right<Failure, MarkerEntity?>(testMarkerEntity2));

        final result2 = await mapsUsecase.getLocation();

        expect(result1, isA<Right<Failure, MarkerEntity?>>());
        expect(result2, isA<Right<Failure, MarkerEntity?>>());

        result1.when(
          (failure) => fail('First call failed'),
          (marker) => expect(marker?.id, equals(1)),
        );

        result2.when(
          (failure) => fail('Second call failed'),
          (marker) => expect(marker?.id, equals(2)),
        );

        verify(() => mockMapsRepository.getLocation()).called(2);
      });

      test('should handle repository throwing exception', () async {
        when(() => mockMapsRepository.getLocation())
            .thenThrow(Exception('Network connection failed'));

        expect(
          () async => await mapsUsecase.getLocation(),
          throwsA(isA<Exception>()),
        );

        verify(() => mockMapsRepository.getLocation()).called(1);
      });

      test('should preserve exact failure details from repository', () async {
        const specificErrorMessage = 'GPS permission denied by user';
        const specificStatusCode = 403;
        const testFailure =
            ServerFailure(specificErrorMessage, specificStatusCode);

        when(() => mockMapsRepository.getLocation())
            .thenAnswer((_) async => Left<Failure, MarkerEntity?>(testFailure));

        final result = await mapsUsecase.getLocation();

        result.when(
          (failure) {
            expect(failure.errorMessage, equals(specificErrorMessage));
            if (failure is ServerFailure) {
              expect(failure.statusCode, equals(specificStatusCode));
            }
          },
          (marker) => fail('Expected failure but got success'),
        );

        verify(() => mockMapsRepository.getLocation()).called(1);
      });

      test('should preserve exact marker details from repository', () async {
        const specificLat = 40.7128;
        const specificLng = -74.0060;
        const specificId = 999;
        final specificMarker = MarkerEntity(
          id: specificId,
          position: const LatLng(specificLat, specificLng),
        );

        when(() => mockMapsRepository.getLocation()).thenAnswer(
            (_) async => Right<Failure, MarkerEntity?>(specificMarker));

        final result = await mapsUsecase.getLocation();

        result.when(
          (failure) => fail('Expected success but got failure'),
          (marker) {
            expect(marker?.id, equals(specificId));
            expect(marker?.position.latitude, equals(specificLat));
            expect(marker?.position.longitude, equals(specificLng));
          },
        );

        verify(() => mockMapsRepository.getLocation()).called(1);
      });
    });

    group('integration scenarios', () {
      test('should work with different MarkerEntity configurations', () async {
        final extremeCoordinates = MarkerEntity(
          id: -1,
          position: const LatLng(-90.0, -180.0),
        );

        when(() => mockMapsRepository.getLocation()).thenAnswer(
            (_) async => Right<Failure, MarkerEntity?>(extremeCoordinates));

        final result = await mapsUsecase.getLocation();

        result.when(
          (failure) => fail('Should handle extreme coordinates'),
          (marker) {
            expect(marker?.id, equals(-1));
            expect(marker?.position.latitude, equals(-90.0));
            expect(marker?.position.longitude, equals(-180.0));
          },
        );

        verify(() => mockMapsRepository.getLocation()).called(1);
      });

      test('should handle zero coordinates correctly', () async {
        final zeroCoordinates = MarkerEntity(
          id: 0,
          position: const LatLng(0.0, 0.0),
        );

        when(() => mockMapsRepository.getLocation()).thenAnswer(
            (_) async => Right<Failure, MarkerEntity?>(zeroCoordinates));

        final result = await mapsUsecase.getLocation();

        result.when(
          (failure) => fail('Should handle zero coordinates'),
          (marker) {
            expect(marker?.id, equals(0));
            expect(marker?.position.latitude, equals(0.0));
            expect(marker?.position.longitude, equals(0.0));
          },
        );

        verify(() => mockMapsRepository.getLocation()).called(1);
      });
    });

    group('error handling edge cases', () {
      test('should handle repository returning different failure types',
          () async {
        const customFailure = ServerFailure('Custom failure message', 418);
        when(() => mockMapsRepository.getLocation()).thenAnswer(
            (_) async => Left<Failure, MarkerEntity?>(customFailure));

        final result = await mapsUsecase.getLocation();

        result.when(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.errorMessage, equals('Custom failure message'));
          },
          (marker) => fail('Expected failure'),
        );

        verify(() => mockMapsRepository.getLocation()).called(1);
      });

      test('should handle rapid successive calls', () async {
        when(() => mockMapsRepository.getLocation())
            .thenAnswer((_) async => Right<Failure, MarkerEntity?>(null));

        final futures = List.generate(5, (_) => mapsUsecase.getLocation());
        final results = await Future.wait(futures);

        for (final result in results) {
          expect(result, isA<Right<Failure, MarkerEntity?>>());
          result.when(
            (failure) => fail('All calls should succeed'),
            (marker) => expect(marker, isNull),
          );
        }

        verify(() => mockMapsRepository.getLocation()).called(5);
      });
    });
  });
}
