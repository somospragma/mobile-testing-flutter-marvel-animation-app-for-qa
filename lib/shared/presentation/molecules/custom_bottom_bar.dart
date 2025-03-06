import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../state/navigation_provider.dart';
import '../tokens/tokens.dart';

class CustomBottomBar extends ConsumerWidget {
  const CustomBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: Spacing.SPACE_RESPONSIVE_XS),
      color: CustomColor.BRAND_PRIMARY_00,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => ref.read(navigationProvider.notifier).setIndex(0),
            child: const Column(
              children: [
                Icon(
                  Icons.movie,
                  size: Spacing.SPACE_L,
                  color: CustomColor.BRAND_PRIMARY_02,
                ),
                Text(
                  'Characters',
                  style: CustomTextStyle.FONT_STYLE_SECONDARY_BUTTON,
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () => ref.read(navigationProvider.notifier).setIndex(1),
            child: const Column(
              children: [
                Icon(
                  Icons.person,
                  size: Spacing.SPACE_L,
                  color: CustomColor.BRAND_PRIMARY_02,
                ),
                Text(
                  'Profile',
                  style: CustomTextStyle.FONT_STYLE_SECONDARY_BUTTON,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
