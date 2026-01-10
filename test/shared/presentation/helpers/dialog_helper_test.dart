import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marvel_animation_app/shared/presentation/helpers/dialog_helper.dart';

void main() {
  group('DialogHelper', () {
    late bool callbackExecuted;

    setUp(() {
      callbackExecuted = false;
    });

    Widget createTestWidget({
      required String title,
      required String message,
      required VoidCallback onConfirm,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => DialogHelper.showCustomDialog(
                context: context,
                title: title,
                message: message,
                onConfirm: onConfirm,
              ),
              child: const Text('Show Dialog'),
            ),
          ),
        ),
      );
    }

    testWidgets('should show dialog when called', (tester) async {
      await tester.pumpWidget(createTestWidget(
        title: 'Test Title',
        message: 'Test Message',
        onConfirm: () => callbackExecuted = true,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('should display correct title', (tester) async {
      const testTitle = 'Test Title';
      await tester.pumpWidget(createTestWidget(
        title: testTitle,
        message: 'Test Message',
        onConfirm: () => callbackExecuted = true,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text(testTitle), findsOneWidget);
    });

    testWidgets('should display correct message', (tester) async {
      const testMessage = 'Test Message';
      await tester.pumpWidget(createTestWidget(
        title: 'Test Title',
        message: testMessage,
        onConfirm: () => callbackExecuted = true,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text(testMessage), findsOneWidget);
    });

    testWidgets('should display cancel button', (tester) async {
      await tester.pumpWidget(createTestWidget(
        title: 'Test Title',
        message: 'Test Message',
        onConfirm: () => callbackExecuted = true,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.byType(TextButton), findsNWidgets(2));
    });

    testWidgets('should display accept button', (tester) async {
      await tester.pumpWidget(createTestWidget(
        title: 'Test Title',
        message: 'Test Message',
        onConfirm: () => callbackExecuted = true,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Accept'), findsOneWidget);
    });

    testWidgets('should close dialog when cancel is pressed', (tester) async {
      await tester.pumpWidget(createTestWidget(
        title: 'Test Title',
        message: 'Test Message',
        onConfirm: () => callbackExecuted = true,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(callbackExecuted, isFalse);
    });

    testWidgets(
        'should close dialog and execute callback when accept is pressed',
        (tester) async {
      await tester.pumpWidget(createTestWidget(
        title: 'Test Title',
        message: 'Test Message',
        onConfirm: () => callbackExecuted = true,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(callbackExecuted, isFalse);

      await tester.tap(find.text('Accept'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(callbackExecuted, isTrue);
    });

    testWidgets('should work with different titles and messages',
        (tester) async {
      const title1 = 'Delete Item';
      const message1 = 'Are you sure you want to delete this item?';

      await tester.pumpWidget(createTestWidget(
        title: title1,
        message: message1,
        onConfirm: () => callbackExecuted = true,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text(title1), findsOneWidget);
      expect(find.text(message1), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('should work with empty title', (tester) async {
      await tester.pumpWidget(createTestWidget(
        title: '',
        message: 'Test Message',
        onConfirm: () => callbackExecuted = true,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Test Message'), findsOneWidget);
    });

    testWidgets('should work with empty message', (tester) async {
      await tester.pumpWidget(createTestWidget(
        title: 'Test Title',
        message: '',
        onConfirm: () => callbackExecuted = true,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('should work with long title and message', (tester) async {
      const longTitle =
          'This is a very long title that should still work correctly in the dialog';
      const longMessage =
          'This is a very long message that contains multiple lines and should be displayed correctly in the dialog content area without causing any issues';

      await tester.pumpWidget(createTestWidget(
        title: longTitle,
        message: longMessage,
        onConfirm: () => callbackExecuted = true,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text(longTitle), findsOneWidget);
      expect(find.text(longMessage), findsOneWidget);
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('should execute callback only once when accept is pressed',
        (tester) async {
      var executionCount = 0;

      await tester.pumpWidget(createTestWidget(
        title: 'Test Title',
        message: 'Test Message',
        onConfirm: () => executionCount++,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Accept'));
      await tester.pumpAndSettle();

      expect(executionCount, equals(1));
    });

    testWidgets('should have correct dialog structure', (tester) async {
      await tester.pumpWidget(createTestWidget(
        title: 'Test Title',
        message: 'Test Message',
        onConfirm: () => callbackExecuted = true,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);

      final alertDialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
      expect(alertDialog.title, isA<Text>());
      expect(alertDialog.content, isA<Text>());
      expect(alertDialog.actions, hasLength(2));
    });

    testWidgets('should work when called multiple times', (tester) async {
      await tester.pumpWidget(createTestWidget(
        title: 'First Dialog',
        message: 'First Message',
        onConfirm: () => callbackExecuted = true,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();
      expect(find.text('First Dialog'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();
      expect(find.text('First Dialog'), findsOneWidget);

      await tester.tap(find.text('Accept'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(callbackExecuted, isTrue);
    });

    testWidgets('should maintain button order cancel then accept',
        (tester) async {
      await tester.pumpWidget(createTestWidget(
        title: 'Test Title',
        message: 'Test Message',
        onConfirm: () => callbackExecuted = true,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      final textButtons = find.byType(TextButton);
      expect(textButtons, findsNWidgets(2));

      final firstButton = tester.widget<TextButton>(textButtons.first);
      final secondButton = tester.widget<TextButton>(textButtons.last);

      expect((firstButton.child as Text).data, equals('Cancel'));
      expect((secondButton.child as Text).data, equals('Accept'));
    });
  });
}
