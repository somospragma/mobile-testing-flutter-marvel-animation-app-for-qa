import 'package:flutter/material.dart';
import 'package:marvel_animation_app/shared/presentation/tokens/custom_color.dart';

import '../tokens/spacing.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key, this.onBack}) : super(key: key);
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: Spacing.SPACE_L),
      color: CustomColor.BRAND_PRIMARY_00,
      child: Row(
        mainAxisAlignment: onBack != null ?  MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          if (onBack != null)
            IconButton(
              iconSize: Spacing.SPACE_M,
              icon: const Icon(Icons.chevron_left),
              color: CustomColor.BRAND_PRIMARY_02,
              onPressed: onBack,
            ),
          Image.asset(
            'assets/logo.png',
            width: 300,
            height: 60,
          ),
        ],
      ),
    );
  }
}
