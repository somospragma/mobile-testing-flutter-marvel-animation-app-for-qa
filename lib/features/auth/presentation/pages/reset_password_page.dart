import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/presentation/atoms/atoms.dart';
import '../../../../shared/presentation/templates/templates.dart';
import '../../../../shared/presentation/tokens/tokens.dart';

class ResetPasswordPage extends ConsumerWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return MainTemplate(
        horizontalPadding: Spacing.NO_SPACE,
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
        floatingActionButton: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.SPACE_L),
          child: Column(
            children: <Widget>[
              const SizedBox(height: Spacing.SPACE_XXL),
              const Text(
                'Reset password',
                style: CustomTextStyle.FONT_STYLE_TITLE,
              ),
              const SizedBox(height: Spacing.SPACE_L),
              const Text(
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s',
                style: CustomTextStyle.FONT_STYLE_DESCRIPTION,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Spacing.SPACE_M),
              CustomInput(
                hintText: 'Enter email',
                onChanged: (_){},
              ),
              const SizedBox(height: Spacing.SPACE_M),
              CustomButton(
                text: 'Submit',
                onTap: (){},
              ),
            ],
          ),
        ));
  }
}
