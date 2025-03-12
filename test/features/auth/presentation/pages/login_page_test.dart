import 'package:marvel_animation_app/core/env/config_env.dart';
import 'package:marvel_animation_app/core/network/dio_network.dart';
import 'package:marvel_animation_app/features/auth/domain/usecases/auth_usecase.dart';
import 'package:marvel_animation_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthUsecase extends Mock implements AuthUsecase {}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockAuthUsecase mockAuthUsecase;
  late GoRouter goRouter; 

  setUpAll(() async {
    await dotenv.load(fileName: ".env");
    await ConfigENV.intance.loadEnvironment();
    DioNetwork.getDio();
  });

  setUp(() {
    mockAuthUsecase = MockAuthUsecase();
    goRouter = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/resetPassword',
          builder: (context, state) => const Scaffold(body: Center(child: Text('Reset Password'))),
        ),
        GoRoute(
          path: '/signUp',
          builder: (context, state) => const Scaffold(body: Center(child: Text('Sign Up'))),
        ),
      ],
    );
  });

  testWidgets('Debe visualizarse la pantalla de inicio de sesión', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authUsecaseProvider.overrideWithValue(mockAuthUsecase),
        ],
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          child: MaterialApp.router(
            routerConfig: goRouter, // Usa routerConfig en lugar de routerDelegate y otros
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Log in'), findsOneWidget);

  });


  testWidgets('Debe navegar a reset password', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authUsecaseProvider.overrideWithValue(mockAuthUsecase),
        ],
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          child: MaterialApp.router(
            routerConfig: goRouter, 
          ),
        ),
      ),
    );

    final buttonFinder = find.byKey(const ValueKey('forgot-password_btn'));
    await tester.tap(buttonFinder);

    await tester.pumpAndSettle();

    expect(find.text('Reset Password'), findsOneWidget);
  });

  testWidgets('Debe navegar a sign up', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authUsecaseProvider.overrideWithValue(mockAuthUsecase),
        ],
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          child: MaterialApp.router(
            routerConfig: goRouter, 
          ),
        ),
      ),
    );

    final buttonFinder = find.byKey(const ValueKey('sign-up_btn'));
    await tester.tap(buttonFinder);

    await tester.pumpAndSettle();

    expect(find.text('Sign Up'), findsOneWidget);
  });
}
