import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/domain/models/error_model.dart';
import '../../../../shared/presentation/atoms/atoms.dart';
import '../../../../shared/presentation/pages/loading_page.dart';
import '../../../../shared/presentation/templates/templates.dart';
import '../../../../shared/presentation/tokens/tokens.dart';
import '../state/log_in_provider.dart';
import '../state/log_in_state.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLoading =
        ref.watch(logInProvider.select((LogInState state) => state.isLoading));

    final LogInNotifier logInNotifier = ref.read(logInProvider.notifier);

    ref.listen<AlertModel?>(
        logInProvider.select((LogInState state) => state.alert),
        (_, AlertModel? alert) {
      if (alert != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(alert.message!),
            backgroundColor: alert.backgroundColor,
          ),
        );
        logInNotifier.cleanAlert();
      }
    });

    if (isLoading) {
      return const LoadingPage();
    }

    return MainTemplate(
      horizontalPadding: Spacing.NO_SPACE,
      body: Padding(
        padding: const EdgeInsets.all(Spacing.SPACE_M),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: Spacing.SPACE_XL,),
            const SizedBox(height: Spacing.SPACE_M),
            CustomInput(
              label: 'Email',
              hintText: 'Enter email',
              onChanged: logInNotifier.updateEmail,
            ),
            const SizedBox(height: Spacing.SPACE_M),
            CustomInput.password(
              label: 'Password',
              hintText: 'Enter password',
              onChanged: logInNotifier.updatePassword,
            ),
            const SizedBox(height: Spacing.SPACE_XS),
            Align(
              alignment: Alignment.centerRight,
              child: CustomButton.link(
                key: const ValueKey('forgot-password_btn'),
                text: 'Forgot Password',
                onTap: () => context.push('/resetPassword'),
              ),
            ),
            const SizedBox(height: Spacing.SPACE_XS),
            CustomButton(
              text: 'Log In',
              onTap: logInNotifier.logIn,
            ),
            const SizedBox(height: Spacing.SPACE_XS),
            CustomButton.link(
              key: const ValueKey('sign-up_btn'),
              text: 'Sign up',
              onTap: () => context.push('/signUp'),
            ),
          ],
        ),
      ),
    );
  }
}
