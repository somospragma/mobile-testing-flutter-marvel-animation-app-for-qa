import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class FinderUtils {
  FinderUtils._();

  /// Finds a widget by key with timeout functionality
  /// Returns the finder if widget is found within the timeout duration
  /// Throws TestFailure if widget is not found within timeout
  static Future<Finder> findByKey(
    WidgetTester tester,
    ValueKey key, {
    Duration timeOutDuration = const Duration(seconds: 5),
    Duration pollInterval = const Duration(milliseconds: 100),
  }) async {
    final Finder finder = find.byKey(key);

    // Start time for timeout calculation
    final DateTime startTime = DateTime.now();

    while (DateTime.now().difference(startTime) < timeOutDuration) {
      // Pump and settle to ensure UI is updated
      await tester.pumpAndSettle();

      if (finder.evaluate().isNotEmpty) {
        return finder;
      }

      // Wait for the poll interval before trying again
      await Future.delayed(pollInterval);
    }

    // If we reach here, the widget was not found within timeout
    throw TestFailure(
      'Widget with key "${key.value}" not found within ${timeOutDuration.inSeconds} seconds',
    );
  }
}
