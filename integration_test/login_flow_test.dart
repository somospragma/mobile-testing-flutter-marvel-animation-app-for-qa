import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:marvel_animation_app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marvel_animation_app/core/env/config_env.dart';
import 'package:marvel_animation_app/firebase_options.dart';
import 'package:marvel_animation_app/shared/constants/widget_keys.dart';
import 'utils/finder_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {}
    await ConfigENV.intance.loadEnvironment();
  });

  Future<void> initializeApp(WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MainApp()));
    await tester.pumpAndSettle();
  }

  group('Login Integration Tests', () {
    testWidgets('Should successfully login with valid credentials',
        (WidgetTester tester) async {
      await initializeApp(tester);

      await tester.pumpAndSettle();

      await FinderUtils.findByKey(tester, WidgetKeys.emailInput);

      expect(find.byKey(WidgetKeys.emailInput), findsOneWidget);

      final emailField = find.byKey(WidgetKeys.emailInput);
      final passwordField = find.byKey(WidgetKeys.passwordInput);

      await tester.enterText(emailField, 'ivan.avila@pragma.com.co');
      await tester.pumpAndSettle();

      await tester.enterText(passwordField, 'test123');
      await tester.pumpAndSettle();

      final loginButton = find.byKey(WidgetKeys.loginButton);
      expect(loginButton, findsOneWidget);

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      final homePage = await FinderUtils.findByKey(
        tester,
        WidgetKeys.homePage,
      );

      expect(homePage, findsOneWidget);
    });

    testWidgets('Should show error with invalid credentials',
        (WidgetTester tester) async {
      await initializeApp(tester);

      await tester.pumpAndSettle();

      await FinderUtils.findByKey(tester, WidgetKeys.emailInput);

      final emailField = find.byKey(WidgetKeys.emailInput);
      final passwordField = find.byKey(WidgetKeys.passwordInput);

      await tester.enterText(emailField, 'invalid@email.com');
      await tester.pumpAndSettle();

      await tester.enterText(passwordField, 'wrongpassword');
      await tester.pumpAndSettle();

      final loginButton = find.byKey(WidgetKeys.loginButton);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      final error = await FinderUtils.findByKey(
        tester,
        WidgetKeys.loginErrorSnackBar,
      );

      expect(error, findsOneWidget);
    });

    testWidgets('Should validate empty fields', (WidgetTester tester) async {
      await initializeApp(tester);

      await tester.pumpAndSettle();

      final loginButton =
          await FinderUtils.findByKey(tester, WidgetKeys.loginButton);

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      final error = find.text('All fields are required');

      expect(error, findsOneWidget);
    });

    testWidgets('Should validate email format', (WidgetTester tester) async {
      await initializeApp(tester);

      await tester.pumpAndSettle();

      final emailField = await FinderUtils.findByKey(
        tester,
        WidgetKeys.emailInput,
      );
      final passwordField = await FinderUtils.findByKey(
        tester,
        WidgetKeys.passwordInput,
      );

      await tester.enterText(emailField, 'invalid-email-format');
      await tester.pumpAndSettle();

      await tester.enterText(passwordField, 'test123');
      await tester.pumpAndSettle();

      final loginButton = find.byKey(WidgetKeys.loginButton);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      final error = find.text('The email address is badly formatted.');

      expect(error, findsOneWidget);
    });

    testWidgets('Should navigate to signup page', (WidgetTester tester) async {
      await initializeApp(tester);

      await tester.pumpAndSettle();

      final signupButton = await FinderUtils.findByKey(
        tester,
        WidgetKeys.signUpButton,
      );
      expect(signupButton, findsOneWidget);

      await tester.tap(signupButton);
      await tester.pumpAndSettle();

      final signUpNameInput = await FinderUtils.findByKey(
        tester,
        WidgetKeys.signUpNameInput,
      );
      expect(signUpNameInput, findsOneWidget);
    });

    testWidgets('Should navigate to forgot password',
        (WidgetTester tester) async {
      await initializeApp(tester);

      await tester.pumpAndSettle();

      final forgotPasswordButton = await FinderUtils.findByKey(
        tester,
        WidgetKeys.forgotPasswordButton,
      );
      expect(forgotPasswordButton, findsOneWidget);

      await tester.tap(forgotPasswordButton);
      await tester.pumpAndSettle();

      final resetPasswordEmailInput = await FinderUtils.findByKey(
        tester,
        WidgetKeys.resetPasswordEmailInput,
      );
      expect(resetPasswordEmailInput, findsOneWidget);
    });
  });
}
