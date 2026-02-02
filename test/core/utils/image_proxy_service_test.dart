import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marvel_animation_app/core/utils/image_proxy_service.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  group('ImageProxyService', () {
    group('buildImage', () {
      testWidgets('should return CachedNetworkImage widget',
          (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: 'https://cdn.superherodb.com/images/test.jpg',
          heroName: 'Test Hero',
          heroId: 1,
        );

        await tester.pumpWidget(MaterialApp(home: widget));

        expect(find.byType(CachedNetworkImage), findsOneWidget);
      });

      testWidgets('should use proxied URL for superherodb images',
          (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: 'https://cdn.superherodb.com/images/portraits/test.jpg',
          heroName: 'Spider-Man',
          heroId: 1,
        );

        await tester.pumpWidget(MaterialApp(home: widget));

        final cachedNetworkImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );

        expect(cachedNetworkImage.imageUrl, contains('images.weserv.nl'));
        expect(cachedNetworkImage.imageUrl, contains('superherodb.com'));
      });

      testWidgets('should not proxy non-superherodb URLs',
          (WidgetTester tester) async {
        const originalUrl = 'https://example.com/image.jpg';
        final widget = ImageProxyService.buildImage(
          imageUrl: originalUrl,
          heroName: 'Test Hero',
          heroId: 1,
        );

        await tester.pumpWidget(MaterialApp(home: widget));

        final cachedNetworkImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );

        expect(cachedNetworkImage.imageUrl, equals(originalUrl));
      });

      testWidgets('should handle empty URL', (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: '',
          heroName: 'Test Hero',
          heroId: 1,
        );

        await tester.pumpWidget(MaterialApp(home: widget));

        final cachedNetworkImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );

        expect(cachedNetworkImage.imageUrl, equals(''));
      });

      testWidgets('should handle non-http URLs', (WidgetTester tester) async {
        const fileUrl = 'file:///local/image.jpg';
        final widget = ImageProxyService.buildImage(
          imageUrl: fileUrl,
          heroName: 'Test Hero',
          heroId: 1,
        );

        await tester.pumpWidget(MaterialApp(home: widget));

        final cachedNetworkImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );

        expect(cachedNetworkImage.imageUrl, equals(fileUrl));
      });

      testWidgets('should apply correct BoxFit', (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: 'https://example.com/test.jpg',
          heroName: 'Test Hero',
          heroId: 1,
          fit: BoxFit.contain,
        );

        await tester.pumpWidget(MaterialApp(home: widget));

        final cachedNetworkImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );

        expect(cachedNetworkImage.fit, equals(BoxFit.contain));
      });

      testWidgets('should use default BoxFit.cover when not specified',
          (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: 'https://example.com/test.jpg',
          heroName: 'Test Hero',
          heroId: 1,
        );

        await tester.pumpWidget(MaterialApp(home: widget));

        final cachedNetworkImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );

        expect(cachedNetworkImage.fit, equals(BoxFit.cover));
      });

      testWidgets('should apply width and height', (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: 'https://example.com/test.jpg',
          heroName: 'Test Hero',
          heroId: 1,
          width: 200,
          height: 150,
        );

        await tester.pumpWidget(MaterialApp(home: widget));

        final cachedNetworkImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );

        expect(cachedNetworkImage.width, equals(200));
        expect(cachedNetworkImage.height, equals(150));
      });

      testWidgets('should have shimmer placeholder',
          (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: 'https://example.com/test.jpg',
          heroName: 'Test Hero',
          heroId: 1,
        );

        await tester.pumpWidget(MaterialApp(home: widget));

        final cachedNetworkImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );

        expect(cachedNetworkImage.placeholder, isNotNull);
      });

      testWidgets('should have zero fade durations',
          (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: 'https://example.com/test.jpg',
          heroName: 'Test Hero',
          heroId: 1,
        );

        await tester.pumpWidget(MaterialApp(home: widget));

        final cachedNetworkImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );

        expect(cachedNetworkImage.placeholderFadeInDuration,
            equals(Duration.zero));
        expect(cachedNetworkImage.fadeInDuration, equals(Duration.zero));
        expect(cachedNetworkImage.fadeOutDuration, equals(Duration.zero));
      });

      testWidgets('should have error widget', (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: 'https://example.com/test.jpg',
          heroName: 'Test Hero',
          heroId: 1,
        );

        await tester.pumpWidget(MaterialApp(home: widget));

        final cachedNetworkImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );

        expect(cachedNetworkImage.errorWidget, isNotNull);
      });
    });

    group('URL proxying behavior', () {
      testWidgets('should proxy valid superherodb HTTP URL',
          (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: 'http://cdn.superherodb.com/images/test.jpg',
          heroName: 'Test',
          heroId: 1,
        );

        await tester.pumpWidget(MaterialApp(home: widget));

        final cachedImage =
            tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
        expect(
            cachedImage.imageUrl, startsWith('https://images.weserv.nl/?url='));
      });

      testWidgets('should proxy valid superherodb HTTPS URL',
          (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: 'https://cdn.superherodb.com/images/test.jpg',
          heroName: 'Test',
          heroId: 1,
        );

        await tester.pumpWidget(MaterialApp(home: widget));

        final cachedImage =
            tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
        expect(
            cachedImage.imageUrl, startsWith('https://images.weserv.nl/?url='));
      });

      testWidgets('should not proxy non-superherodb HTTP URL',
          (WidgetTester tester) async {
        const url = 'http://example.com/image.jpg';
        final widget = ImageProxyService.buildImage(
          imageUrl: url,
          heroName: 'Test',
          heroId: 1,
        );

        await tester.pumpWidget(MaterialApp(home: widget));

        final cachedImage =
            tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
        expect(cachedImage.imageUrl, equals(url));
      });

      testWidgets('should not proxy relative URL', (WidgetTester tester) async {
        const url = '/images/test.jpg';
        final widget = ImageProxyService.buildImage(
          imageUrl: url,
          heroName: 'Test',
          heroId: 1,
        );

        await tester.pumpWidget(MaterialApp(home: widget));

        final cachedImage =
            tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
        expect(cachedImage.imageUrl, equals(url));
      });
    });

    group('Hero name processing', () {
      testWidgets('should handle single word name',
          (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: 'invalid-url',
          heroName: 'Superman',
          heroId: 1,
        );

        await tester.pumpWidget(MaterialApp(home: widget));
        await tester.pump();

        expect(find.byType(CachedNetworkImage), findsWidgets);
      });

      testWidgets('should handle two word name', (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: 'invalid-url',
          heroName: 'Iron Man',
          heroId: 1,
        );

        await tester.pumpWidget(MaterialApp(home: widget));
        await tester.pump();

        expect(find.byType(CachedNetworkImage), findsWidgets);
      });

      testWidgets('should handle hyphenated name', (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: 'invalid-url',
          heroName: 'Spider-Man',
          heroId: 1,
        );

        await tester.pumpWidget(MaterialApp(home: widget));
        await tester.pump();

        expect(find.byType(CachedNetworkImage), findsWidgets);
      });

      testWidgets('should handle empty name', (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: 'invalid-url',
          heroName: '',
          heroId: 1,
        );

        await tester.pumpWidget(MaterialApp(home: widget));
        await tester.pump();

        expect(find.byType(CachedNetworkImage), findsWidgets);
      });

      testWidgets('should handle name with multiple spaces',
          (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: 'invalid-url',
          heroName: 'Captain   America',
          heroId: 1,
        );

        await tester.pumpWidget(MaterialApp(home: widget));
        await tester.pump();

        expect(find.byType(CachedNetworkImage), findsWidgets);
      });

      testWidgets('should handle name with special characters',
          (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: 'invalid-url',
          heroName: 'Dr. Strange',
          heroId: 1,
        );

        await tester.pumpWidget(MaterialApp(home: widget));
        await tester.pump();

        expect(find.byType(CachedNetworkImage), findsWidgets);
      });
    });

    group('Hero ID color generation', () {
      testWidgets('should generate consistent colors for same ID',
          (WidgetTester tester) async {
        final widget1 = ImageProxyService.buildImage(
          imageUrl: 'invalid-url-1',
          heroName: 'Hero1',
          heroId: 5,
        );

        final widget2 = ImageProxyService.buildImage(
          imageUrl: 'invalid-url-2',
          heroName: 'Hero2',
          heroId: 5,
        );

        await tester.pumpWidget(
            MaterialApp(home: Column(children: [widget1, widget2])));
        await tester.pump();

        expect(find.byType(CachedNetworkImage), findsWidgets);
      });

      testWidgets('should handle different hero IDs',
          (WidgetTester tester) async {
        final widgets = List.generate(
          10,
          (index) => ImageProxyService.buildImage(
            imageUrl: 'invalid-url-$index',
            heroName: 'Hero$index',
            heroId: index,
          ),
        );

        await tester.pumpWidget(MaterialApp(
          home: SingleChildScrollView(child: Column(children: widgets)),
        ));
        await tester.pump();

        expect(find.byType(CachedNetworkImage), findsWidgets);
      });

      testWidgets('should handle negative hero IDs',
          (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: 'invalid-url',
          heroName: 'Test Hero',
          heroId: -1,
        );

        await tester.pumpWidget(MaterialApp(home: widget));
        await tester.pump();

        expect(find.byType(CachedNetworkImage), findsWidgets);
      });

      testWidgets('should handle zero hero ID', (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: 'invalid-url',
          heroName: 'Test Hero',
          heroId: 0,
        );

        await tester.pumpWidget(MaterialApp(home: widget));
        await tester.pump();

        expect(find.byType(CachedNetworkImage), findsWidgets);
      });

      testWidgets('should handle very large hero IDs',
          (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: 'invalid-url',
          heroName: 'Test Hero',
          heroId: 999999,
        );

        await tester.pumpWidget(MaterialApp(home: widget));
        await tester.pump();

        expect(find.byType(CachedNetworkImage), findsWidgets);
      });
    });

    group('Widget dimensions', () {
      testWidgets('should handle null width and height',
          (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: 'https://example.com/test.jpg',
          heroName: 'Test Hero',
          heroId: 1,
          width: null,
          height: null,
        );

        await tester.pumpWidget(MaterialApp(home: widget));

        final cachedNetworkImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );

        expect(cachedNetworkImage.width, isNull);
        expect(cachedNetworkImage.height, isNull);
      });

      testWidgets('should handle only width specified',
          (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: 'https://example.com/test.jpg',
          heroName: 'Test Hero',
          heroId: 1,
          width: 100,
        );

        await tester.pumpWidget(MaterialApp(home: widget));

        final cachedNetworkImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );

        expect(cachedNetworkImage.width, equals(100));
        expect(cachedNetworkImage.height, isNull);
      });

      testWidgets('should handle only height specified',
          (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: 'https://example.com/test.jpg',
          heroName: 'Test Hero',
          heroId: 1,
          height: 150,
        );

        await tester.pumpWidget(MaterialApp(home: widget));

        final cachedNetworkImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );

        expect(cachedNetworkImage.width, isNull);
        expect(cachedNetworkImage.height, equals(150));
      });

      testWidgets('should handle zero dimensions', (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: 'https://example.com/test.jpg',
          heroName: 'Test Hero',
          heroId: 1,
          width: 0,
          height: 0,
        );

        await tester.pumpWidget(MaterialApp(home: widget));

        final cachedNetworkImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );

        expect(cachedNetworkImage.width, equals(0));
        expect(cachedNetworkImage.height, equals(0));
      });

      testWidgets('should handle very large dimensions',
          (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: 'https://example.com/test.jpg',
          heroName: 'Test Hero',
          heroId: 1,
          width: 9999,
          height: 8888,
        );

        await tester.pumpWidget(MaterialApp(home: widget));

        final cachedNetworkImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );

        expect(cachedNetworkImage.width, equals(9999));
        expect(cachedNetworkImage.height, equals(8888));
      });
    });

    group('BoxFit variations', () {
      final boxFitValues = [
        BoxFit.fill,
        BoxFit.contain,
        BoxFit.cover,
        BoxFit.fitWidth,
        BoxFit.fitHeight,
        BoxFit.none,
        BoxFit.scaleDown,
      ];

      for (final boxFit in boxFitValues) {
        testWidgets('should handle BoxFit.$boxFit',
            (WidgetTester tester) async {
          final widget = ImageProxyService.buildImage(
            imageUrl: 'https://example.com/test.jpg',
            heroName: 'Test Hero',
            heroId: 1,
            fit: boxFit,
          );

          await tester.pumpWidget(MaterialApp(home: widget));

          final cachedNetworkImage = tester.widget<CachedNetworkImage>(
            find.byType(CachedNetworkImage),
          );

          expect(cachedNetworkImage.fit, equals(boxFit));
        });
      }
    });

    group('Edge cases', () {
      testWidgets('should handle very long URL', (WidgetTester tester) async {
        final longUrl =
            'https://cdn.superherodb.com/images/' + 'a' * 1000 + '.jpg';
        final widget = ImageProxyService.buildImage(
          imageUrl: longUrl,
          heroName: 'Test Hero',
          heroId: 1,
        );

        await tester.pumpWidget(MaterialApp(home: widget));

        expect(find.byType(CachedNetworkImage), findsOneWidget);
      });

      testWidgets('should handle very long hero name',
          (WidgetTester tester) async {
        final longName = 'Super' + 'long' * 100 + 'HeroName';
        final widget = ImageProxyService.buildImage(
          imageUrl: 'invalid-url',
          heroName: longName,
          heroId: 1,
        );

        await tester.pumpWidget(MaterialApp(home: widget));
        await tester.pump();

        expect(find.byType(CachedNetworkImage), findsWidgets);
      });

      testWidgets('should handle URL with special characters',
          (WidgetTester tester) async {
        const url = 'https://cdn.superherodb.com/images/test%20file%20name.jpg';
        final widget = ImageProxyService.buildImage(
          imageUrl: url,
          heroName: 'Test Hero',
          heroId: 1,
        );

        await tester.pumpWidget(MaterialApp(home: widget));

        final cachedImage =
            tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
        expect(cachedImage.imageUrl, contains('images.weserv.nl'));
      });

      testWidgets('should handle hero name with only special characters',
          (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: 'invalid-url',
          heroName: '@#\$%^&*()',
          heroId: 1,
        );

        await tester.pumpWidget(MaterialApp(home: widget));
        await tester.pump();

        expect(find.byType(CachedNetworkImage), findsWidgets);
      });

      testWidgets('should handle whitespace-only hero name',
          (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: 'invalid-url',
          heroName: '   ',
          heroId: 1,
        );

        await tester.pumpWidget(MaterialApp(home: widget));
        await tester.pump();

        expect(find.byType(CachedNetworkImage), findsWidgets);
      });
    });

    group('Placeholder behavior', () {
      testWidgets('should create shimmer placeholder with correct properties',
          (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: 'https://example.com/loading.jpg',
          heroName: 'Test Hero',
          heroId: 1,
          width: 200,
          height: 150,
        );

        await tester.pumpWidget(MaterialApp(home: widget));

        final cachedNetworkImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );

        final placeholderWidget = cachedNetworkImage.placeholder!(
          tester.element(find.byType(CachedNetworkImage)),
          'test-url',
        );

        expect(placeholderWidget, isA<Shimmer>());
      });

      testWidgets('should handle placeholder without dimensions',
          (WidgetTester tester) async {
        final widget = ImageProxyService.buildImage(
          imageUrl: 'https://example.com/loading.jpg',
          heroName: 'Test Hero',
          heroId: 1,
        );

        await tester.pumpWidget(MaterialApp(home: widget));

        final cachedNetworkImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );

        expect(cachedNetworkImage.placeholder, isNotNull);
      });
    });
  });
}
