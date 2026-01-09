import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marvel_animation_app/shared/presentation/widgets/stat_bar_widget.dart';

void main() {
  group('StatBarWidget', () {
    testWidgets('should build with required parameters',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          child: MaterialApp(
            home: Scaffold(
              body: StatBarWidget(
                label: 'Strength',
                value: 75,
                color: Colors.red,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(StatBarWidget), findsOneWidget);
      expect(find.text('Strength'), findsOneWidget);
      expect(find.text('75'), findsOneWidget);
    });

    testWidgets('should display correct label text',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          child: MaterialApp(
            home: Scaffold(
              body: StatBarWidget(
                label: 'Intelligence',
                value: 90,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Intelligence'), findsOneWidget);
    });

    testWidgets('should display correct value text',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          child: MaterialApp(
            home: Scaffold(
              body: StatBarWidget(
                label: 'Speed',
                value: 50,
                color: Colors.green,
              ),
            ),
          ),
        ),
      );

      expect(find.text('50'), findsOneWidget);
    });

    testWidgets('should have correct widget structure',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          child: MaterialApp(
            home: Scaffold(
              body: StatBarWidget(
                label: 'Test',
                value: 25,
                color: Colors.orange,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(StatBarWidget), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(2));
      expect(find.byType(Expanded), findsOneWidget);
      expect(find.byType(Container), findsAtLeast(2));
      expect(find.byType(FractionallySizedBox), findsOneWidget);

      expect(find.text('Test'), findsOneWidget);
      expect(find.text('25'), findsOneWidget);
    });

    testWidgets('should apply correct color to progress bar and value text',
        (WidgetTester tester) async {
      const testColor = Colors.purple;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          child: MaterialApp(
            home: Scaffold(
              body: StatBarWidget(
                label: 'Durability',
                value: 80,
                color: testColor,
              ),
            ),
          ),
        ),
      );

      final valueText = tester.widget<Text>(
        find.text('80'),
      );
      expect(valueText.style?.color, equals(testColor));

      final progressContainer = tester.widget<Container>(
        find.byType(Container).last,
      );
      final decoration = progressContainer.decoration as BoxDecoration;
      expect(decoration.color, equals(testColor));
    });

    group('Value handling', () {
      testWidgets('should handle zero value', (WidgetTester tester) async {
        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(360, 690),
            child: MaterialApp(
              home: Scaffold(
                body: StatBarWidget(
                  label: 'Zero',
                  value: 0,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        );

        expect(find.text('0'), findsOneWidget);

        final fractionallySizedBox = tester.widget<FractionallySizedBox>(
          find.byType(FractionallySizedBox),
        );
        expect(fractionallySizedBox.widthFactor, equals(0.0));
      });

      testWidgets('should handle maximum value (100)',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(360, 690),
            child: MaterialApp(
              home: Scaffold(
                body: StatBarWidget(
                  label: 'Maximum',
                  value: 100,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        );

        expect(find.text('100'), findsOneWidget);

        final fractionallySizedBox = tester.widget<FractionallySizedBox>(
          find.byType(FractionallySizedBox),
        );
        expect(fractionallySizedBox.widthFactor, equals(1.0));
      });

      testWidgets('should handle values at maximum (100)',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(360, 690),
            child: MaterialApp(
              home: Scaffold(
                body: StatBarWidget(
                  label: 'Over',
                  value: 100,
                  color: Colors.amber,
                ),
              ),
            ),
          ),
        );

        expect(find.text('100'), findsOneWidget);

        final fractionallySizedBox = tester.widget<FractionallySizedBox>(
          find.byType(FractionallySizedBox),
        );
        expect(fractionallySizedBox.widthFactor, equals(1.0));
      });

      testWidgets('should validate that negative values are not allowed',
          (WidgetTester tester) async {
        expect(
          () => StatBarWidget(
            label: 'Negative',
            value: -25,
            color: Colors.red,
          ),
          throwsAssertionError,
        );
      });

      testWidgets('should handle mid-range values correctly',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(360, 690),
            child: MaterialApp(
              home: Scaffold(
                body: StatBarWidget(
                  label: 'Mid',
                  value: 33,
                  color: Colors.teal,
                ),
              ),
            ),
          ),
        );

        expect(find.text('33'), findsOneWidget);

        final fractionallySizedBox = tester.widget<FractionallySizedBox>(
          find.byType(FractionallySizedBox),
        );
        expect(fractionallySizedBox.widthFactor, equals(0.33));
      });
    });

    group('Label variations', () {
      testWidgets('should handle empty label', (WidgetTester tester) async {
        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(360, 690),
            child: MaterialApp(
              home: Scaffold(
                body: StatBarWidget(
                  label: '',
                  value: 45,
                  color: Colors.indigo,
                ),
              ),
            ),
          ),
        );

        expect(find.text(''), findsOneWidget);
        expect(find.text('45'), findsOneWidget);
      });

      testWidgets('should handle long label', (WidgetTester tester) async {
        const longLabel = 'Very Long Stat Label Name';

        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(360, 690),
            child: MaterialApp(
              home: Scaffold(
                body: StatBarWidget(
                  label: longLabel,
                  value: 65,
                  color: Colors.cyan,
                ),
              ),
            ),
          ),
        );

        expect(find.text(longLabel), findsOneWidget);
      });

      testWidgets('should handle special characters in label',
          (WidgetTester tester) async {
        const specialLabel = 'Str@ng#h & P0w3r!';

        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(360, 690),
            child: MaterialApp(
              home: Scaffold(
                body: StatBarWidget(
                  label: specialLabel,
                  value: 88,
                  color: Colors.lime,
                ),
              ),
            ),
          ),
        );

        expect(find.text(specialLabel), findsOneWidget);
      });

      testWidgets('should handle unicode characters in label',
          (WidgetTester tester) async {
        const unicodeLabel = 'Fuerza ⚡ 力量 🔥';

        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(360, 690),
            child: MaterialApp(
              home: Scaffold(
                body: StatBarWidget(
                  label: unicodeLabel,
                  value: 95,
                  color: Colors.deepOrange,
                ),
              ),
            ),
          ),
        );

        expect(find.text(unicodeLabel), findsOneWidget);
      });
    });

    group('Color variations', () {
      final testColors = [
        Colors.red,
        Colors.blue,
        Colors.green,
        Colors.yellow,
        Colors.purple,
        Colors.orange,
        Colors.pink,
        Colors.teal,
        Colors.indigo,
        Colors.cyan,
      ];

      for (int i = 0; i < testColors.length; i++) {
        testWidgets('should handle color: ${testColors[i]}',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            ScreenUtilInit(
              designSize: const Size(360, 690),
              child: MaterialApp(
                home: Scaffold(
                  body: StatBarWidget(
                    label: 'Color Test $i',
                    value: 50 + i,
                    color: testColors[i],
                  ),
                ),
              ),
            ),
          );

          final valueText = tester.widget<Text>(
            find.text('${50 + i}'),
          );
          expect(valueText.style?.color, equals(testColors[i]));
        });
      }

      testWidgets('should handle custom color with opacity',
          (WidgetTester tester) async {
        final customColor = Colors.red.withOpacity(0.7);

        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(360, 690),
            child: MaterialApp(
              home: Scaffold(
                body: StatBarWidget(
                  label: 'Custom',
                  value: 42,
                  color: customColor,
                ),
              ),
            ),
          ),
        );

        final valueText = tester.widget<Text>(
          find.text('42'),
        );
        expect(valueText.style?.color, equals(customColor));
      });

      testWidgets('should handle Colors.transparent',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(360, 690),
            child: MaterialApp(
              home: Scaffold(
                body: StatBarWidget(
                  label: 'Transparent',
                  value: 30,
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        );

        final valueText = tester.widget<Text>(
          find.text('30'),
        );
        expect(valueText.style?.color, equals(Colors.transparent));
      });
    });

    group('Widget styling and layout', () {
      testWidgets('should have correct text styles',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(360, 690),
            child: MaterialApp(
              home: Scaffold(
                body: StatBarWidget(
                  label: 'Style Test',
                  value: 77,
                  color: Colors.brown,
                ),
              ),
            ),
          ),
        );

        final labelText = tester.widget<Text>(find.text('Style Test'));
        expect(labelText.style?.fontWeight, equals(FontWeight.w500));

        final valueText = tester.widget<Text>(find.text('77'));
        expect(valueText.style?.fontWeight, equals(FontWeight.bold));
        expect(valueText.style?.color, equals(Colors.brown));
      });

      testWidgets('should have correct container styling',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(360, 690),
            child: MaterialApp(
              home: Scaffold(
                body: StatBarWidget(
                  label: 'Container Test',
                  value: 60,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ),
        );

        final backgroundContainer = tester.widget<Container>(
          find.byType(Container).first,
        );
        final backgroundDecoration =
            backgroundContainer.decoration as BoxDecoration;
        expect(backgroundDecoration.color, equals(Colors.grey[300]));
        expect(backgroundDecoration.borderRadius, isNotNull);

        final progressContainer = tester.widget<Container>(
          find.byType(Container).last,
        );
        final progressDecoration =
            progressContainer.decoration as BoxDecoration;
        expect(progressDecoration.color, equals(Colors.deepPurple));
        expect(progressDecoration.borderRadius, isNotNull);
      });

      testWidgets('should have correct FractionallySizedBox alignment',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(360, 690),
            child: MaterialApp(
              home: Scaffold(
                body: StatBarWidget(
                  label: 'Alignment Test',
                  value: 85,
                  color: Colors.teal,
                ),
              ),
            ),
          ),
        );

        final fractionallySizedBox = tester.widget<FractionallySizedBox>(
          find.byType(FractionallySizedBox),
        );
        expect(fractionallySizedBox.alignment, equals(Alignment.centerLeft));
      });
    });

    group('Edge cases', () {
      testWidgets('should handle edge case values around maximum',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(360, 690),
            child: MaterialApp(
              home: Scaffold(
                body: StatBarWidget(
                  label: 'Large',
                  value: 99,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        );

        expect(find.text('99'), findsOneWidget);

        final fractionallySizedBox = tester.widget<FractionallySizedBox>(
          find.byType(FractionallySizedBox),
        );
        expect(fractionallySizedBox.widthFactor, equals(0.99));
      });

      testWidgets(
          'should validate that negative values are not allowed (small)',
          (WidgetTester tester) async {
        expect(
          () => StatBarWidget(
            label: 'Small Negative',
            value: -1,
            color: Colors.red,
          ),
          throwsAssertionError,
        );
      });

      testWidgets('should validate that values over 100 are not allowed',
          (WidgetTester tester) async {
        expect(
          () => StatBarWidget(
            label: 'Over Max',
            value: 101,
            color: Colors.red,
          ),
          throwsAssertionError,
        );
      });

      testWidgets('should handle whitespace-only label',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(360, 690),
            child: MaterialApp(
              home: Scaffold(
                body: StatBarWidget(
                  label: '   ',
                  value: 50,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        );

        expect(find.text('   '), findsOneWidget);
        expect(find.text('50'), findsOneWidget);
      });
    });

    group('Multiple instances', () {
      testWidgets('should handle multiple StatBarWidget instances',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(360, 690),
            child: MaterialApp(
              home: Scaffold(
                body: Column(
                  children: [
                    StatBarWidget(
                        label: 'Strength', value: 80, color: Colors.red),
                    StatBarWidget(
                        label: 'Speed', value: 60, color: Colors.blue),
                    StatBarWidget(
                        label: 'Intelligence', value: 90, color: Colors.green),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.byType(StatBarWidget), findsNWidgets(3));
        expect(find.text('Strength'), findsOneWidget);
        expect(find.text('Speed'), findsOneWidget);
        expect(find.text('Intelligence'), findsOneWidget);
        expect(find.text('80'), findsOneWidget);
        expect(find.text('60'), findsOneWidget);
        expect(find.text('90'), findsOneWidget);
      });

      testWidgets('should handle identical StatBarWidget instances',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(360, 690),
            child: MaterialApp(
              home: Scaffold(
                body: Column(
                  children: [
                    StatBarWidget(
                        label: 'Same', value: 50, color: Colors.orange),
                    StatBarWidget(
                        label: 'Same', value: 50, color: Colors.orange),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.byType(StatBarWidget), findsNWidgets(2));
        expect(find.text('Same'), findsNWidgets(2));
        expect(find.text('50'), findsNWidgets(2));
      });
    });
  });
}
