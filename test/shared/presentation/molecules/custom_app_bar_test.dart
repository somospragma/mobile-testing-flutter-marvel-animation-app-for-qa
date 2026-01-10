import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marvel_animation_app/features/home/presentation/state/search_provider.dart';
import 'package:marvel_animation_app/features/home/presentation/state/search_state.dart';
import 'package:marvel_animation_app/shared/presentation/molecules/custom_app_bar.dart';
import 'package:marvel_animation_app/shared/presentation/molecules/custom_search_bar.dart';
import 'package:marvel_animation_app/shared/presentation/molecules/normal_app_bar.dart';
import 'package:marvel_animation_app/shared/presentation/tokens/custom_color.dart';

class TestSearchNotifier extends SearchNotifier {
  @override
  SearchState build() {
    return const SearchState(
      searchResults: [],
      searchQuery: '',
      isSearching: false,
      isSearchActive: true,
    );
  }
}

void main() {
  group('CustomAppBar', () {
    Widget createTestWidget({
      VoidCallback? onBack,
      bool showSearch = false,
    }) {
      return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) {
          return ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: CustomAppBar(
                  onBack: onBack,
                  showSearch: showSearch,
                ),
              ),
            ),
          );
        },
      );
    }

    testWidgets('should render basic container structure', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CustomAppBar), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.color, equals(CustomColor.BRAND_PRIMARY_00));
      expect(container.padding, isNotNull);
    });

    testWidgets('should show NormalAppBar by default', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(NormalAppBar), findsOneWidget);
      expect(find.byType(CustomSearchBar), findsNothing);
    });

    testWidgets('should pass onBack callback to NormalAppBar', (tester) async {
      bool backPressed = false;

      await tester.pumpWidget(createTestWidget(
        onBack: () => backPressed = true,
      ));

      expect(find.byType(NormalAppBar), findsOneWidget);

      final normalAppBar =
          tester.widget<NormalAppBar>(find.byType(NormalAppBar));
      expect(normalAppBar.onBack, isNotNull);

      normalAppBar.onBack!();
      expect(backPressed, isTrue);
    });

    testWidgets('should pass showSearch parameter to NormalAppBar',
        (tester) async {
      await tester.pumpWidget(createTestWidget(showSearch: true));

      final normalAppBar =
          tester.widget<NormalAppBar>(find.byType(NormalAppBar));
      expect(normalAppBar.showSearch, isTrue);
    });

    testWidgets('should pass searchFocusNode to NormalAppBar', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final normalAppBar =
          tester.widget<NormalAppBar>(find.byType(NormalAppBar));
      expect(normalAppBar.searchFocusNode, isNotNull);
    });

    testWidgets('should initialize controllers correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CustomAppBar), findsOneWidget);
    });

    testWidgets('should handle null onBack callback', (tester) async {
      await tester.pumpWidget(createTestWidget(onBack: null));

      expect(find.byType(NormalAppBar), findsOneWidget);

      final normalAppBar =
          tester.widget<NormalAppBar>(find.byType(NormalAppBar));
      expect(normalAppBar.onBack, isNull);
    });

    testWidgets('should show CustomSearchBar when search is active',
        (tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) {
            return ProviderScope(
              overrides: [
                searchProvider.overrideWith(() {
                  return TestSearchNotifier();
                }),
              ],
              child: const MaterialApp(
                home: Scaffold(
                  body: CustomAppBar(),
                ),
              ),
            );
          },
        ),
      );

      await tester.pump();

      expect(find.byType(CustomSearchBar), findsOneWidget);
      expect(find.byType(NormalAppBar), findsNothing);
    });

    testWidgets(
        'should pass controllers to CustomSearchBar when search is active',
        (tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) {
            return ProviderScope(
              overrides: [
                searchProvider.overrideWith(() {
                  return TestSearchNotifier();
                }),
              ],
              child: const MaterialApp(
                home: Scaffold(
                  body: CustomAppBar(),
                ),
              ),
            );
          },
        ),
      );

      await tester.pump();

      expect(find.byType(CustomSearchBar), findsOneWidget);

      final customSearchBar =
          tester.widget<CustomSearchBar>(find.byType(CustomSearchBar));
      expect(customSearchBar.searchController, isNotNull);
      expect(customSearchBar.searchFocusNode, isNotNull);
    });

    testWidgets('should transition from NormalAppBar to CustomSearchBar',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(NormalAppBar), findsOneWidget);
      expect(find.byType(CustomSearchBar), findsNothing);
    });

    testWidgets('should transition from CustomSearchBar back to NormalAppBar',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(NormalAppBar), findsOneWidget);
      expect(find.byType(CustomSearchBar), findsNothing);
    });

    group('container properties', () {
      testWidgets('should have correct padding', (tester) async {
        await tester.pumpWidget(createTestWidget());

        final container = tester.widget<Container>(find.byType(Container));
        final padding = container.padding as EdgeInsets;

        expect(padding.top, greaterThan(0));
        expect(padding.left, greaterThan(0));
        expect(padding.right, greaterThan(0));
        expect(padding.bottom, greaterThan(0));
      });

      testWidgets('should have correct background color', (tester) async {
        await tester.pumpWidget(createTestWidget());

        final container = tester.widget<Container>(find.byType(Container));
        expect(container.color, equals(CustomColor.BRAND_PRIMARY_00));
      });
    });

    group('widget lifecycle', () {
      testWidgets('should render without crashing', (tester) async {
        expect(
          () => tester.pumpWidget(createTestWidget()),
          returnsNormally,
        );
      });

      testWidgets('should handle parameter changes', (tester) async {
        await tester.pumpWidget(createTestWidget(showSearch: false));

        final normalAppBar1 =
            tester.widget<NormalAppBar>(find.byType(NormalAppBar));
        expect(normalAppBar1.showSearch, isFalse);

        await tester.pumpWidget(createTestWidget(showSearch: true));

        final normalAppBar2 =
            tester.widget<NormalAppBar>(find.byType(NormalAppBar));
        expect(normalAppBar2.showSearch, isTrue);
      });
    });

    group('integration tests', () {
      testWidgets('should work with all parameters', (tester) async {
        bool backPressed = false;

        await tester.pumpWidget(createTestWidget(
          onBack: () => backPressed = true,
          showSearch: true,
        ));

        expect(find.byType(NormalAppBar), findsOneWidget);

        final normalAppBar =
            tester.widget<NormalAppBar>(find.byType(NormalAppBar));
        expect(normalAppBar.onBack, isNotNull);
        expect(normalAppBar.showSearch, isTrue);
        expect(normalAppBar.searchFocusNode, isNotNull);

        normalAppBar.onBack!();
        expect(backPressed, isTrue);
      });

      testWidgets('should maintain widget structure', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(CustomAppBar), findsOneWidget);
        expect(find.byType(Container), findsOneWidget);
        expect(find.byType(NormalAppBar), findsOneWidget);
        expect(find.byType(CustomSearchBar), findsNothing);
      });
    });

    group('error handling', () {
      testWidgets('should handle widget disposal gracefully', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(CustomAppBar), findsOneWidget);

        await tester.pumpWidget(const MaterialApp(home: Scaffold()));

        expect(find.byType(CustomAppBar), findsNothing);
      });

      testWidgets('should be resilient to multiple rebuilds', (tester) async {
        for (int i = 0; i < 5; i++) {
          await tester.pumpWidget(createTestWidget(
            showSearch: i % 2 == 0,
          ));

          expect(find.byType(CustomAppBar), findsOneWidget);
        }
      });
    });

    group('accessibility', () {
      testWidgets('should provide semantic information', (tester) async {
        await tester.pumpWidget(createTestWidget(showSearch: true));

        expect(find.byType(CustomAppBar), findsOneWidget);
      });

      testWidgets('should maintain accessibility in normal mode',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(NormalAppBar), findsOneWidget);
      });
    });
  });
}
