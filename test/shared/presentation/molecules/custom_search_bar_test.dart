import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marvel_animation_app/shared/presentation/molecules/custom_search_bar.dart';

void main() {
  group('CustomSearchBar', () {
    late TextEditingController searchController;
    late FocusNode searchFocusNode;

    setUp(() {
      searchController = TextEditingController();
      searchFocusNode = FocusNode();
    });

    tearDown(() {
      searchController.dispose();
      searchFocusNode.dispose();
    });

    Widget createTestWidget({
      TextEditingController? controller,
      FocusNode? focusNode,
    }) {
      return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) {
          return ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: CustomSearchBar(
                  searchController: controller ?? searchController,
                  searchFocusNode: focusNode ?? searchFocusNode,
                ),
              ),
            ),
          );
        },
      );
    }

    testWidgets('should render all basic components', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Row), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(Expanded), findsOneWidget);
      expect(find.byType(ValueListenableBuilder<TextEditingValue>),
          findsOneWidget);

      expect(find.byIcon(Icons.clear), findsNothing);

      expect(
          find.descendant(
            of: find.byType(ValueListenableBuilder<TextEditingValue>),
            matching: find.byType(SizedBox),
          ),
          findsOneWidget);
    });

    testWidgets('should have correct back button properties', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final backIconButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.arrow_back),
      );

      expect(backIconButton.icon, isA<Icon>());
      final icon = backIconButton.icon as Icon;
      expect(icon.icon, equals(Icons.arrow_back));
      expect(icon.color, equals(Colors.white));
    });

    testWidgets('should have correct TextField properties', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final textField = tester.widget<TextField>(find.byType(TextField));

      expect(textField.controller, equals(searchController));
      expect(textField.focusNode, equals(searchFocusNode));
      expect(textField.decoration?.hintText, equals('Search heroes...'));
      expect(textField.decoration?.border, equals(InputBorder.none));
    });

    testWidgets('should clear controller and search when back button is tapped',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      searchController.text = 'Spider';
      await tester.pump();

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pump();

      expect(searchController.text, isEmpty);
    });

    testWidgets('should show clear button when text is added via enterText',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.clear), findsNothing);

      await tester.enterText(find.byType(TextField), 'Iron Man');
      await tester.pump();

      expect(find.byIcon(Icons.clear), findsOneWidget);

      expect(find.byType(IconButton), findsNWidgets(2));
    });

    testWidgets('should hide clear button when text is removed',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField), 'Captain America');
      await tester.pump();
      expect(find.byIcon(Icons.clear), findsOneWidget);
      expect(find.byType(IconButton), findsNWidgets(2));

      await tester.enterText(find.byType(TextField), '');
      await tester.pump();

      expect(find.byIcon(Icons.clear), findsNothing);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('should clear text when clear button is tapped',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField), 'Thor');
      await tester.pump();

      expect(searchController.text, equals('Thor'));
      expect(find.byIcon(Icons.clear), findsOneWidget);
      expect(find.byType(IconButton), findsNWidgets(2));

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      expect(searchController.text, isEmpty);
      expect(find.byIcon(Icons.clear), findsNothing);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('should update search query when text changes', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField), 'Hulk');
      await tester.pump();

      expect(searchController.text, equals('Hulk'));
    });

    testWidgets('should handle focus node correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.focusNode, equals(searchFocusNode));

      searchFocusNode.requestFocus();
      await tester.pump();

      expect(searchFocusNode.hasFocus, isTrue);
    });

    testWidgets('should have correct clear button properties when visible',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField), 'Black Widow');
      await tester.pump();

      final clearIconButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.clear),
      );

      expect(clearIconButton.icon, isA<Icon>());
      final icon = clearIconButton.icon as Icon;
      expect(icon.icon, equals(Icons.clear));
      expect(icon.color, equals(Colors.white));
    });

    testWidgets(
        'should handle multiple text changes with ValueListenableBuilder',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField), 'A');
      await tester.pump();
      expect(searchController.text, equals('A'));
      expect(find.byIcon(Icons.clear), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Av');
      await tester.pump();
      expect(searchController.text, equals('Av'));
      expect(find.byIcon(Icons.clear), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Avengers');
      await tester.pump();
      expect(searchController.text, equals('Avengers'));
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('should work with custom controllers and focus nodes',
        (tester) async {
      final customController = TextEditingController(text: 'Initial text');
      final customFocusNode = FocusNode();

      await tester.pumpWidget(createTestWidget(
        controller: customController,
        focusNode: customFocusNode,
      ));

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller, equals(customController));
      expect(textField.focusNode, equals(customFocusNode));
      expect(customController.text, equals('Initial text'));

      expect(find.byIcon(Icons.clear), findsOneWidget);

      customController.dispose();
      customFocusNode.dispose();
    });

    testWidgets('should handle ValueListenableBuilder state changes correctly',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      final valueListenableBuilder =
          tester.widget<ValueListenableBuilder<TextEditingValue>>(
        find.byType(ValueListenableBuilder<TextEditingValue>),
      );
      expect(valueListenableBuilder.valueListenable, equals(searchController));

      expect(find.byIcon(Icons.clear), findsNothing);
      expect(find.byType(IconButton), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Test');
      await tester.pump();

      expect(find.byIcon(Icons.clear), findsOneWidget);
      expect(find.byType(IconButton), findsNWidgets(2));

      await tester.enterText(find.byType(TextField), '');
      await tester.pump();

      expect(find.byIcon(Icons.clear), findsNothing);
      expect(find.byType(IconButton), findsOneWidget);
    });

    group('layout structure', () {
      testWidgets('should have correct widget hierarchy', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(Row), findsOneWidget);

        final row = tester.widget<Row>(find.byType(Row));
        expect(row.children.length, equals(3));

        expect(row.children[0], isA<IconButton>());
        expect(row.children[1], isA<Expanded>());
        expect(row.children[2], isA<ValueListenableBuilder>());
      });

      testWidgets('should have expanded TextField', (tester) async {
        await tester.pumpWidget(createTestWidget());

        final expanded = tester.widget<Expanded>(find.byType(Expanded));
        expect(expanded.child, isA<TextField>());
      });

      testWidgets('should handle empty and non-empty states in layout',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(IconButton), findsOneWidget);
        expect(find.byIcon(Icons.clear), findsNothing);

        await tester.enterText(find.byType(TextField), 'Doctor Strange');
        await tester.pump();

        expect(find.byType(IconButton), findsNWidgets(2));
        expect(find.byIcon(Icons.clear), findsOneWidget);
      });
    });

    group('text style and decoration', () {
      testWidgets('should have correct hint text styling', (tester) async {
        await tester.pumpWidget(createTestWidget());

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.decoration?.hintText, equals('Search heroes...'));
        expect(textField.decoration?.hintStyle?.color, equals(Colors.white70));
      });

      testWidgets('should have correct text input styling', (tester) async {
        await tester.pumpWidget(createTestWidget());

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.style?.color, equals(Colors.white));
      });

      testWidgets('should have no border decoration', (tester) async {
        await tester.pumpWidget(createTestWidget());

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.decoration?.border, equals(InputBorder.none));
      });
    });

    group('interaction edge cases', () {
      testWidgets('should handle back button with empty text', (tester) async {
        await tester.pumpWidget(createTestWidget());

        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pump();

        expect(searchController.text, isEmpty);
        expect(find.byIcon(Icons.clear), findsNothing);
      });

      testWidgets('should handle long text input', (tester) async {
        await tester.pumpWidget(createTestWidget());

        final longText =
            'This is a very long search query that might test the limits of the search bar and its ValueListenableBuilder';
        await tester.enterText(find.byType(TextField), longText);
        await tester.pump();

        expect(searchController.text, equals(longText));
        expect(find.byIcon(Icons.clear), findsOneWidget);
      });

      testWidgets('should handle rapid text changes', (tester) async {
        await tester.pumpWidget(createTestWidget());

        await tester.enterText(find.byType(TextField), 'Spider-Man');
        await tester.pump();
        expect(find.byIcon(Icons.clear), findsOneWidget);

        await tester.enterText(find.byType(TextField), '');
        await tester.pump();
        expect(find.byIcon(Icons.clear), findsNothing);

        await tester.enterText(find.byType(TextField), 'Iron Man');
        await tester.pump();
        expect(find.byIcon(Icons.clear), findsOneWidget);
      });

      testWidgets('should handle clear button multiple taps', (tester) async {
        await tester.pumpWidget(createTestWidget());

        await tester.enterText(find.byType(TextField), 'Test text');
        await tester.pump();

        expect(find.byIcon(Icons.clear), findsOneWidget);

        await tester.tap(find.byIcon(Icons.clear));
        await tester.pump();

        expect(searchController.text, isEmpty);
        expect(find.byIcon(Icons.clear), findsNothing);

        expect(find.byIcon(Icons.clear), findsNothing);
      });
    });

    group('ValueListenableBuilder behavior', () {
      testWidgets('should rebuild only clear button area when text changes',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        final rowWidget = tester.widget<Row>(find.byType(Row));
        final expandedWidget = tester.widget<Expanded>(find.byType(Expanded));
        final textFieldWidget =
            tester.widget<TextField>(find.byType(TextField));

        await tester.enterText(find.byType(TextField), 'Changing text');
        await tester.pump();

        expect(tester.widget<Row>(find.byType(Row)), equals(rowWidget));
        expect(tester.widget<Expanded>(find.byType(Expanded)),
            equals(expandedWidget));
        expect(tester.widget<TextField>(find.byType(TextField)),
            equals(textFieldWidget));

        expect(find.byIcon(Icons.clear), findsOneWidget);
      });

      testWidgets('should handle controller disposal gracefully',
          (tester) async {
        final testController = TextEditingController(text: 'Test');

        await tester.pumpWidget(createTestWidget(controller: testController));

        expect(find.byIcon(Icons.clear), findsOneWidget);

        testController.dispose();

        await tester.pumpWidget(Container());
      });
    });

    group('accessibility', () {
      testWidgets('should provide semantic information', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(IconButton), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);

        final semantics = tester.getSemantics(find.byType(CustomSearchBar));
        expect(semantics, isNotNull);
      });

      testWidgets('should be accessible for screen readers', (tester) async {
        await tester.pumpWidget(createTestWidget());

        final backButton = find.widgetWithIcon(IconButton, Icons.arrow_back);
        expect(tester.widget<IconButton>(backButton).onPressed, isNotNull);

        await tester.enterText(find.byType(TextField), 'Accessible text');
        await tester.pump();

        final clearButton = find.widgetWithIcon(IconButton, Icons.clear);
        expect(tester.widget<IconButton>(clearButton).onPressed, isNotNull);
      });
    });

    group('error handling', () {
      testWidgets('should handle controller operations gracefully',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(() => searchController.clear(), returnsNormally);
        expect(() => searchController.text = 'Test', returnsNormally);
      });

      testWidgets('should render without crashing', (tester) async {
        expect(
          () => tester.pumpWidget(createTestWidget()),
          returnsNormally,
        );
      });

      testWidgets('should handle focus node operations', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(() => searchFocusNode.requestFocus(), returnsNormally);
        expect(() => searchFocusNode.unfocus(), returnsNormally);
      });

      testWidgets('should handle widget rebuilds correctly', (tester) async {
        await tester.pumpWidget(createTestWidget());

        await tester.enterText(find.byType(TextField), 'Rebuild test');
        await tester.pump();
        expect(find.byIcon(Icons.clear), findsOneWidget);

        await tester.pumpWidget(createTestWidget());

        expect(find.byType(CustomSearchBar), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
        expect(find.byType(ValueListenableBuilder<TextEditingValue>),
            findsOneWidget);
      });
    });
  });
}
