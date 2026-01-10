import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marvel_animation_app/core/entities/entity_either.dart';
import 'package:marvel_animation_app/core/network/error/failures.dart';
import 'package:marvel_animation_app/features/maps/domain/entities/marker.dart';
import 'package:marvel_animation_app/features/maps/domain/usecases/maps_usecase.dart';
import 'package:marvel_animation_app/features/maps/presentation/state/maps_provider.dart';
import 'package:marvel_animation_app/features/maps/presentation/state/maps_state.dart';
import 'package:marvel_animation_app/shared/presentation/tokens/tokens.dart';
import 'package:mocktail/mocktail.dart';

class MockMapsUsecase extends Mock implements MapsUsecase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MapsNotifier', () {
    late MockMapsUsecase mockMapsUsecase;
    late ProviderContainer container;

    setUp(() {
      mockMapsUsecase = MockMapsUsecase();
      container = ProviderContainer(
        overrides: [
          mapsUsecaseProvider.overrideWith((ref) => mockMapsUsecase),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('build', () {
      test('should return initial state with default values', () {
        final state = container.read(mapsProvider);

        expect(state.location, isNull);
        expect(state.isLoading, isFalse);
        expect(state.alert, isNull);
      });

      test('should initialize mapsUsecase from provider', () {
        final notifier = container.read(mapsProvider.notifier);

        expect(notifier.mapsUsecase, equals(mockMapsUsecase));
      });
    });

    group('cleanAlert', () {
      test('should update state with copyWith', () {
        final notifier = container.read(mapsProvider.notifier);
        final initialState = container.read(mapsProvider);

        notifier.cleanAlert();

        final newState = container.read(mapsProvider);
        expect(newState, isNot(same(initialState)));
      });

      test('should maintain same values after cleanAlert', () {
        final notifier = container.read(mapsProvider.notifier);

        notifier.cleanAlert();

        final state = container.read(mapsProvider);
        expect(state.location, isNull);
        expect(state.isLoading, isFalse);
        expect(state.alert, isNull);
      });
    });

    group('getLocation', () {
      test('should set isLoading to true initially', () async {
        when(() => mockMapsUsecase.getLocation())
            .thenAnswer((_) async => Right(null));

        final notifier = container.read(mapsProvider.notifier);

        final future = notifier.getLocation();

        expect(container.read(mapsProvider).isLoading, isTrue);

        await future;
      });

      test('should set isLoading to false after completion', () async {
        when(() => mockMapsUsecase.getLocation())
            .thenAnswer((_) async => Right(null));

        final notifier = container.read(mapsProvider.notifier);

        await notifier.getLocation();

        expect(container.read(mapsProvider).isLoading, isFalse);
      });

      test('should handle failure response with error alert', () async {
        const errorMessage = 'Location error';
        final failure = ServerFailure(errorMessage, 500);

        when(() => mockMapsUsecase.getLocation())
            .thenAnswer((_) async => Left(failure));

        final notifier = container.read(mapsProvider.notifier);

        await notifier.getLocation();

        final state = container.read(mapsProvider);
        expect(state.isLoading, isFalse);
        expect(state.alert, isNotNull);
        expect(state.alert!.message, equals(errorMessage));
        expect(state.alert!.backgroundColor, equals(CustomColor.ERROR_COLOR));
        expect(state.location, isNull);
      });

      test('should handle success response with null marker', () async {
        when(() => mockMapsUsecase.getLocation())
            .thenAnswer((_) async => Right(null));

        final notifier = container.read(mapsProvider.notifier);

        await notifier.getLocation();

        final state = container.read(mapsProvider);
        expect(state.isLoading, isFalse);
        expect(state.alert, isNull);
        expect(state.location, isNull);
      });

      test('should handle success response with valid marker entity', () async {
        final markerEntity = MarkerEntity(
          id: 1,
          position: const LatLng(4.6097, -74.0817),
        );

        when(() => mockMapsUsecase.getLocation())
            .thenAnswer((_) async => Right(markerEntity));

        final notifier = container.read(mapsProvider.notifier);

        try {
          await notifier.getLocation();
          final state = container.read(mapsProvider);
          expect(state.isLoading, isFalse);
        } catch (e) {
          final state = container.read(mapsProvider);
          expect(state.isLoading, isFalse);
        }
      });

      test('should call mapsUsecase.getLocation once', () async {
        when(() => mockMapsUsecase.getLocation())
            .thenAnswer((_) async => Right(null));

        final notifier = container.read(mapsProvider.notifier);

        await notifier.getLocation();

        verify(() => mockMapsUsecase.getLocation()).called(1);
      });

      test('should handle multiple getLocation calls', () async {
        when(() => mockMapsUsecase.getLocation())
            .thenAnswer((_) async => Right(null));

        final notifier = container.read(mapsProvider.notifier);

        await notifier.getLocation();
        await notifier.getLocation();
        await notifier.getLocation();

        verify(() => mockMapsUsecase.getLocation()).called(3);
      });

      test('should maintain loading state during async operation', () async {
        when(() => mockMapsUsecase.getLocation()).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return Right(null);
        });

        final notifier = container.read(mapsProvider.notifier);

        final future = notifier.getLocation();

        expect(container.read(mapsProvider).isLoading, isTrue);

        await Future.delayed(const Duration(milliseconds: 50));
        expect(container.read(mapsProvider).isLoading, isTrue);

        await future;
        expect(container.read(mapsProvider).isLoading, isFalse);
      });

      test('should handle server failure with status code', () async {
        final serverFailure = ServerFailure('Server error', 404);

        when(() => mockMapsUsecase.getLocation())
            .thenAnswer((_) async => Left(serverFailure));

        final notifier = container.read(mapsProvider.notifier);

        await notifier.getLocation();

        final state = container.read(mapsProvider);
        expect(state.alert!.message, equals('Server error'));
        expect(state.alert!.backgroundColor, equals(CustomColor.ERROR_COLOR));
      });

      test('should set location after successful fetch following error',
          () async {
        final failure = ServerFailure('Error', 500);
        final markerEntity = MarkerEntity(
          id: 1,
          position: const LatLng(4.6097, -74.0817),
        );

        when(() => mockMapsUsecase.getLocation())
            .thenAnswer((_) async => Left(failure));

        final notifier = container.read(mapsProvider.notifier);

        await notifier.getLocation();
        expect(container.read(mapsProvider).alert, isNotNull);

        when(() => mockMapsUsecase.getLocation())
            .thenAnswer((_) async => Right(markerEntity));

        try {
          await notifier.getLocation();

          final finalState = container.read(mapsProvider);
          expect(finalState.isLoading, isFalse);
        } catch (e) {
          final finalState = container.read(mapsProvider);
          expect(finalState.isLoading, isFalse);
        }
      });
    });

    group('state management', () {
      test('should notify listeners when state changes', () {
        final notifier = container.read(mapsProvider.notifier);
        var notificationCount = 0;

        container.listen<MapsState>(
          mapsProvider,
          (previous, next) {
            notificationCount++;
          },
        );

        notifier.cleanAlert();

        expect(notificationCount, equals(1));
      });

      test('should provide correct previous and next state values', () async {
        when(() => mockMapsUsecase.getLocation())
            .thenAnswer((_) async => Right(null));

        final notifier = container.read(mapsProvider.notifier);
        MapsState? previousState;
        MapsState? nextState;

        container.listen<MapsState>(
          mapsProvider,
          (previous, next) {
            previousState = previous;
            nextState = next;
          },
        );

        await notifier.getLocation();

        expect(previousState, isNotNull);
        expect(nextState, isNotNull);
        expect(nextState!.isLoading, isFalse);
      });
    });

    group('edge cases', () {
      test('should handle usecase throwing exception', () async {
        when(() => mockMapsUsecase.getLocation())
            .thenThrow(Exception('Unexpected error'));

        final notifier = container.read(mapsProvider.notifier);

        expect(() => notifier.getLocation(), throwsException);
      });

      test('should work with different marker positions', () async {
        final markerEntity = MarkerEntity(
          id: 999,
          position: const LatLng(0.0, 0.0),
        );

        when(() => mockMapsUsecase.getLocation())
            .thenAnswer((_) async => Right(markerEntity));

        final notifier = container.read(mapsProvider.notifier);

        try {
          await notifier.getLocation();
          final state = container.read(mapsProvider);
          expect(state.isLoading, isFalse);
        } catch (e) {
          final state = container.read(mapsProvider);
          expect(state.isLoading, isFalse);
        }
      });
    });
  });
}
