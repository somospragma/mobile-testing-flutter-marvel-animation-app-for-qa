import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marvel_animation_app/shared/presentation/state/navigation_provider.dart';

void main() {
  group('NavigationProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('NavigationNotifier', () {
      test('should have initial state of 0', () {
        final initialState = container.read(navigationProvider);

        expect(initialState, equals(0));
      });

      test('should return 0 when build() is called', () {
        final notifier = NavigationNotifier();

        final result = notifier.build();

        expect(result, equals(0));
      });
    });

    group('setIndex', () {
      test('should update state when setIndex is called with valid index', () {
        const newIndex = 2;

        container.read(navigationProvider.notifier).setIndex(newIndex);
        final state = container.read(navigationProvider);

        expect(state, equals(newIndex));
      });

      test('should update state multiple times correctly', () {
        final notifier = container.read(navigationProvider.notifier);

        notifier.setIndex(1);
        expect(container.read(navigationProvider), equals(1));

        notifier.setIndex(3);
        expect(container.read(navigationProvider), equals(3));

        notifier.setIndex(0);
        expect(container.read(navigationProvider), equals(0));
      });

      test('should handle negative index values', () {
        const negativeIndex = -1;

        container.read(navigationProvider.notifier).setIndex(negativeIndex);
        final state = container.read(navigationProvider);

        expect(state, equals(negativeIndex));
      });

      test('should handle large index values', () {
        const largeIndex = 999;

        container.read(navigationProvider.notifier).setIndex(largeIndex);
        final state = container.read(navigationProvider);

        expect(state, equals(largeIndex));
      });

      test('should handle zero index correctly', () {
        container.read(navigationProvider.notifier).setIndex(5);
        const zeroIndex = 0;

        container.read(navigationProvider.notifier).setIndex(zeroIndex);
        final state = container.read(navigationProvider);

        expect(state, equals(zeroIndex));
      });
    });

    group('provider instance', () {
      test('should create new instance of NavigationNotifier', () {
        final notifier1 = NavigationNotifier();
        final notifier2 = NavigationNotifier();

        expect(notifier1, isNot(same(notifier2)));
        expect(notifier1.build(), equals(notifier2.build()));
      });

      test('should maintain state independently in different containers', () {
        final container1 = ProviderContainer();
        final container2 = ProviderContainer();

        container1.read(navigationProvider.notifier).setIndex(1);
        container2.read(navigationProvider.notifier).setIndex(2);

        expect(container1.read(navigationProvider), equals(1));
        expect(container2.read(navigationProvider), equals(2));

        container1.dispose();
        container2.dispose();
      });
    });

    group('state changes', () {
      test('should notify listeners when state changes', () {
        final notifier = container.read(navigationProvider.notifier);
        var notificationCount = 0;

        container.listen<int>(
          navigationProvider,
          (previous, next) {
            notificationCount++;
          },
        );

        notifier.setIndex(1);
        notifier.setIndex(2);
        notifier.setIndex(3);

        expect(notificationCount, equals(3));
      });

      test('should handle state change notifications correctly', () {
        final notifier = container.read(navigationProvider.notifier);
        var notificationCount = 0;

        container.listen<int>(
          navigationProvider,
          (previous, next) {
            notificationCount++;
          },
        );

        notifier.setIndex(1);
        notifier.setIndex(2);

        expect(notificationCount, equals(2));
        expect(container.read(navigationProvider), equals(2));
      });

      test('should provide correct previous and next values in listener', () {
        final notifier = container.read(navigationProvider.notifier);
        int? previousValue;
        int? nextValue;

        container.listen<int>(
          navigationProvider,
          (previous, next) {
            previousValue = previous;
            nextValue = next;
          },
        );

        notifier.setIndex(5);

        expect(previousValue, equals(0));
        expect(nextValue, equals(5));
      });
    });

    group('typical navigation scenarios', () {
      test('should handle typical bottom navigation bar indices (0-4)', () {
        final notifier = container.read(navigationProvider.notifier);
        final typicalIndices = [0, 1, 2, 3, 4];

        for (final index in typicalIndices) {
          notifier.setIndex(index);
          expect(container.read(navigationProvider), equals(index));
        }
      });

      test('should handle navigation flow simulation', () {
        final notifier = container.read(navigationProvider.notifier);
        final navigationFlow = [0, 1, 2, 1, 3, 0];

        for (final index in navigationFlow) {
          notifier.setIndex(index);
          expect(container.read(navigationProvider), equals(index));
        }
      });
    });
  });
}
