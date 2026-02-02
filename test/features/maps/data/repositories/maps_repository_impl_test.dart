import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marvel_animation_app/core/entities/entity_either.dart';
import 'package:marvel_animation_app/core/network/error/failures.dart';
import 'package:marvel_animation_app/features/maps/data/datasources/maps_datasource.dart';
import 'package:marvel_animation_app/features/maps/data/models/marker_data_model.dart';
import 'package:marvel_animation_app/features/maps/data/repositories/maps_repository_impl.dart';
import 'package:marvel_animation_app/features/maps/domain/entities/marker.dart';
import 'package:marvel_animation_app/shared/domain/models/api_response_model.dart';

class MockMapsDatasource extends Mock implements MapsDatasource {}

void main() {
  late MapsRepositoryImpl repository;
  late MockMapsDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockMapsDatasource();
    repository = MapsRepositoryImpl(dataSource: mockDatasource);

    registerFallbackValue(const LatLng(0.0, 0.0));
  });

  group('MapsRepositoryImpl', () {
    group('constructor', () {
      test('should create instance with required datasource', () {
        final repo = MapsRepositoryImpl(dataSource: mockDatasource);
        expect(repo, isA<MapsRepositoryImpl>());
        expect(repo.dataSource, equals(mockDatasource));
      });
    });

    group('getLocation', () {
      const testLatLng = LatLng(4.6097, -74.0817);
      const testMarkerModel = MarkerDataModel(
        id: 1,
        position: testLatLng,
      );
      final testApiResponse = ApiResponseModel<MarkerDataModel>(
        status: '200',
        results: testMarkerModel,
      );
      final expectedMarkerEntity = MarkerEntity(
        id: 1,
        position: testLatLng,
      );

      test('should return MarkerEntity when datasource call is successful',
          () async {
        when(() => mockDatasource.getMapLocation())
            .thenAnswer((_) async => Right(testApiResponse));

        final result = await repository.getLocation();

        expect(result, isA<Right<Failure, MarkerEntity?>>());
        result.when(
          (failure) =>
              fail('Expected Right but got Left: ${failure.errorMessage}'),
          (entity) {
            expect(entity, isNotNull);
            expect(entity!.id, equals(expectedMarkerEntity.id));
            expect(entity.position.latitude,
                equals(expectedMarkerEntity.position.latitude));
            expect(entity.position.longitude,
                equals(expectedMarkerEntity.position.longitude));
          },
        );

        verify(() => mockDatasource.getMapLocation()).called(1);
      });

      test('should return null when datasource returns null results', () async {
        final apiResponseWithNullResults = ApiResponseModel<MarkerDataModel?>(
          status: '200',
          results: null,
        );
        when(() => mockDatasource.getMapLocation())
            .thenAnswer((_) async => Right(apiResponseWithNullResults));

        final result = await repository.getLocation();

        expect(result, isA<Right<Failure, MarkerEntity?>>());
        result.when(
          (failure) =>
              fail('Expected Right but got Left: ${failure.errorMessage}'),
          (entity) {
            expect(entity, isNull);
          },
        );

        verify(() => mockDatasource.getMapLocation()).called(1);
      });

      test('should return ServerFailure when datasource returns ServerFailure',
          () async {
        const serverFailure = ServerFailure('Server error', 500);
        when(() => mockDatasource.getMapLocation())
            .thenAnswer((_) async => Left(serverFailure));

        final result = await repository.getLocation();

        expect(result, isA<Left<Failure, MarkerEntity?>>());
        result.when(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.errorMessage, equals('Server error'));
            expect((failure as ServerFailure).statusCode, equals(500));
          },
          (entity) => fail('Expected Left but got Right with entity: $entity'),
        );

        verify(() => mockDatasource.getMapLocation()).called(1);
      });

      test('should handle different coordinate values correctly', () async {
        const differentCoordinates = LatLng(-33.8688, 151.2093);
        const differentMarkerModel = MarkerDataModel(
          id: 2,
          position: differentCoordinates,
        );
        final differentApiResponse = ApiResponseModel<MarkerDataModel>(
          status: '200',
          results: differentMarkerModel,
        );

        when(() => mockDatasource.getMapLocation())
            .thenAnswer((_) async => Right(differentApiResponse));

        final result = await repository.getLocation();

        expect(result, isA<Right<Failure, MarkerEntity?>>());
        result.when(
          (failure) =>
              fail('Expected Right but got Left: ${failure.errorMessage}'),
          (entity) {
            expect(entity, isNotNull);
            expect(entity!.id, equals(2));
            expect(entity.position.latitude, equals(-33.8688));
            expect(entity.position.longitude, equals(151.2093));
          },
        );

        verify(() => mockDatasource.getMapLocation()).called(1);
      });

      test('should handle zero coordinates correctly', () async {
        const zeroCoordinates = LatLng(0.0, 0.0);
        const zeroMarkerModel = MarkerDataModel(
          id: 0,
          position: zeroCoordinates,
        );
        final zeroApiResponse = ApiResponseModel<MarkerDataModel>(
          status: '200',
          results: zeroMarkerModel,
        );

        when(() => mockDatasource.getMapLocation())
            .thenAnswer((_) async => Right(zeroApiResponse));

        final result = await repository.getLocation();

        expect(result, isA<Right<Failure, MarkerEntity?>>());
        result.when(
          (failure) =>
              fail('Expected Right but got Left: ${failure.errorMessage}'),
          (entity) {
            expect(entity, isNotNull);
            expect(entity!.id, equals(0));
            expect(entity.position.latitude, equals(0.0));
            expect(entity.position.longitude, equals(0.0));
          },
        );

        verify(() => mockDatasource.getMapLocation()).called(1);
      });

      test('should handle large coordinate values correctly', () async {
        const largeCoordinates = LatLng(89.999999, 179.999999);
        const largeMarkerModel = MarkerDataModel(
          id: 999999,
          position: largeCoordinates,
        );
        final largeApiResponse = ApiResponseModel<MarkerDataModel>(
          status: '200',
          results: largeMarkerModel,
        );

        when(() => mockDatasource.getMapLocation())
            .thenAnswer((_) async => Right(largeApiResponse));

        final result = await repository.getLocation();

        expect(result, isA<Right<Failure, MarkerEntity?>>());
        result.when(
          (failure) =>
              fail('Expected Right but got Left: ${failure.errorMessage}'),
          (entity) {
            expect(entity, isNotNull);
            expect(entity!.id, equals(999999));
            expect(entity.position.latitude, equals(89.999999));
            expect(entity.position.longitude, equals(179.999999));
          },
        );

        verify(() => mockDatasource.getMapLocation()).called(1);
      });

      test('should maintain data integrity through mapper transformation',
          () async {
        const originalCoordinates = LatLng(40.7128, -74.0060);
        const originalMarkerModel = MarkerDataModel(
          id: 42,
          position: originalCoordinates,
          markerUrl: null,
        );
        final originalApiResponse = ApiResponseModel<MarkerDataModel>(
          status: '200',
          results: originalMarkerModel,
        );

        when(() => mockDatasource.getMapLocation())
            .thenAnswer((_) async => Right(originalApiResponse));

        final result = await repository.getLocation();

        expect(result, isA<Right<Failure, MarkerEntity?>>());
        result.when(
          (failure) =>
              fail('Expected Right but got Left: ${failure.errorMessage}'),
          (entity) {
            expect(entity, isNotNull);

            expect(entity!.id, equals(originalMarkerModel.id));
            expect(entity.position.latitude,
                equals(originalMarkerModel.position.latitude));
            expect(entity.position.longitude,
                equals(originalMarkerModel.position.longitude));

            expect(entity, isA<MarkerEntity>());
          },
        );

        verify(() => mockDatasource.getMapLocation()).called(1);
      });
    });

    group('error handling edge cases', () {
      test('should handle multiple consecutive calls correctly', () async {
        const testMarkerModel = MarkerDataModel(
          id: 1,
          position: LatLng(4.6097, -74.0817),
        );
        final testApiResponse = ApiResponseModel<MarkerDataModel>(
          status: '200',
          results: testMarkerModel,
        );

        when(() => mockDatasource.getMapLocation())
            .thenAnswer((_) async => Right(testApiResponse));

        final result1 = await repository.getLocation();
        final result2 = await repository.getLocation();
        final result3 = await repository.getLocation();

        expect(result1, isA<Right<Failure, MarkerEntity?>>());
        expect(result2, isA<Right<Failure, MarkerEntity?>>());
        expect(result3, isA<Right<Failure, MarkerEntity?>>());

        result1.when(
          (failure) =>
              fail('Expected Right but got Left: ${failure.errorMessage}'),
          (entity1) {
            result2.when(
              (failure) =>
                  fail('Expected Right but got Left: ${failure.errorMessage}'),
              (entity2) {
                result3.when(
                  (failure) => fail(
                      'Expected Right but got Left: ${failure.errorMessage}'),
                  (entity3) {
                    expect(entity1!.id, equals(entity2!.id));
                    expect(entity2.id, equals(entity3!.id));
                    expect(entity1.position.latitude,
                        equals(entity2.position.latitude));
                    expect(entity2.position.longitude,
                        equals(entity3.position.longitude));
                  },
                );
              },
            );
          },
        );

        verify(() => mockDatasource.getMapLocation()).called(3);
      });

      test('should handle API response with different status codes', () async {
        const testMarkerModel = MarkerDataModel(
          id: 1,
          position: LatLng(4.6097, -74.0817),
        );
        final testApiResponse = ApiResponseModel<MarkerDataModel>(
          status: '201',
          results: testMarkerModel,
        );

        when(() => mockDatasource.getMapLocation())
            .thenAnswer((_) async => Right(testApiResponse));

        final result = await repository.getLocation();

        expect(result, isA<Right<Failure, MarkerEntity?>>());
        result.when(
          (failure) =>
              fail('Expected Right but got Left: ${failure.errorMessage}'),
          (entity) {
            expect(entity, isNotNull);
            expect(entity!.id, equals(1));
          },
        );

        verify(() => mockDatasource.getMapLocation()).called(1);
      });
    });

    group('integration scenarios', () {
      test('should handle success to failure transition correctly', () async {
        const testMarkerModel = MarkerDataModel(
          id: 1,
          position: LatLng(4.6097, -74.0817),
        );
        final successResponse = ApiResponseModel<MarkerDataModel>(
          status: '200',
          results: testMarkerModel,
        );
        const failureResponse = ServerFailure('Server down', 503);

        when(() => mockDatasource.getMapLocation())
            .thenAnswer((_) async => Right(successResponse));

        final successResult = await repository.getLocation();

        when(() => mockDatasource.getMapLocation())
            .thenAnswer((_) async => Left(failureResponse));

        final failureResult = await repository.getLocation();

        expect(successResult, isA<Right<Failure, MarkerEntity?>>());
        expect(failureResult, isA<Left<Failure, MarkerEntity?>>());

        successResult.when(
          (failure) =>
              fail('Expected Right but got Left: ${failure.errorMessage}'),
          (entity) {
            expect(entity, isNotNull);
            expect(entity!.id, equals(1));
          },
        );

        failureResult.when(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.errorMessage, equals('Server down'));
          },
          (entity) => fail('Expected Left but got Right with entity: $entity'),
        );

        verify(() => mockDatasource.getMapLocation()).called(2);
      });

      test('should handle null to valid data transition correctly', () async {
        final nullResponse = ApiResponseModel<MarkerDataModel?>(
          status: '200',
          results: null,
        );
        const validMarkerModel = MarkerDataModel(
          id: 1,
          position: LatLng(4.6097, -74.0817),
        );
        final validResponse = ApiResponseModel<MarkerDataModel>(
          status: '200',
          results: validMarkerModel,
        );

        when(() => mockDatasource.getMapLocation())
            .thenAnswer((_) async => Right(nullResponse));

        final nullResult = await repository.getLocation();

        when(() => mockDatasource.getMapLocation())
            .thenAnswer((_) async => Right(validResponse));

        final validResult = await repository.getLocation();

        expect(nullResult, isA<Right<Failure, MarkerEntity?>>());
        expect(validResult, isA<Right<Failure, MarkerEntity?>>());

        nullResult.when(
          (failure) =>
              fail('Expected Right but got Left: ${failure.errorMessage}'),
          (entity) {
            expect(entity, isNull);
          },
        );

        validResult.when(
          (failure) =>
              fail('Expected Right but got Left: ${failure.errorMessage}'),
          (entity) {
            expect(entity, isNotNull);
            expect(entity!.id, equals(1));
          },
        );

        verify(() => mockDatasource.getMapLocation()).called(2);
      });
    });
  });
}
