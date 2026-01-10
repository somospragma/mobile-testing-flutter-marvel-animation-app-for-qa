import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../features/home/presentation/state/search_provider.dart';
import '../tokens/custom_text_style.dart';
import '../tokens/spacing.dart';

class CustomSearchBar extends ConsumerWidget {
  const CustomSearchBar({
    super.key,
    required this.searchController,
    required this.searchFocusNode,
  });

  final TextEditingController searchController;
  final FocusNode searchFocusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchNotifier = ref.read(searchProvider.notifier);
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 24.sp,
          ),
          onPressed: () {
            searchController.clear();
            searchNotifier.clearSearch();
          },
        ),
        Expanded(
          child: TextField(
            controller: searchController,
            focusNode: searchFocusNode,
            style: CustomTextStyle.FONT_STYLE_DESCRIPTION.copyWith(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: 'Search heroes...',
              hintStyle: CustomTextStyle.FONT_STYLE_DESCRIPTION.copyWith(
                color: Colors.white70,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: Spacing.SPACE_S,
                vertical: Spacing.SPACE_XS,
              ),
            ),
            onChanged: searchNotifier.updateSearchQuery,
          ),
        ),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: searchController,
          builder: (context, value, child) {
            if (value.text.isNotEmpty) {
              return IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.white,
                  size: 20.sp,
                ),
                onPressed: () {
                  searchController.clear();
                  searchNotifier.updateSearchQuery('');
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
