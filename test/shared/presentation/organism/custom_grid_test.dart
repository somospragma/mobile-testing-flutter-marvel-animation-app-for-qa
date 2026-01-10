import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marvel_animation_app/shared/domain/models/item_model.dart';
import 'package:marvel_animation_app/shared/presentation/molecules/custom_card.dart';
import 'package:marvel_animation_app/shared/presentation/organism/custom_grid.dart';
import 'package:marvel_animation_app/shared/presentation/tokens/tokens.dart';

void main() {
  group('CustomGrid', () {
    late ScrollController scrollController;
    late List<ItemModel> testItems;
    late bool cardPressedCalled;
    late bool cardActionCalled;
    late ItemModel? pressedItem;
    late BuildContext? pressedContext;

    setUp(() {
      scrollController = ScrollController();
      cardPressedCalled = false;
      cardActionCalled = false;
      pressedItem = null;
      pressedContext = null;

      testItems = [
        ItemModel(
          id: 1,
          title: 'Test Hero 1',
          subtitle: 'Test subtitle 1',
          imageUrl: 'https://test.com/image1.jpg',
          buttonText: 'Action 1',
        ),
        ItemModel(
          id: 2,
          title: 'Test Hero 2',
          subtitle: 'Test subtitle 2',
          imageUrl: 'https://test.com/image2.jpg',
          buttonText: 'Action 2',
        ),
      ];
    });

    tearDown(() {
      scrollController.dispose();
    });

    Widget createTestWidget({List<ItemModel>? items}) {
      return ProviderScope(
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          child: MaterialApp(
            home: Scaffold(
              body: CustomGrid(
                items: items ?? testItems,
                controller: scrollController,
                cardPressed: (item, context) {
                  cardPressedCalled = true;
                  pressedItem = item;
                  pressedContext = context;
                },
                cardAction: () {
                  cardActionCalled = true;
                },
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('should render without errors', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.byType(CustomGrid), findsOneWidget);
    });

    testWidgets('should display padding with correct horizontal spacing',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      final customGrid = find.byType(CustomGrid);
      expect(customGrid, findsOneWidget);

      final paddingWidgets = find.descendant(
        of: customGrid,
        matching: find.byType(Padding),
      );
      expect(paddingWidgets, findsWidgets);
    });

    testWidgets('should display grid view with correct properties',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      final gridViewFinder = find.byType(GridView);
      expect(gridViewFinder, findsOneWidget);

      final gridView = tester.widget<GridView>(gridViewFinder);
      expect(gridView.controller, equals(scrollController));
      expect(gridView.shrinkWrap, isTrue);
    });

    testWidgets('should have correct grid delegate configuration',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      final gridViewFinder = find.byType(GridView);
      final gridView = tester.widget<GridView>(gridViewFinder);

      final delegate =
          gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, equals(2));
      expect(delegate.crossAxisSpacing, equals(15));
      expect(delegate.mainAxisSpacing, equals(15));
      expect(delegate.childAspectRatio, equals(0.7));
    });

    testWidgets('should display correct number of items', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CustomCard), findsNWidgets(2));
    });

    testWidgets('should display custom cards for each item', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final customCards = find.byType(CustomCard);
      expect(customCards, findsNWidgets(testItems.length));

      for (int i = 0; i < testItems.length; i++) {
        final cardWidget = tester.widget<CustomCard>(customCards.at(i));
        expect(cardWidget.item, equals(testItems[i]));
      }
    });

    testWidgets('should handle empty items list', (tester) async {
      await tester.pumpWidget(createTestWidget(items: []));

      expect(find.byType(CustomCard), findsNothing);
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('should handle single item', (tester) async {
      final singleItem = [testItems.first];
      await tester.pumpWidget(createTestWidget(items: singleItem));

      expect(find.byType(CustomCard), findsOneWidget);
    });

    testWidgets('should handle large number of items', (tester) async {
      final manyItems = List.generate(
          20,
          (index) => ItemModel(
                id: index,
                title: 'Hero $index',
                subtitle: 'Subtitle $index',
                imageUrl: 'https://test.com/image$index.jpg',
                buttonText: 'Action $index',
              ));

      await tester.pumpWidget(createTestWidget(items: manyItems));

      expect(find.byType(CustomCard), findsWidgets);
    });

    testWidgets('should pass correct scroll controller to GridView',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      final gridView = tester.widget<GridView>(find.byType(GridView));
      expect(gridView.controller, same(scrollController));
    });

    testWidgets('should call cardPressed callback with correct parameters',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.byType(CustomCard).first);
      await tester.pump();

      expect(cardPressedCalled, isTrue);
      expect(pressedItem, equals(testItems.first));
      expect(pressedContext, isNotNull);
    });

    testWidgets('should call cardAction callback', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final customCard = find.byType(CustomCard).first;
      final cardWidget = tester.widget<CustomCard>(customCard);

      cardWidget.cardAction();

      expect(cardActionCalled, isTrue);
    });

    testWidgets('should pass cardAction to each CustomCard', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final customCards = find.byType(CustomCard);

      for (int i = 0; i < testItems.length; i++) {
        final cardWidget = tester.widget<CustomCard>(customCards.at(i));
        expect(cardWidget.cardAction, isNotNull);
      }
    });

    testWidgets('should maintain scroll position', (tester) async {
      final manyItems = List.generate(
          50,
          (index) => ItemModel(
                id: index,
                title: 'Hero $index',
                subtitle: 'Subtitle $index',
                imageUrl: 'https://test.com/image$index.jpg',
                buttonText: 'Action $index',
              ));

      await tester.pumpWidget(createTestWidget(items: manyItems));

      await tester.fling(find.byType(GridView), const Offset(0, -300), 1000);
      await tester.pump();

      expect(scrollController.offset, greaterThan(0));
    });

    testWidgets('should create correct number of CustomCards', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CustomCard), findsNWidgets(testItems.length));

      for (int i = 0; i < testItems.length; i++) {
        expect(find.byType(CustomCard).at(i), findsOneWidget);
      }
    });

    testWidgets('should work with different item types', (tester) async {
      final differentItems = [
        ItemModel(
          id: 999,
          title: 'Very Long Title That Should Be Handled Properly',
          subtitle: 'Very long subtitle that might cause overflow issues',
          imageUrl: 'https://example.com/very-long-url-name.jpg',
          buttonText: 'Long Button Text',
        ),
        ItemModel(
          id: 0,
          title: '',
          subtitle: '',
          imageUrl: '',
          buttonText: '',
        ),
      ];

      await tester.pumpWidget(createTestWidget(items: differentItems));

      expect(find.byType(CustomCard), findsNWidgets(2));
    });

    testWidgets('should handle rebuild correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CustomCard), findsNWidgets(2));

      await tester.pumpWidget(createTestWidget(items: [testItems.first]));

      expect(find.byType(CustomCard), findsOneWidget);
    });
  });
}
