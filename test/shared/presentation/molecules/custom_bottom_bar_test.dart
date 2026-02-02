import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marvel_animation_app/shared/presentation/molecules/custom_bottom_bar.dart';
import 'package:marvel_animation_app/shared/presentation/state/navigation_provider.dart';
import 'package:marvel_animation_app/shared/presentation/tokens/tokens.dart';

void main() {
  group('CustomBottomBar', () {
    Widget createTestWidget() {
      return ProviderScope(
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          child: MaterialApp(
            home: Scaffold(
              body: const CustomBottomBar(),
            ),
          ),
        ),
      );
    }

    testWidgets('should render without errors', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.byType(CustomBottomBar), findsOneWidget);
    });

    testWidgets('should display container with correct properties',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      final containerFinder = find
          .descendant(
            of: find.byType(CustomBottomBar),
            matching: find.byType(Container),
          )
          .first;

      expect(containerFinder, findsOneWidget);

      final container = tester.widget<Container>(containerFinder);
      expect(container.color, equals(CustomColor.BRAND_PRIMARY_00));
    });

    testWidgets('should display row with correct alignment', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final rowFinder = find.byType(Row);
      expect(rowFinder, findsOneWidget);

      final row = tester.widget<Row>(rowFinder);
      expect(row.mainAxisAlignment, equals(MainAxisAlignment.spaceEvenly));
    });

    testWidgets('should display two gesture detectors', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(GestureDetector), findsNWidgets(2));
    });

    testWidgets('should display correct icons', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.movie), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);

      final movieIcon = tester.widget<Icon>(find.byIcon(Icons.movie));
      final personIcon = tester.widget<Icon>(find.byIcon(Icons.person));

      expect(movieIcon.size, equals(Spacing.SPACE_L));
      expect(movieIcon.color, equals(CustomColor.BRAND_PRIMARY_02));
      expect(personIcon.size, equals(Spacing.SPACE_L));
      expect(personIcon.color, equals(CustomColor.BRAND_PRIMARY_02));
    });

    testWidgets('should display correct text labels', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Characters'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      final charactersText = tester.widget<Text>(find.text('Characters'));
      final profileText = tester.widget<Text>(find.text('Profile'));

      expect(charactersText.style,
          equals(CustomTextStyle.FONT_STYLE_SECONDARY_BUTTON));
      expect(profileText.style,
          equals(CustomTextStyle.FONT_STYLE_SECONDARY_BUTTON));
    });

    testWidgets('should have correct widget structure', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Column), findsNWidgets(2));
      expect(find.byType(GestureDetector), findsNWidgets(2));
      expect(find.byType(Icon), findsNWidgets(2));
      expect(find.byType(Text), findsNWidgets(2));
    });

    testWidgets('should call setIndex(0) when characters tab is tapped',
        (tester) async {
      final container = ProviderContainer();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            child: MaterialApp(
              home: Scaffold(
                body: const CustomBottomBar(),
              ),
            ),
          ),
        ),
      );

      final initialIndex = container.read(navigationProvider);
      expect(initialIndex, equals(0));

      container.read(navigationProvider.notifier).setIndex(2);
      expect(container.read(navigationProvider), equals(2));

      await tester.tap(find.byIcon(Icons.movie));
      await tester.pump();

      expect(container.read(navigationProvider), equals(0));

      container.dispose();
    });

    testWidgets('should call setIndex(1) when profile tab is tapped',
        (tester) async {
      final container = ProviderContainer();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            child: MaterialApp(
              home: Scaffold(
                body: const CustomBottomBar(),
              ),
            ),
          ),
        ),
      );

      expect(container.read(navigationProvider), equals(0));

      await tester.tap(find.byIcon(Icons.person));
      await tester.pump();

      expect(container.read(navigationProvider), equals(1));

      container.dispose();
    });

    testWidgets('should tap on characters tab correctly', (tester) async {
      final container = ProviderContainer();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            child: MaterialApp(
              home: Scaffold(
                body: const CustomBottomBar(),
              ),
            ),
          ),
        ),
      );

      container.read(navigationProvider.notifier).setIndex(2);
      expect(container.read(navigationProvider), equals(2));

      await tester.tap(find.text('Characters'), warnIfMissed: false);
      await tester.pump();

      expect(container.read(navigationProvider), equals(0));

      container.dispose();
    });

    testWidgets('should tap on profile tab correctly', (tester) async {
      final container = ProviderContainer();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            child: MaterialApp(
              home: Scaffold(
                body: const CustomBottomBar(),
              ),
            ),
          ),
        ),
      );

      expect(container.read(navigationProvider), equals(0));

      await tester.tap(find.text('Profile'), warnIfMissed: false);
      await tester.pump();

      expect(container.read(navigationProvider), equals(1));

      container.dispose();
    });

    testWidgets('should have columns with correct children', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final columns = find.byType(Column);
      expect(columns, findsNWidgets(2));

      final charactersColumn = find.ancestor(
        of: find.text('Characters'),
        matching: find.byType(Column),
      );
      expect(charactersColumn, findsOneWidget);

      final profileColumn = find.ancestor(
        of: find.text('Profile'),
        matching: find.byType(Column),
      );
      expect(profileColumn, findsOneWidget);
    });

    testWidgets('should maintain state after multiple taps', (tester) async {
      final container = ProviderContainer();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            child: MaterialApp(
              home: Scaffold(
                body: const CustomBottomBar(),
              ),
            ),
          ),
        ),
      );

      expect(container.read(navigationProvider), equals(0));

      await tester.tap(find.byIcon(Icons.person));
      await tester.pump();
      expect(container.read(navigationProvider), equals(1));

      await tester.tap(find.byIcon(Icons.movie));
      await tester.pump();
      expect(container.read(navigationProvider), equals(0));

      await tester.tap(find.byIcon(Icons.person));
      await tester.pump();
      expect(container.read(navigationProvider), equals(1));

      container.dispose();
    });

    testWidgets('should work within different parent widgets', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            child: MaterialApp(
              home: Scaffold(
                body: Column(
                  children: [
                    const Expanded(child: SizedBox()),
                    const CustomBottomBar(),
                    Container(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CustomBottomBar), findsOneWidget);
      expect(find.byIcon(Icons.movie), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });
  });
}
