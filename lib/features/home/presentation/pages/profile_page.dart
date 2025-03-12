import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marvel_animation_app/features/auth/presentation/state/log_in_provider.dart';
import 'package:marvel_animation_app/shared/presentation/atoms/custom_button.dart';
import 'package:marvel_animation_app/shared/presentation/tokens/tokens.dart';

import '../../../../shared/presentation/helpers/dialog_helper.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  void showLogoutDialog(BuildContext context) {
    DialogHelper.showCustomDialog(
        context: context,
        title: "Sign Out",
        message: "Are you sure you want to sign out?",
        onConfirm: () => context.push('/'));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final login = ref.watch(logInProvider);
    return Padding(
      padding: EdgeInsets.all(Spacing.SPACE_RESPONSIVE_M),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Spacing.SPACE_RESPONSIVE_L,
          ),
          Text(
            'Hi ${login.name}',
            style: CustomTextStyle.FONT_STYLE_TITLE,
          ),
          SizedBox(
            height: Spacing.SPACE_RESPONSIVE_S,
          ),
          const Text(
              'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
          SizedBox(
            height: Spacing.SPACE_RESPONSIVE_S,
          ),
          CustomButton(
            text: 'Cerrar Sesión',
            onTap: () => showLogoutDialog(context),
          )
        ],
      ),
    );
  }
}
