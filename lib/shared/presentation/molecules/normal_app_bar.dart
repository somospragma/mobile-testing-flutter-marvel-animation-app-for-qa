import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marvel_animation_app/features/home/presentation/state/search_provider.dart';

import '../tokens/custom_color.dart';
import '../tokens/spacing.dart';

class NormalAppBar extends ConsumerWidget {
  const NormalAppBar({
    super.key,
    this.onBack,
    required this.showSearch,
    required this.searchFocusNode,
  });

  final VoidCallback? onBack;
  final bool showSearch;
  final FocusNode searchFocusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchNotifier = ref.read(searchProvider.notifier);
    return Row(
      mainAxisAlignment: onBack != null
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.center,
      children: [
        if (onBack != null)
          IconButton(
            iconSize: Spacing.SPACE_M,
            icon: const Icon(Icons.chevron_left),
            color: CustomColor.BRAND_PRIMARY_02,
            onPressed: onBack,
          ),
        Expanded(
          child: Center(
            child: Image.asset(
              'assets/logo.png',
              width: 250.w,
              height: 50.h,
            ),
          ),
        ),
        if (showSearch)
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
              size: 24.sp,
            ),
            onPressed: () {
              searchNotifier.toggleSearch();
              Future.delayed(const Duration(milliseconds: 100), () {
                searchFocusNode.requestFocus();
              });
            },
          ),
      ],
    );
  }
}
