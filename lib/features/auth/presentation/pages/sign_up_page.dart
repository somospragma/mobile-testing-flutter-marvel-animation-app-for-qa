import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marvel_animation_app/shared/presentation/molecules/custom_checkbox.dart';

import '../../../../shared/domain/models/error_model.dart';
import '../../../../shared/presentation/atoms/custom_button.dart';
import '../../../../shared/presentation/molecules/custom_dropdown.dart';
import '../../../../shared/presentation/molecules/custom_input.dart';
import '../../../../shared/presentation/pages/loading_page.dart';
import '../../../../shared/presentation/templates/templates.dart';
import '../../../../shared/presentation/tokens/spacing.dart';
import '../state/sign_up_provider.dart';
import '../state/sign_up_state.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLoading = ref
        .watch(signUpProvider.select((SignUpState state) => state.isLoading));

    final bool termsIsChecked = ref
        .watch(signUpProvider.select((SignUpState state) => state.terms));

    final SignUpNotifier signUpNotifier = ref.read(signUpProvider.notifier);

    ref.listen<AlertModel?>(
        signUpProvider.select((SignUpState state) => state.alert),
        (_, AlertModel? alert) {
      if (alert != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(alert.message!),
            backgroundColor: alert.backgroundColor,
          ),
        );
        signUpNotifier.cleanAlert();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: Spacing.SPACE_M),
            CustomInput(
              label: 'Name',
              hintText: 'Enter name',
              onChanged: signUpNotifier.updateName,
            ),
            const SizedBox(height: Spacing.SPACE_M),
            CustomInput(
                label: 'Email',
                hintText: 'Enter email',
                onChanged: signUpNotifier.updateEmail),
            const SizedBox(height: Spacing.SPACE_M),
            CustomInput.password(
              label: 'Password',
              hintText: 'Enter password',
              onChanged: signUpNotifier.updatePassword,
            ),
            const SizedBox(height: Spacing.SPACE_M),
            CustomInput.password(
              label: 'Confirm your password',
              hintText: 'Enter password',
              onChanged: signUpNotifier.updateConfirmPassword,
            ),
            const SizedBox(height: Spacing.SPACE_M),
            CustomDropdown(
                label: 'Gender',
                onSelected: signUpNotifier.updateGender,
                menuEntries: signUpNotifier.genderEntries),
            const SizedBox(height: Spacing.SPACE_M),
            CustomCheckbox(
                label: 'I agree to the terms and conditions',
                isChecked: termsIsChecked,
                onChanged: signUpNotifier.updateTerms,),
            const SizedBox(height: Spacing.SPACE_M),
            Center(
              child: CustomButton(
                text: 'Sign Up',
                onTap: signUpNotifier.signUp,
              ),
            ),
            const SizedBox(height: Spacing.SPACE_XS),
            Center(
              child: CustomButton.link(
                text: 'Log In',
                onTap: () => context.pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
