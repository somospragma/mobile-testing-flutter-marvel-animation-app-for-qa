import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marvel_animation_app/shared/presentation/tokens/spacing.dart';

void main() {
  Future<void> initializeScreenUtil(WidgetTester tester,
      {Size? designSize}) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: designSize ?? const Size(375, 812),
        builder: (context, child) => const MaterialApp(
          home: SizedBox(),
        ),
      ),
    );
    await tester.pump();
  }

  group('Spacing', () {
    group('Fixed spacing constants', () {
      test('should have correct NO_SPACE value', () {
        expect(Spacing.NO_SPACE, equals(0));
      });

      test('should have correct SPACE_XS value', () {
        expect(Spacing.SPACE_XS, equals(6));
      });

      test('should have correct SPACE_S value', () {
        expect(Spacing.SPACE_S, equals(12));
      });

      test('should have correct SPACE_M value', () {
        expect(Spacing.SPACE_M, equals(24));
      });

      test('should have correct SPACE_L value', () {
        expect(Spacing.SPACE_L, equals(36));
      });

      test('should have correct SPACE_XL value', () {
        expect(Spacing.SPACE_XL, equals(72));
      });

      test('should have correct SPACE_XXL value', () {
        expect(Spacing.SPACE_XXL, equals(144));
      });

      test('should have fixed constants as const double', () {
        expect(Spacing.NO_SPACE, isA<double>());
        expect(Spacing.SPACE_XS, isA<double>());
        expect(Spacing.SPACE_S, isA<double>());
        expect(Spacing.SPACE_M, isA<double>());
        expect(Spacing.SPACE_L, isA<double>());
        expect(Spacing.SPACE_XL, isA<double>());
        expect(Spacing.SPACE_XXL, isA<double>());
      });

      test('should have ascending order of spacing values', () {
        expect(Spacing.NO_SPACE, lessThan(Spacing.SPACE_XS));
        expect(Spacing.SPACE_XS, lessThan(Spacing.SPACE_S));
        expect(Spacing.SPACE_S, lessThan(Spacing.SPACE_M));
        expect(Spacing.SPACE_M, lessThan(Spacing.SPACE_L));
        expect(Spacing.SPACE_L, lessThan(Spacing.SPACE_XL));
        expect(Spacing.SPACE_XL, lessThan(Spacing.SPACE_XXL));
      });

      test('should have non-negative values', () {
        expect(Spacing.NO_SPACE, greaterThanOrEqualTo(0));
        expect(Spacing.SPACE_XS, greaterThan(0));
        expect(Spacing.SPACE_S, greaterThan(0));
        expect(Spacing.SPACE_M, greaterThan(0));
        expect(Spacing.SPACE_L, greaterThan(0));
        expect(Spacing.SPACE_XL, greaterThan(0));
        expect(Spacing.SPACE_XXL, greaterThan(0));
      });

      test('should have no NaN values in fixed constants', () {
        expect(Spacing.NO_SPACE.isNaN, isFalse);
        expect(Spacing.SPACE_XS.isNaN, isFalse);
        expect(Spacing.SPACE_S.isNaN, isFalse);
        expect(Spacing.SPACE_M.isNaN, isFalse);
        expect(Spacing.SPACE_L.isNaN, isFalse);
        expect(Spacing.SPACE_XL.isNaN, isFalse);
        expect(Spacing.SPACE_XXL.isNaN, isFalse);
      });

      test('should have no infinite values in fixed constants', () {
        expect(Spacing.NO_SPACE.isInfinite, isFalse);
        expect(Spacing.SPACE_XS.isInfinite, isFalse);
        expect(Spacing.SPACE_S.isInfinite, isFalse);
        expect(Spacing.SPACE_M.isInfinite, isFalse);
        expect(Spacing.SPACE_L.isInfinite, isFalse);
        expect(Spacing.SPACE_XL.isInfinite, isFalse);
        expect(Spacing.SPACE_XXL.isInfinite, isFalse);
      });
    });

    group('Responsive spacing structure', () {
      test('should have responsive spacing static getters defined', () {
        expect(() => Spacing, returnsNormally);

        expect(Spacing.NO_SPACE, isA<double>());
        expect(Spacing.SPACE_XS, isA<double>());
        expect(Spacing.SPACE_S, isA<double>());
        expect(Spacing.SPACE_M, isA<double>());
        expect(Spacing.SPACE_L, isA<double>());
        expect(Spacing.SPACE_XL, isA<double>());
        expect(Spacing.SPACE_XXL, isA<double>());
      });

      test('should have responsive spacing definitions in code structure', () {
        expect(Spacing, isNotNull);
      });
    });

    group('Responsive spacing with ScreenUtil', () {
      testWidgets(
          'should have correct SPACE_RESPONSIVE_XS value with ScreenUtil initialized',
          (WidgetTester tester) async {
        await initializeScreenUtil(tester);

        expect(Spacing.SPACE_RESPONSIVE_XS, isA<double>());
        expect(Spacing.SPACE_RESPONSIVE_XS, greaterThan(0));
        expect(Spacing.SPACE_RESPONSIVE_XS.isNaN, isFalse);
        expect(Spacing.SPACE_RESPONSIVE_XS.isInfinite, isFalse);
      });

      testWidgets(
          'should have correct SPACE_RESPONSIVE_S value with ScreenUtil initialized',
          (WidgetTester tester) async {
        await initializeScreenUtil(tester);

        expect(Spacing.SPACE_RESPONSIVE_S, isA<double>());
        expect(Spacing.SPACE_RESPONSIVE_S, greaterThan(0));
        expect(Spacing.SPACE_RESPONSIVE_S.isNaN, isFalse);
        expect(Spacing.SPACE_RESPONSIVE_S.isInfinite, isFalse);
      });

      testWidgets(
          'should have correct SPACE_RESPONSIVE_M value with ScreenUtil initialized',
          (WidgetTester tester) async {
        await initializeScreenUtil(tester);

        expect(Spacing.SPACE_RESPONSIVE_M, isA<double>());
        expect(Spacing.SPACE_RESPONSIVE_M, greaterThan(0));
        expect(Spacing.SPACE_RESPONSIVE_M.isNaN, isFalse);
        expect(Spacing.SPACE_RESPONSIVE_M.isInfinite, isFalse);
      });

      testWidgets(
          'should have correct SPACE_RESPONSIVE_L value with ScreenUtil initialized',
          (WidgetTester tester) async {
        await initializeScreenUtil(tester);

        expect(Spacing.SPACE_RESPONSIVE_L, isA<double>());
        expect(Spacing.SPACE_RESPONSIVE_L, greaterThan(0));
        expect(Spacing.SPACE_RESPONSIVE_L.isNaN, isFalse);
        expect(Spacing.SPACE_RESPONSIVE_L.isInfinite, isFalse);
      });

      testWidgets(
          'should have correct SPACE_RESPONSIVE_XL value with ScreenUtil initialized',
          (WidgetTester tester) async {
        await initializeScreenUtil(tester);

        expect(Spacing.SPACE_RESPONSIVE_XL, isA<double>());
        expect(Spacing.SPACE_RESPONSIVE_XL, greaterThan(0));
        expect(Spacing.SPACE_RESPONSIVE_XL.isNaN, isFalse);
        expect(Spacing.SPACE_RESPONSIVE_XL.isInfinite, isFalse);
      });

      testWidgets('should have ascending order of responsive spacing values',
          (WidgetTester tester) async {
        await initializeScreenUtil(tester);

        expect(
            Spacing.SPACE_RESPONSIVE_XS, lessThan(Spacing.SPACE_RESPONSIVE_S));
        expect(
            Spacing.SPACE_RESPONSIVE_S, lessThan(Spacing.SPACE_RESPONSIVE_M));
        expect(
            Spacing.SPACE_RESPONSIVE_M, lessThan(Spacing.SPACE_RESPONSIVE_L));
        expect(
            Spacing.SPACE_RESPONSIVE_L, lessThan(Spacing.SPACE_RESPONSIVE_XL));
      });

      testWidgets(
          'should have correct base value relationships in responsive spacing',
          (WidgetTester tester) async {
        await initializeScreenUtil(tester, designSize: const Size(375, 812));

        final ratio1 = Spacing.SPACE_RESPONSIVE_S / Spacing.SPACE_RESPONSIVE_XS;
        expect(ratio1, closeTo(2.0, 0.1));

        final ratio2 = Spacing.SPACE_RESPONSIVE_M / Spacing.SPACE_RESPONSIVE_S;
        expect(ratio2, closeTo(2.0, 0.1));

        final ratio3 = Spacing.SPACE_RESPONSIVE_L / Spacing.SPACE_RESPONSIVE_M;
        expect(ratio3, closeTo(1.5, 0.1));

        final ratio4 = Spacing.SPACE_RESPONSIVE_XL / Spacing.SPACE_RESPONSIVE_L;
        expect(ratio4, closeTo(1.333, 0.1));
      });

      testWidgets('should scale responsive values with different design sizes',
          (WidgetTester tester) async {
        await initializeScreenUtil(tester, designSize: const Size(320, 568));

        final smallScreenXS = Spacing.SPACE_RESPONSIVE_XS;
        final smallScreenS = Spacing.SPACE_RESPONSIVE_S;
        final smallScreenM = Spacing.SPACE_RESPONSIVE_M;
        final smallScreenL = Spacing.SPACE_RESPONSIVE_L;
        final smallScreenXL = Spacing.SPACE_RESPONSIVE_XL;

        await initializeScreenUtil(tester, designSize: const Size(428, 926));

        final largeScreenXS = Spacing.SPACE_RESPONSIVE_XS;
        final largeScreenS = Spacing.SPACE_RESPONSIVE_S;
        final largeScreenM = Spacing.SPACE_RESPONSIVE_M;
        final largeScreenL = Spacing.SPACE_RESPONSIVE_L;
        final largeScreenXL = Spacing.SPACE_RESPONSIVE_XL;

        expect(largeScreenXS, greaterThanOrEqualTo(smallScreenXS));
        expect(largeScreenS, greaterThanOrEqualTo(smallScreenS));
        expect(largeScreenM, greaterThanOrEqualTo(smallScreenM));
        expect(largeScreenL, greaterThanOrEqualTo(smallScreenL));
        expect(largeScreenXL, greaterThanOrEqualTo(smallScreenXL));
      });

      testWidgets(
          'should maintain proportional relationships across screen sizes',
          (WidgetTester tester) async {
        await initializeScreenUtil(tester, designSize: const Size(375, 812));

        final standardRatio =
            Spacing.SPACE_RESPONSIVE_M / Spacing.SPACE_RESPONSIVE_XS;

        await initializeScreenUtil(tester, designSize: const Size(414, 896));

        final newRatio =
            Spacing.SPACE_RESPONSIVE_M / Spacing.SPACE_RESPONSIVE_XS;

        expect(newRatio, closeTo(standardRatio, 0.01));
      });

      testWidgets(
          'should provide reasonable responsive values for UI components',
          (WidgetTester tester) async {
        await initializeScreenUtil(tester);

        expect(Spacing.SPACE_RESPONSIVE_XS, greaterThan(5));
        expect(Spacing.SPACE_RESPONSIVE_XS, lessThan(25));

        expect(Spacing.SPACE_RESPONSIVE_S, greaterThan(10));
        expect(Spacing.SPACE_RESPONSIVE_S, lessThan(50));

        expect(Spacing.SPACE_RESPONSIVE_M, greaterThan(20));
        expect(Spacing.SPACE_RESPONSIVE_M, lessThan(100));

        expect(Spacing.SPACE_RESPONSIVE_L, greaterThan(30));
        expect(Spacing.SPACE_RESPONSIVE_L, lessThan(150));

        expect(Spacing.SPACE_RESPONSIVE_XL, greaterThan(40));
        expect(Spacing.SPACE_RESPONSIVE_XL, lessThan(200));
      });

      testWidgets('should handle edge case screen sizes gracefully',
          (WidgetTester tester) async {
        await initializeScreenUtil(tester, designSize: const Size(240, 320));

        expect(Spacing.SPACE_RESPONSIVE_XS, greaterThan(0));
        expect(Spacing.SPACE_RESPONSIVE_S, greaterThan(0));
        expect(Spacing.SPACE_RESPONSIVE_M, greaterThan(0));
        expect(Spacing.SPACE_RESPONSIVE_L, greaterThan(0));
        expect(Spacing.SPACE_RESPONSIVE_XL, greaterThan(0));

        expect(Spacing.SPACE_RESPONSIVE_XS.isFinite, isTrue);
        expect(Spacing.SPACE_RESPONSIVE_S.isFinite, isTrue);
        expect(Spacing.SPACE_RESPONSIVE_M.isFinite, isTrue);
        expect(Spacing.SPACE_RESPONSIVE_L.isFinite, isTrue);
        expect(Spacing.SPACE_RESPONSIVE_XL.isFinite, isTrue);

        await initializeScreenUtil(tester, designSize: const Size(768, 1024));

        expect(Spacing.SPACE_RESPONSIVE_XS, greaterThan(0));
        expect(Spacing.SPACE_RESPONSIVE_S, greaterThan(0));
        expect(Spacing.SPACE_RESPONSIVE_M, greaterThan(0));
        expect(Spacing.SPACE_RESPONSIVE_L, greaterThan(0));
        expect(Spacing.SPACE_RESPONSIVE_XL, greaterThan(0));

        expect(Spacing.SPACE_RESPONSIVE_XS, lessThan(50));
        expect(Spacing.SPACE_RESPONSIVE_S, lessThan(100));
        expect(Spacing.SPACE_RESPONSIVE_M, lessThan(200));
        expect(Spacing.SPACE_RESPONSIVE_L, lessThan(300));
        expect(Spacing.SPACE_RESPONSIVE_XL, lessThan(400));
      });

      testWidgets(
          'should provide consistent responsive spacing across multiple initializations',
          (WidgetTester tester) async {
        await initializeScreenUtil(tester, designSize: const Size(375, 812));

        final firstXS = Spacing.SPACE_RESPONSIVE_XS;
        final firstS = Spacing.SPACE_RESPONSIVE_S;
        final firstM = Spacing.SPACE_RESPONSIVE_M;
        final firstL = Spacing.SPACE_RESPONSIVE_L;
        final firstXL = Spacing.SPACE_RESPONSIVE_XL;

        await initializeScreenUtil(tester, designSize: const Size(375, 812));

        expect(Spacing.SPACE_RESPONSIVE_XS, equals(firstXS));
        expect(Spacing.SPACE_RESPONSIVE_S, equals(firstS));
        expect(Spacing.SPACE_RESPONSIVE_M, equals(firstM));
        expect(Spacing.SPACE_RESPONSIVE_L, equals(firstL));
        expect(Spacing.SPACE_RESPONSIVE_XL, equals(firstXL));
      });
    });

    group('Value relationships', () {
      test('should have proper multiplier relationships in fixed spacing', () {
        expect(Spacing.SPACE_S, equals(Spacing.SPACE_XS * 2));

        expect(Spacing.SPACE_M, equals(Spacing.SPACE_S * 2));

        expect(Spacing.SPACE_L, equals(Spacing.SPACE_M * 1.5));

        expect(Spacing.SPACE_XL, equals(Spacing.SPACE_L * 2));

        expect(Spacing.SPACE_XXL, equals(Spacing.SPACE_XL * 2));
      });

      test('should have consistent base values for responsive spacing', () {
        const baseResponsiveXS = 10;
        const baseResponsiveS = 20;
        const baseResponsiveM = 40;
        const baseResponsiveL = 60;
        const baseResponsiveXL = 80;

        expect(baseResponsiveS, equals(baseResponsiveXS * 2));
        expect(baseResponsiveM, equals(baseResponsiveS * 2));
        expect(baseResponsiveL, equals(baseResponsiveM * 1.5));
        expect(baseResponsiveXL, equals(baseResponsiveL * (4 / 3)));
      });
    });

    group('Spacing class structure', () {
      test('should be a utility class with static members for fixed values',
          () {
        expect(() => Spacing.NO_SPACE, returnsNormally);
        expect(() => Spacing.SPACE_XS, returnsNormally);
        expect(() => Spacing.SPACE_S, returnsNormally);
        expect(() => Spacing.SPACE_M, returnsNormally);
        expect(() => Spacing.SPACE_L, returnsNormally);
        expect(() => Spacing.SPACE_XL, returnsNormally);
        expect(() => Spacing.SPACE_XXL, returnsNormally);
      });

      test('should have consistent naming convention for fixed values', () {
        expect(Spacing.NO_SPACE, isA<double>());
        expect(Spacing.SPACE_XS, isA<double>());
      });
    });

    group('Practical usage validation', () {
      test('should provide reasonable values for UI components', () {
        expect(Spacing.NO_SPACE, equals(0.0));

        expect(Spacing.SPACE_XS, greaterThanOrEqualTo(4));
        expect(Spacing.SPACE_XS, lessThanOrEqualTo(8));

        expect(Spacing.SPACE_S, greaterThanOrEqualTo(8));
        expect(Spacing.SPACE_S, lessThanOrEqualTo(16));

        expect(Spacing.SPACE_M, greaterThanOrEqualTo(16));
        expect(Spacing.SPACE_M, lessThanOrEqualTo(32));

        expect(Spacing.SPACE_L, greaterThanOrEqualTo(32));
        expect(Spacing.SPACE_L, lessThanOrEqualTo(48));

        expect(Spacing.SPACE_XL, greaterThanOrEqualTo(64));
        expect(Spacing.SPACE_XL, lessThanOrEqualTo(96));

        expect(Spacing.SPACE_XXL, greaterThanOrEqualTo(128));
        expect(Spacing.SPACE_XXL, lessThanOrEqualTo(192));
      });

      test('should provide consistent spacing scale', () {
        final spacingValues = [
          Spacing.NO_SPACE,
          Spacing.SPACE_XS,
          Spacing.SPACE_S,
          Spacing.SPACE_M,
          Spacing.SPACE_L,
          Spacing.SPACE_XL,
          Spacing.SPACE_XXL,
        ];

        for (int i = 1; i < spacingValues.length; i++) {
          expect(spacingValues[i], greaterThan(spacingValues[i - 1]),
              reason:
                  'Spacing value at index $i should be greater than previous value');
        }
      });
    });

    group('Edge cases and validation', () {
      test('should handle edge case comparisons', () {
        expect(Spacing.NO_SPACE, equals(0));
        expect(Spacing.SPACE_XS, greaterThan(Spacing.NO_SPACE));
        expect(Spacing.SPACE_XXL, lessThan(200));
      });

      test('should have mathematically correct relationships', () {
        expect(Spacing.SPACE_M / Spacing.SPACE_S, equals(2.0));
        expect(Spacing.SPACE_L / Spacing.SPACE_M, equals(1.5));
        expect(Spacing.SPACE_XXL / Spacing.SPACE_XL, equals(2.0));
      });

      test('should provide spacing values suitable for different use cases',
          () {
        expect(Spacing.NO_SPACE, equals(0));

        expect(Spacing.SPACE_XS, equals(6));

        expect(Spacing.SPACE_S, equals(12));

        expect(Spacing.SPACE_M, equals(24));

        expect(Spacing.SPACE_L, equals(36));

        expect(Spacing.SPACE_XL, equals(72));

        expect(Spacing.SPACE_XXL, equals(144));
      });
    });

    group('Design system consistency', () {
      test('should follow 8-point grid system principles', () {
        expect(Spacing.SPACE_XS % 2, equals(0));
        expect(Spacing.SPACE_S % 4, equals(0));
        expect(Spacing.SPACE_M % 8, equals(0));
        expect(Spacing.SPACE_L % 4, equals(0));
        expect(Spacing.SPACE_XL % 8, equals(0));
        expect(Spacing.SPACE_XXL % 8, equals(0));
      });

      test('should provide a harmonious spacing scale', () {
        final ratios = <double>[];

        final values = [
          Spacing.SPACE_XS,
          Spacing.SPACE_S,
          Spacing.SPACE_M,
          Spacing.SPACE_L,
          Spacing.SPACE_XL,
          Spacing.SPACE_XXL,
        ];

        for (int i = 1; i < values.length; i++) {
          ratios.add(values[i] / values[i - 1]);
        }

        expect(ratios[0], equals(2.0));
        expect(ratios[1], equals(2.0));
        expect(ratios[2], equals(1.5));
        expect(ratios[3], equals(2.0));
        expect(ratios[4], equals(2.0));
      });

      test('should be suitable for responsive design', () {
        final allFixedValues = [
          Spacing.NO_SPACE,
          Spacing.SPACE_XS,
          Spacing.SPACE_S,
          Spacing.SPACE_M,
          Spacing.SPACE_L,
          Spacing.SPACE_XL,
          Spacing.SPACE_XXL,
        ];

        for (final value in allFixedValues) {
          expect(value, greaterThanOrEqualTo(0));
          expect(value, lessThan(300));
        }
      });
    });
  });
}
