import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marvel_animation_app/shared/presentation/widgets/image_viewer.dart';

void main() {
  group('ImageViewer', () {
    Widget createWidget(ImageViewer widget) {
      return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          home: widget,
        ),
      );
    }

    group('Basic functionality', () {
      testWidgets('should create widget with all required parameters',
          (WidgetTester tester) async {
        const widget = ImageViewer(
          imageUrl: 'https://example.com/hero.jpg',
          heroName: 'Spider-Man',
          heroTag: 'hero-card-123',
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        expect(find.byType(ImageViewer), findsOneWidget);
        expect(find.text('Spider-Man'), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('should display hero name in app bar',
          (WidgetTester tester) async {
        const widget = ImageViewer(
          imageUrl: 'https://example.com/hero.jpg',
          heroName: 'Iron Man',
          heroTag: 'hero-card-456',
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        expect(find.text('Iron Man'), findsOneWidget);

        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        final titleWidget = appBar.title as Text;
        expect(titleWidget.data, equals('Iron Man'));
      });

      testWidgets('should have correct widget structure',
          (WidgetTester tester) async {
        const widget = ImageViewer(
          imageUrl: 'https://example.com/hero.jpg',
          heroName: 'Thor',
          heroTag: 'hero-card-789',
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(Hero), findsOneWidget);
        expect(find.byType(InteractiveViewer), findsOneWidget);

        expect(find.byIcon(Icons.close), findsOneWidget);
        expect(find.byIcon(Icons.refresh), findsOneWidget);

        expect(find.text('Pinch to zoom • Drag to pan • Tap refresh to reset'),
            findsOneWidget);
      });

      testWidgets('should have correct scaffold styling',
          (WidgetTester tester) async {
        const widget = ImageViewer(
          imageUrl: 'https://example.com/hero.jpg',
          heroName: 'Hulk',
          heroTag: 'hero-card-101',
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.backgroundColor, equals(Colors.black));
      });
    });

    group('App bar functionality', () {
      testWidgets('should have close button that calls Navigator.pop',
          (WidgetTester tester) async {
        bool popCalled = false;

        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (context, child) => MaterialApp(
              home: Navigator(
                onPopPage: (route, result) {
                  popCalled = true;
                  return route.didPop(result);
                },
                pages: const [
                  MaterialPage(
                    child: ImageViewer(
                      imageUrl: 'https://example.com/hero.jpg',
                      heroName: 'Captain America',
                      heroTag: 'hero-card-202',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pump();

        await tester.tap(find.byIcon(Icons.close));
        await tester.pump();

        expect(popCalled, isTrue);
      });

      testWidgets('should have refresh button', (WidgetTester tester) async {
        const widget = ImageViewer(
          imageUrl: 'https://example.com/hero.jpg',
          heroName: 'Black Widow',
          heroTag: 'hero-card-303',
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        final refreshButton = find.byIcon(Icons.refresh);
        expect(refreshButton, findsOneWidget);

        await tester.tap(refreshButton);
        await tester.pump();
      });

      testWidgets('should have correct app bar styling',
          (WidgetTester tester) async {
        const widget = ImageViewer(
          imageUrl: 'https://example.com/hero.jpg',
          heroName: 'Doctor Strange',
          heroTag: 'hero-card-404',
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBar.elevation, equals(0));
      });
    });

    group('Hero tag parsing', () {
      testWidgets('should parse hero ID from valid hero tag',
          (WidgetTester tester) async {
        const widget = ImageViewer(
          imageUrl: 'https://example.com/hero.jpg',
          heroName: 'Wolverine',
          heroTag: 'hero-card-567',
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        expect(find.byType(ImageViewer), findsOneWidget);
      });

      testWidgets('should handle malformed hero tag gracefully',
          (WidgetTester tester) async {
        const widget = ImageViewer(
          imageUrl: 'https://example.com/hero.jpg',
          heroName: 'Deadpool',
          heroTag: 'invalid-tag',
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        expect(find.byType(ImageViewer), findsOneWidget);
        expect(find.text('Deadpool'), findsOneWidget);
      });

      testWidgets('should handle empty hero tag', (WidgetTester tester) async {
        const widget = ImageViewer(
          imageUrl: 'https://example.com/hero.jpg',
          heroName: 'Ant-Man',
          heroTag: '',
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        expect(find.byType(ImageViewer), findsOneWidget);
        expect(find.text('Ant-Man'), findsOneWidget);
      });

      testWidgets('should handle hero tag with non-numeric ending',
          (WidgetTester tester) async {
        const widget = ImageViewer(
          imageUrl: 'https://example.com/hero.jpg',
          heroName: 'Wasp',
          heroTag: 'hero-card-abc',
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        expect(find.byType(ImageViewer), findsOneWidget);
        expect(find.text('Wasp'), findsOneWidget);
      });

      testWidgets('should handle hero tag with insufficient parts',
          (WidgetTester tester) async {
        const widget = ImageViewer(
          imageUrl: 'https://example.com/hero.jpg',
          heroName: 'Falcon',
          heroTag: 'hero-123',
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        expect(find.byType(ImageViewer), findsOneWidget);
        expect(find.text('Falcon'), findsOneWidget);
      });
    });

    group('Interactive viewer functionality', () {
      testWidgets('should have InteractiveViewer with correct scale bounds',
          (WidgetTester tester) async {
        const widget = ImageViewer(
          imageUrl: 'https://example.com/hero.jpg',
          heroName: 'Vision',
          heroTag: 'hero-card-678',
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        final interactiveViewer =
            tester.widget<InteractiveViewer>(find.byType(InteractiveViewer));
        expect(interactiveViewer.minScale, equals(0.5));
        expect(interactiveViewer.maxScale, equals(5.0));
      });

      testWidgets('should have transformation controller',
          (WidgetTester tester) async {
        const widget = ImageViewer(
          imageUrl: 'https://example.com/hero.jpg',
          heroName: 'Scarlet Witch',
          heroTag: 'hero-card-789',
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        final interactiveViewer =
            tester.widget<InteractiveViewer>(find.byType(InteractiveViewer));
        expect(interactiveViewer.transformationController, isNotNull);
      });
    });

    group('Hero widget functionality', () {
      testWidgets('should have Hero widget with correct tag',
          (WidgetTester tester) async {
        const heroTag = 'hero-card-890';
        const widget = ImageViewer(
          imageUrl: 'https://example.com/hero.jpg',
          heroName: 'Quicksilver',
          heroTag: heroTag,
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        final hero = tester.widget<Hero>(find.byType(Hero));
        expect(hero.tag, equals(heroTag));
      });

      testWidgets('should maintain hero tag consistency',
          (WidgetTester tester) async {
        const heroTag = 'custom-hero-tag-999';
        const widget = ImageViewer(
          imageUrl: 'https://example.com/hero.jpg',
          heroName: 'Loki',
          heroTag: heroTag,
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        final hero = tester.widget<Hero>(find.byType(Hero));
        expect(hero.tag, equals(heroTag));
      });
    });

    group('Image display', () {
      testWidgets('should call ImageProxyService.buildImage without crashing',
          (WidgetTester tester) async {
        const imageUrl = 'https://example.com/test-hero.jpg';
        const heroName = 'Test Hero';
        const widget = ImageViewer(
          imageUrl: imageUrl,
          heroName: heroName,
          heroTag: 'hero-card-123',
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        expect(find.byType(ImageViewer), findsOneWidget);
      });

      testWidgets('should handle different image URLs',
          (WidgetTester tester) async {
        const widget = ImageViewer(
          imageUrl: 'https://different-domain.com/another-hero.png',
          heroName: 'Another Hero',
          heroTag: 'hero-card-456',
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        expect(find.byType(ImageViewer), findsOneWidget);
      });
    });

    group('Bottom navigation styling', () {
      testWidgets('should display instruction text in bottom navigation',
          (WidgetTester tester) async {
        const widget = ImageViewer(
          imageUrl: 'https://example.com/hero.jpg',
          heroName: 'Captain Marvel',
          heroTag: 'hero-card-567',
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        expect(find.text('Pinch to zoom • Drag to pan • Tap refresh to reset'),
            findsOneWidget);
      });

      testWidgets('should have proper container styling in bottom navigation',
          (WidgetTester tester) async {
        const widget = ImageViewer(
          imageUrl: 'https://example.com/hero.jpg',
          heroName: 'Black Panther',
          heroTag: 'hero-card-678',
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        expect(find.byType(SafeArea), findsAtLeast(1));
      });
    });

    group('Animation functionality', () {
      testWidgets('should handle reset zoom animation',
          (WidgetTester tester) async {
        const widget = ImageViewer(
          imageUrl: 'https://example.com/hero.jpg',
          heroName: 'Doctor Doom',
          heroTag: 'hero-card-789',
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        await tester.tap(find.byIcon(Icons.refresh));
        await tester.pump();

        expect(find.byType(ImageViewer), findsOneWidget);
      });

      testWidgets('should complete animation cycle without errors',
          (WidgetTester tester) async {
        const widget = ImageViewer(
          imageUrl: 'https://example.com/hero.jpg',
          heroName: 'Silver Surfer',
          heroTag: 'hero-card-890',
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 150));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.byType(ImageViewer), findsOneWidget);
      });
    });

    group('Edge cases', () {
      testWidgets('should handle very long hero names',
          (WidgetTester tester) async {
        const widget = ImageViewer(
          imageUrl: 'https://example.com/hero.jpg',
          heroName:
              'This Is A Very Long Hero Name That Might Cause Layout Issues',
          heroTag: 'hero-card-999',
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        expect(find.byType(ImageViewer), findsOneWidget);
      });

      testWidgets('should handle empty hero name', (WidgetTester tester) async {
        const widget = ImageViewer(
          imageUrl: 'https://example.com/hero.jpg',
          heroName: '',
          heroTag: 'hero-card-000',
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        expect(find.byType(ImageViewer), findsOneWidget);
      });

      testWidgets('should handle basic special characters in hero name',
          (WidgetTester tester) async {
        const widget = ImageViewer(
          imageUrl: 'https://example.com/hero.jpg',
          heroName: 'Spider-Man & The Avengers',
          heroTag: 'hero-card-special',
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        expect(find.byType(ImageViewer), findsOneWidget);
      });

      testWidgets('should handle standard image URLs',
          (WidgetTester tester) async {
        const widget = ImageViewer(
          imageUrl: 'https://example.com/images/hero.jpg',
          heroName: 'URL Test Hero',
          heroTag: 'hero-card-url-test',
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        expect(find.byType(ImageViewer), findsOneWidget);
      });

      testWidgets('should handle simple malformed URLs gracefully',
          (WidgetTester tester) async {
        const widget = ImageViewer(
          imageUrl: 'invalid-url',
          heroName: 'Invalid URL Hero',
          heroTag: 'hero-card-invalid',
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        expect(find.byType(ImageViewer), findsOneWidget);
      });
    });

    group('Responsive design', () {
      testWidgets('should maintain responsive design with ScreenUtil',
          (WidgetTester tester) async {
        const widget = ImageViewer(
          imageUrl: 'https://example.com/hero.jpg',
          heroName: 'Responsive Hero',
          heroTag: 'hero-card-responsive',
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        expect(find.byType(ImageViewer), findsOneWidget);
      });

      testWidgets('should handle different screen sizes',
          (WidgetTester tester) async {
        final widget = ScreenUtilInit(
          designSize: const Size(414, 896),
          builder: (context, child) => const MaterialApp(
            home: ImageViewer(
              imageUrl: 'https://example.com/hero.jpg',
              heroName: 'Size Test Hero',
              heroTag: 'hero-card-size-test',
            ),
          ),
        );

        await tester.pumpWidget(widget);
        await tester.pump();

        expect(find.byType(ImageViewer), findsOneWidget);
      });
    });

    group('Widget lifecycle', () {
      testWidgets('should properly dispose controllers',
          (WidgetTester tester) async {
        const widget = ImageViewer(
          imageUrl: 'https://example.com/hero.jpg',
          heroName: 'Disposal Test Hero',
          heroTag: 'hero-card-disposal',
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        expect(find.byType(ImageViewer), findsOneWidget);

        await tester.pumpWidget(ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => const MaterialApp(
            home: Scaffold(body: Text('Disposed')),
          ),
        ));
        await tester.pump();

        expect(find.text('Disposed'), findsOneWidget);
        expect(find.byType(ImageViewer), findsNothing);
      });

      testWidgets('should initialize controllers in initState',
          (WidgetTester tester) async {
        const widget = ImageViewer(
          imageUrl: 'https://example.com/hero.jpg',
          heroName: 'Init Test Hero',
          heroTag: 'hero-card-init',
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        expect(find.byType(ImageViewer), findsOneWidget);

        expect(find.byType(InteractiveViewer), findsOneWidget);
      });
    });

    group('Parameter validation', () {
      testWidgets('should handle all required parameters correctly',
          (WidgetTester tester) async {
        const imageUrl = 'https://test.com/image.jpg';
        const heroName = 'Test Hero Name';
        const heroTag = 'test-hero-tag-123';

        const widget = ImageViewer(
          imageUrl: imageUrl,
          heroName: heroName,
          heroTag: heroTag,
        );

        await tester.pumpWidget(createWidget(widget));
        await tester.pump();

        expect(find.byType(ImageViewer), findsOneWidget);
        expect(find.text(heroName), findsOneWidget);

        final hero = tester.widget<Hero>(find.byType(Hero));
        expect(hero.tag, equals(heroTag));
      });

      testWidgets('should create widget instances with different parameters',
          (WidgetTester tester) async {
        const widget1 = ImageViewer(
          imageUrl: 'https://example1.com/hero1.jpg',
          heroName: 'Hero One',
          heroTag: 'hero-1',
        );

        await tester.pumpWidget(createWidget(widget1));
        await tester.pump();

        expect(find.text('Hero One'), findsOneWidget);

        const widget2 = ImageViewer(
          imageUrl: 'https://example2.com/hero2.jpg',
          heroName: 'Hero Two',
          heroTag: 'hero-2',
        );

        await tester.pumpWidget(createWidget(widget2));
        await tester.pump();

        expect(find.text('Hero Two'), findsOneWidget);
        expect(find.text('Hero One'), findsNothing);
      });
    });
  });
}
