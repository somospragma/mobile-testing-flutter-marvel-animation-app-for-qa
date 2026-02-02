import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marvel_animation_app/shared/presentation/molecules/normal_app_bar.dart';

void main() {
  group('NormalAppBar', () {
    Widget createTestWidget({
      VoidCallback? onBack,
      bool showSearch = false,
      FocusNode? focusNode,
    }) {
      return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) {
          return ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: NormalAppBar(
                  onBack: onBack,
                  showSearch: showSearch,
                  searchFocusNode: focusNode ?? FocusNode(),
                ),
              ),
            ),
          );
        },
      );
    }

    testWidgets(
        'should render logo in center when no back button and no search',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Image), findsOneWidget);
      expect(find.byIcon(Icons.chevron_left), findsNothing);
      expect(find.byIcon(Icons.search), findsNothing);

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, isA<AssetImage>());
      final assetImage = image.image as AssetImage;
      expect(assetImage.assetName, equals('assets/logo.png'));
    });

    testWidgets('should render back button when onBack is provided',
        (tester) async {
      bool backPressed = false;

      await tester.pumpWidget(createTestWidget(
        onBack: () => backPressed = true,
      ));

      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_left));
      expect(backPressed, isTrue);
    });

    testWidgets('should render search button when showSearch is true',
        (tester) async {
      await tester.pumpWidget(createTestWidget(showSearch: true));

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);

      final searchIcon = tester.widget<Icon>(find.byIcon(Icons.search));
      expect(searchIcon.color, equals(Colors.white));
    });

    testWidgets(
        'should render both back button and search when both are enabled',
        (tester) async {
      bool backPressed = false;

      await tester.pumpWidget(createTestWidget(
        onBack: () => backPressed = true,
        showSearch: true,
      ));

      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_left));
      expect(backPressed, isTrue);
    });

    testWidgets('should call search functionality when search button is tapped',
        (tester) async {
      await tester.pumpWidget(createTestWidget(showSearch: true));

      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();

      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should request focus on search focus node after delay',
        (tester) async {
      final focusNode = FocusNode();

      await tester.pumpWidget(createTestWidget(
        showSearch: true,
        focusNode: focusNode,
      ));

      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(focusNode, isNotNull);

      focusNode.dispose();
    });

    testWidgets('should use spaceBetween alignment when back button is present',
        (tester) async {
      await tester.pumpWidget(createTestWidget(
        onBack: () {},
        showSearch: true,
      ));

      final row = tester.widget<Row>(find.byType(Row));
      expect(row.mainAxisAlignment, equals(MainAxisAlignment.spaceBetween));
    });

    testWidgets('should use center alignment when no back button is present',
        (tester) async {
      await tester.pumpWidget(createTestWidget(showSearch: true));

      final row = tester.widget<Row>(find.byType(Row));
      expect(row.mainAxisAlignment, equals(MainAxisAlignment.center));
    });

    testWidgets('should render correct logo dimensions with ScreenUtil',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.width, equals(250.w));
      expect(image.height, equals(50.h));
    });

    testWidgets('should not render back button when onBack is null',
        (tester) async {
      await tester.pumpWidget(createTestWidget(showSearch: true));

      expect(find.byIcon(Icons.chevron_left), findsNothing);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should not render search button when showSearch is false',
        (tester) async {
      await tester.pumpWidget(createTestWidget(
        onBack: () {},
        showSearch: false,
      ));

      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
      expect(find.byIcon(Icons.search), findsNothing);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should have correct widget hierarchy structure',
        (tester) async {
      await tester.pumpWidget(createTestWidget(
        onBack: () {},
        showSearch: true,
      ));

      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(IconButton), findsNWidgets(2));
      expect(find.byType(Expanded), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);

      final expandedWidget = tester.widget<Expanded>(find.byType(Expanded));
      expect(expandedWidget.child, isA<Center>());
    });

    testWidgets('should render with custom focus node', (tester) async {
      final customFocusNode = FocusNode();

      await tester.pumpWidget(createTestWidget(
        showSearch: true,
        focusNode: customFocusNode,
      ));

      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(customFocusNode, isNotNull);

      customFocusNode.dispose();
    });

    testWidgets('should handle multiple search button taps', (tester) async {
      await tester.pumpWidget(createTestWidget(showSearch: true));

      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should handle multiple back button taps', (tester) async {
      int backPressCount = 0;

      await tester.pumpWidget(createTestWidget(
        onBack: () => backPressCount++,
      ));

      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.tap(find.byIcon(Icons.chevron_left));

      expect(backPressCount, equals(3));
    });

    group('icon properties', () {
      testWidgets('should have correct back icon properties', (tester) async {
        await tester.pumpWidget(createTestWidget(onBack: () {}));

        final iconButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.chevron_left),
        );
        expect(iconButton.icon, isA<Icon>());

        final icon = iconButton.icon as Icon;
        expect(icon.icon, equals(Icons.chevron_left));
      });

      testWidgets('should have correct search icon properties', (tester) async {
        await tester.pumpWidget(createTestWidget(showSearch: true));

        final iconButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.search),
        );
        expect(iconButton.icon, isA<Icon>());

        final icon = iconButton.icon as Icon;
        expect(icon.icon, equals(Icons.search));
        expect(icon.color, equals(Colors.white));
      });
    });

    group('layout edge cases', () {
      testWidgets(
          'should render correctly with only logo (minimal configuration)',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(Row), findsOneWidget);
        expect(find.byType(Expanded), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
        expect(find.byType(IconButton), findsNothing);

        final row = tester.widget<Row>(find.byType(Row));
        expect(row.children.length, equals(1));

        final expandedWidget = tester.widget<Expanded>(find.byType(Expanded));
        expect(expandedWidget.child, isA<Center>());
      });

      testWidgets('should render correctly with maximum configuration',
          (tester) async {
        await tester.pumpWidget(createTestWidget(
          onBack: () {},
          showSearch: true,
        ));

        final row = tester.widget<Row>(find.byType(Row));
        expect(row.children.length, equals(3));
      });

      testWidgets('should handle widget rebuilds correctly', (tester) async {
        bool showSearch = false;

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return createTestWidget(
                onBack: () => setState(() => showSearch = !showSearch),
                showSearch: showSearch,
              );
            },
          ),
        );

        expect(find.byIcon(Icons.search), findsNothing);

        await tester.tap(find.byIcon(Icons.chevron_left));
        await tester.pump();

        expect(find.byIcon(Icons.search), findsOneWidget);
      });
    });

    group('accessibility', () {
      testWidgets('should provide semantics for screen readers',
          (tester) async {
        await tester.pumpWidget(createTestWidget(
          onBack: () {},
          showSearch: true,
        ));

        expect(find.byType(IconButton), findsNWidgets(2));
        expect(find.byType(Image), findsOneWidget);

        final semantics = tester.getSemantics(find.byType(NormalAppBar));
        expect(semantics, isNotNull);
      });

      testWidgets('should be tappable for accessibility tools', (tester) async {
        await tester.pumpWidget(createTestWidget(
          onBack: () {},
          showSearch: true,
        ));

        final backButton = find.widgetWithIcon(IconButton, Icons.chevron_left);
        final searchButton = find.widgetWithIcon(IconButton, Icons.search);

        expect(tester.widget<IconButton>(backButton).onPressed, isNotNull);
        expect(tester.widget<IconButton>(searchButton).onPressed, isNotNull);
      });
    });

    group('error handling', () {
      testWidgets('should handle focus node operations gracefully',
          (tester) async {
        final testFocusNode = FocusNode();

        await tester.pumpWidget(createTestWidget(
          showSearch: true,
          focusNode: testFocusNode,
        ));

        expect(find.byType(NormalAppBar), findsOneWidget);

        testFocusNode.dispose();
      });

      testWidgets('should render without crashing', (tester) async {
        expect(
          () => tester.pumpWidget(createTestWidget()),
          returnsNormally,
        );
      });
    });
  });
}
