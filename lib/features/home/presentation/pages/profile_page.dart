import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marvel_animation_app/shared/presentation/atoms/custom_button.dart';
import 'package:marvel_animation_app/shared/presentation/tokens/tokens.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  static String test = 'Sharon';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Spacing.SPACE_RESPONSIVE_M),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Spacing.SPACE_RESPONSIVE_L,
          ),
          Text(
            'Hi $test',
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
            onTap: () => context.push('/'),
          )
        ],
      ),
    );
  }
}
