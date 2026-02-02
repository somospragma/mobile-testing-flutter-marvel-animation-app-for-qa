import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:marvel_animation_app/features/splash/presentation/pages/splash_screen.dart';
import 'package:marvel_animation_app/shared/presentation/tokens/tokens.dart';

void main() {
  group('SplashScreen', () {
    late GoRouter router;

    setUp(() {
      router = GoRouter(
        initialLocation: '/splash',
        routes: [
          GoRoute(
            path: '/splash',
            builder: (context, state) => const SplashScreen(),
          ),
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Home')),
            ),
          ),
        ],
      );
    });

    Widget createTestWidget() {
      return MaterialApp.router(
        routerConfig: router,
      );
    }

    testWidgets('should render SplashScreen widget', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);

      // Complete pending animations
      await tester.pumpAndSettle(const Duration(seconds: 5));
    });

    testWidgets('should have correct background color', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(CustomColor.BRAND_PRIMARY_00));

      await tester.pumpAndSettle(const Duration(seconds: 5));
    });

    testWidgets('should display logo image', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Image), findsOneWidget);

      final image = tester.widget<Image>(find.byType(Image));
      final assetImage = image.image as AssetImage;
      expect(assetImage.assetName, equals('assets/logo.png'));

      await tester.pumpAndSettle(const Duration(seconds: 5));
    });

    testWidgets('should have AnimatedContainer and AnimatedOpacity',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(AnimatedContainer), findsOneWidget);
      expect(find.byType(AnimatedOpacity), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 5));
    });

    testWidgets('should center the content', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Center), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 5));
    });
  });
}
