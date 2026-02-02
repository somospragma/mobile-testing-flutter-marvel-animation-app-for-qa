import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marvel_animation_app/shared/presentation/pages/loading_page.dart';
import 'package:marvel_animation_app/shared/presentation/tokens/tokens.dart';

void main() {
  group('LoadingPage', () {
    testWidgets('should render without errors', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoadingPage()));

      expect(find.byType(LoadingPage), findsOneWidget);
    });

    testWidgets('should display scaffold', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoadingPage()));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should display circular progress indicator', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoadingPage()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should have container with correct alignment', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoadingPage()));

      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);

      final container = tester.widget<Container>(containerFinder);
      expect(container.alignment, equals(Alignment.center));
    });

    testWidgets('should have container with correct background color',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoadingPage()));

      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);

      final container = tester.widget<Container>(containerFinder);
      expect(container.color, equals(CustomColor.BRAND_PRIMARY_02));
    });

    testWidgets('should have correct widget hierarchy', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoadingPage()));

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.body, isA<Container>());
    });

    testWidgets('should center progress indicator in screen', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoadingPage()));

      final containerFinder = find.byType(Container);
      final container = tester.widget<Container>(containerFinder);

      expect(container.alignment, equals(Alignment.center));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should have proper key when provided', (tester) async {
      const testKey = Key('loading_page_key');
      await tester.pumpWidget(const MaterialApp(
        home: LoadingPage(key: testKey),
      ));

      expect(find.byKey(testKey), findsOneWidget);
    });

    testWidgets('should maintain state after rebuild', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoadingPage()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('should work within different parent widgets', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                const Expanded(child: LoadingPage()),
                Container(height: 50),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(LoadingPage), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should have circular progress indicator as child of container',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoadingPage()));

      final containerFinder = find.byType(Container);
      final container = tester.widget<Container>(containerFinder);

      expect(container.child, isA<CircularProgressIndicator>());
    });

    testWidgets('should display loading animation', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoadingPage()));

      final progressIndicator = find.byType(CircularProgressIndicator);
      expect(progressIndicator, findsOneWidget);

      await tester.pump(const Duration(milliseconds: 100));
      expect(progressIndicator, findsOneWidget);
    });
  });
}
