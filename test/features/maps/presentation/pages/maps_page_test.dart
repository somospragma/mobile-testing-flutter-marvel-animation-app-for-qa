import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marvel_animation_app/core/entities/entity_either.dart';
import 'package:marvel_animation_app/core/network/error/failures.dart';
import 'package:marvel_animation_app/features/maps/domain/usecases/maps_usecase.dart';
import 'package:marvel_animation_app/features/maps/presentation/pages/maps_page.dart';
import 'package:marvel_animation_app/shared/presentation/templates/main_template.dart';
import 'package:mocktail/mocktail.dart';

class MockMapsUsecase extends Mock implements MapsUsecase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MapPage', () {
    late MockMapsUsecase mockMapsUsecase;

    setUp(() {
      mockMapsUsecase = MockMapsUsecase();
    });

    Widget createTestWidget({
      overrides,
    }) {
      return ScreenUtilInit(
        designSize: const Size(375, 812),
        child: ProviderScope(
          overrides: overrides ??
              [
                mapsUsecaseProvider.overrideWith((ref) => mockMapsUsecase),
              ],
          child: const MaterialApp(
            home: MapPage(),
          ),
        ),
      );
    }

    testWidgets('should render MapPage widget', (tester) async {
      when(() => mockMapsUsecase.getLocation())
          .thenAnswer((_) async => Right(null));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(MapPage), findsOneWidget);
    });

    testWidgets('should show MainTemplate after loading completes',
        (tester) async {
      when(() => mockMapsUsecase.getLocation())
          .thenAnswer((_) async => Right(null));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(MainTemplate), findsOneWidget);
      expect(find.byType(GoogleMap), findsOneWidget);
    });

    testWidgets(
        'should configure GoogleMap with empty markers when location is null',
        (tester) async {
      when(() => mockMapsUsecase.getLocation())
          .thenAnswer((_) async => Right(null));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final googleMap = tester.widget<GoogleMap>(find.byType(GoogleMap));
      expect(googleMap.markers, isEmpty);
    });

    testWidgets('should handle usecase failure gracefully', (tester) async {
      final failure = ServerFailure('Location error', 500);
      when(() => mockMapsUsecase.getLocation())
          .thenAnswer((_) async => Left(failure));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(GoogleMap), findsOneWidget);
    });

    testWidgets('should call getLocation on initialization', (tester) async {
      when(() => mockMapsUsecase.getLocation())
          .thenAnswer((_) async => Right(null));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      verify(() => mockMapsUsecase.getLocation()).called(1);
    });
  });
}
