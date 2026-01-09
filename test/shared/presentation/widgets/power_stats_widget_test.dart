import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marvel_animation_app/shared/presentation/widgets/power_stats_widget.dart';
import 'package:marvel_animation_app/shared/presentation/widgets/stat_bar_widget.dart';

void main() {
  group('PowerStatsWidget', () {
    Widget createWidget(PowerStatsWidget widget) {
      return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          home: Scaffold(
            body: widget,
          ),
        ),
      );
    }

    group('Basic functionality', () {
      testWidgets('should create widget with all parameters provided',
          (WidgetTester tester) async {
        const widget = PowerStatsWidget(
          intelligence: '85',
          strength: '90',
          speed: '75',
          durability: '80',
          power: '95',
          combat: '70',
        );

        await tester.pumpWidget(createWidget(widget));

        expect(find.byType(PowerStatsWidget), findsOneWidget);
        expect(find.text('Power Stats'), findsOneWidget);
        expect(find.byType(StatBarWidget), findsNWidgets(6));
      });

      testWidgets('should create widget with no parameters (all null)',
          (WidgetTester tester) async {
        const widget = PowerStatsWidget();

        await tester.pumpWidget(createWidget(widget));

        expect(find.byType(PowerStatsWidget), findsOneWidget);
        expect(find.text('Power Stats'), findsOneWidget);
        expect(find.byType(StatBarWidget), findsNWidgets(6));

        expect(find.text('0'), findsNWidgets(6));
      });

      testWidgets('should display correct title', (WidgetTester tester) async {
        const widget = PowerStatsWidget();

        await tester.pumpWidget(createWidget(widget));

        final titleText = tester.widget<Text>(find.text('Power Stats'));
        expect(titleText.style?.fontSize, isNotNull);
        expect(titleText.style?.fontWeight, equals(FontWeight.bold));
      });

      testWidgets('should have correct widget structure',
          (WidgetTester tester) async {
        const widget = PowerStatsWidget(
          intelligence: '50',
        );

        await tester.pumpWidget(createWidget(widget));

        expect(find.byType(Container), findsAtLeast(1));
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(Text), findsAtLeast(1));
        expect(find.byType(SizedBox), findsAtLeast(1));
        expect(find.byType(StatBarWidget), findsNWidgets(6));
      });
    });

    group('Parameter handling', () {
      testWidgets('should handle valid string numbers',
          (WidgetTester tester) async {
        const widget = PowerStatsWidget(
          intelligence: '75',
          strength: '85',
          speed: '60',
          durability: '90',
          power: '80',
          combat: '65',
        );

        await tester.pumpWidget(createWidget(widget));

        expect(find.text('75'), findsOneWidget);
        expect(find.text('85'), findsOneWidget);
        expect(find.text('60'), findsOneWidget);
        expect(find.text('90'), findsOneWidget);
        expect(find.text('80'), findsOneWidget);
        expect(find.text('65'), findsOneWidget);
      });

      testWidgets('should handle mixed null and valid values',
          (WidgetTester tester) async {
        const widget = PowerStatsWidget(
          intelligence: '75',
          strength: null,
          speed: '60',
          durability: null,
          power: '80',
          combat: null,
        );

        await tester.pumpWidget(createWidget(widget));

        expect(find.text('75'), findsOneWidget);
        expect(find.text('60'), findsOneWidget);
        expect(find.text('80'), findsOneWidget);
        expect(find.text('0'), findsNWidgets(3));
      });

      testWidgets('should handle empty strings', (WidgetTester tester) async {
        const widget = PowerStatsWidget(
          intelligence: '',
          strength: '',
          speed: '',
          durability: '',
          power: '',
          combat: '',
        );

        await tester.pumpWidget(createWidget(widget));

        expect(find.text('0'), findsNWidgets(6));
      });

      testWidgets('should handle invalid string values',
          (WidgetTester tester) async {
        const widget = PowerStatsWidget(
          intelligence: 'invalid',
          strength: 'abc',
          speed: '12.5',
          durability: '75x',
          power: 'null',
          combat: '  ',
        );

        await tester.pumpWidget(createWidget(widget));

        expect(find.text('0'), findsNWidgets(6));
      });

      testWidgets('should handle zero values', (WidgetTester tester) async {
        const widget = PowerStatsWidget(
          intelligence: '0',
          strength: '0',
          speed: '0',
          durability: '0',
          power: '0',
          combat: '0',
        );

        await tester.pumpWidget(createWidget(widget));

        expect(find.text('0'), findsNWidgets(6));
      });

      testWidgets('should handle maximum valid values (100)',
          (WidgetTester tester) async {
        const widget = PowerStatsWidget(
          intelligence: '100',
          strength: '100',
          speed: '100',
          durability: '100',
          power: '100',
          combat: '100',
        );

        await tester.pumpWidget(createWidget(widget));

        expect(find.text('100'), findsNWidgets(6));
      });
    });

    group('Individual stat widgets', () {
      testWidgets('should create Intelligence stat with correct properties',
          (WidgetTester tester) async {
        const widget = PowerStatsWidget(intelligence: '85');

        await tester.pumpWidget(createWidget(widget));

        expect(find.text('Intelligence'), findsOneWidget);
        expect(find.text('85'), findsOneWidget);
      });

      testWidgets('should create Strength stat with correct properties',
          (WidgetTester tester) async {
        const widget = PowerStatsWidget(strength: '90');

        await tester.pumpWidget(createWidget(widget));

        expect(find.text('Strength'), findsOneWidget);
        expect(find.text('90'), findsOneWidget);
      });

      testWidgets('should create Speed stat with correct properties',
          (WidgetTester tester) async {
        const widget = PowerStatsWidget(speed: '75');

        await tester.pumpWidget(createWidget(widget));

        expect(find.text('Speed'), findsOneWidget);
        expect(find.text('75'), findsOneWidget);
      });

      testWidgets('should create Durability stat with correct properties',
          (WidgetTester tester) async {
        const widget = PowerStatsWidget(durability: '80');

        await tester.pumpWidget(createWidget(widget));

        expect(find.text('Durability'), findsOneWidget);
        expect(find.text('80'), findsOneWidget);
      });

      testWidgets('should create Power stat with correct properties',
          (WidgetTester tester) async {
        const widget = PowerStatsWidget(power: '95');

        await tester.pumpWidget(createWidget(widget));

        expect(find.text('Power'), findsOneWidget);
        expect(find.text('95'), findsOneWidget);
      });

      testWidgets('should create Combat stat with correct properties',
          (WidgetTester tester) async {
        const widget = PowerStatsWidget(combat: '70');

        await tester.pumpWidget(createWidget(widget));

        expect(find.text('Combat'), findsOneWidget);
        expect(find.text('70'), findsOneWidget);
      });
    });

    group('Widget styling and layout', () {
      testWidgets('should have correct container decoration',
          (WidgetTester tester) async {
        const widget = PowerStatsWidget();

        await tester.pumpWidget(createWidget(widget));

        final container =
            tester.widget<Container>(find.byType(Container).first);
        final decoration = container.decoration as BoxDecoration;

        expect(decoration.color, equals(Colors.grey[100]));
        expect(decoration.borderRadius, isNotNull);
        expect(decoration.border, isNotNull);
      });

      testWidgets('should have correct column layout',
          (WidgetTester tester) async {
        const widget = PowerStatsWidget();

        await tester.pumpWidget(createWidget(widget));

        final column = tester.widget<Column>(find.byType(Column));
        expect(column.crossAxisAlignment, equals(CrossAxisAlignment.start));
        expect(column.children.length, equals(8));
      });

      testWidgets('should maintain responsive design with ScreenUtil',
          (WidgetTester tester) async {
        const widget = PowerStatsWidget(intelligence: '50');

        await tester.pumpWidget(createWidget(widget));

        expect(find.byType(PowerStatsWidget), findsOneWidget);
      });

      testWidgets('should have proper spacing between elements',
          (WidgetTester tester) async {
        const widget = PowerStatsWidget();

        await tester.pumpWidget(createWidget(widget));

        expect(find.byType(SizedBox), findsAtLeast(1));
      });
    });

    group('Edge cases', () {
      testWidgets('should handle whitespace strings',
          (WidgetTester tester) async {
        const widget = PowerStatsWidget(
          intelligence: '   ',
          strength: '\t',
          speed: '\n',
          durability: '  75  ',
          power: '',
          combat: null,
        );

        await tester.pumpWidget(createWidget(widget));

        expect(find.text('75'), findsOneWidget);
        expect(find.text('0'), findsNWidgets(5));
      });

      testWidgets('should handle boundary values correctly',
          (WidgetTester tester) async {
        const widget = PowerStatsWidget(
          intelligence: '1',
          strength: '99',
          speed: '100',
          durability: '0',
        );

        await tester.pumpWidget(createWidget(widget));

        expect(find.text('1'), findsOneWidget);
        expect(find.text('99'), findsOneWidget);
        expect(find.text('100'), findsOneWidget);
        expect(find.text('0'), findsNWidgets(3));
      });

      testWidgets('should handle all edge cases within valid range',
          (WidgetTester tester) async {
        const widget = PowerStatsWidget(
          intelligence: '50',
          strength: '75',
          speed: '25',
          durability: '100',
          power: '0',
          combat: '1',
        );

        await tester.pumpWidget(createWidget(widget));

        expect(find.text('50'), findsOneWidget);
        expect(find.text('75'), findsOneWidget);
        expect(find.text('25'), findsOneWidget);
        expect(find.text('100'), findsOneWidget);
        expect(find.text('0'), findsOneWidget);
        expect(find.text('1'), findsOneWidget);
      });

      testWidgets('should handle special numeric formats',
          (WidgetTester tester) async {
        const widget = PowerStatsWidget(
          intelligence: '75.0',
          strength: '080',
          speed: '+85',
          durability: '1e2',
        );

        await tester.pumpWidget(createWidget(widget));

        expect(find.byType(PowerStatsWidget), findsOneWidget);
      });
    });

    group('Multiple instances', () {
      testWidgets('should handle multiple PowerStatsWidget instances',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (context, child) => MaterialApp(
              home: Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    children: const [
                      PowerStatsWidget(
                        intelligence: '75',
                        strength: '85',
                      ),
                      SizedBox(height: 16),
                      PowerStatsWidget(
                        speed: '90',
                        durability: '80',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        expect(find.byType(PowerStatsWidget), findsNWidgets(2));
        expect(find.text('Power Stats'), findsNWidgets(2));
        expect(find.byType(StatBarWidget), findsNWidgets(12));
      });

      testWidgets('should handle identical PowerStatsWidget instances',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (context, child) => MaterialApp(
              home: Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    children: const [
                      PowerStatsWidget(intelligence: '50'),
                      SizedBox(height: 16),
                      PowerStatsWidget(intelligence: '50'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        expect(find.byType(PowerStatsWidget), findsNWidgets(2));
        expect(find.text('50'), findsNWidgets(2));
      });
    });

    group('Integration with StatBarWidget', () {
      testWidgets('should properly integrate with StatBarWidget constraints',
          (WidgetTester tester) async {
        const widget = PowerStatsWidget(
          intelligence: '50',
          strength: '75',
          speed: '25',
          durability: '100',
          power: '0',
          combat: '90',
        );

        await tester.pumpWidget(createWidget(widget));

        expect(find.byType(StatBarWidget), findsNWidgets(6));
        expect(find.text('50'), findsOneWidget);
        expect(find.text('75'), findsOneWidget);
        expect(find.text('25'), findsOneWidget);
        expect(find.text('100'), findsOneWidget);
        expect(find.text('0'), findsOneWidget);
        expect(find.text('90'), findsOneWidget);
      });

      testWidgets('should show all stat labels correctly',
          (WidgetTester tester) async {
        const widget = PowerStatsWidget(
          intelligence: '1',
          strength: '2',
          speed: '3',
          durability: '4',
          power: '5',
          combat: '6',
        );

        await tester.pumpWidget(createWidget(widget));

        expect(find.text('Intelligence'), findsOneWidget);
        expect(find.text('Strength'), findsOneWidget);
        expect(find.text('Speed'), findsOneWidget);
        expect(find.text('Durability'), findsOneWidget);
        expect(find.text('Power'), findsOneWidget);
        expect(find.text('Combat'), findsOneWidget);
      });
    });

    group('String parsing edge cases', () {
      testWidgets('should handle different number formats correctly',
          (WidgetTester tester) async {
        const widget = PowerStatsWidget(
          intelligence: '42',
          strength: '07',
          speed: '0',
          durability: '100',
        );

        await tester.pumpWidget(createWidget(widget));

        expect(find.text('42'), findsOneWidget);
        expect(find.text('7'), findsOneWidget);
        expect(find.text('0'), findsNWidgets(3));
        expect(find.text('100'), findsOneWidget);
      });

      testWidgets('should handle mixed valid and invalid parsing',
          (WidgetTester tester) async {
        const widget = PowerStatsWidget(
          intelligence: '50',
          strength: 'invalid',
          speed: '75',
          durability: 'abc123',
          power: '90',
          combat: '',
        );

        await tester.pumpWidget(createWidget(widget));

        expect(find.text('50'), findsOneWidget);
        expect(find.text('75'), findsOneWidget);
        expect(find.text('90'), findsOneWidget);
        expect(find.text('0'), findsNWidgets(3));
      });
    });
  });
}
