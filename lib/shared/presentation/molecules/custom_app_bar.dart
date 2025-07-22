import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marvel_animation_app/shared/presentation/tokens/custom_color.dart';
import '../../../features/home/presentation/state/search_provider.dart';
import '../tokens/spacing.dart';
import '../tokens/custom_text_style.dart';

class CustomAppBar extends ConsumerStatefulWidget {
  const CustomAppBar({Key? key, this.onBack, this.showSearch = false}) : super(key: key);
  final VoidCallback? onBack;
  final bool showSearch;

  @override
  ConsumerState<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends ConsumerState<CustomAppBar> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final searchNotifier = ref.read(searchProvider.notifier);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: Spacing.SPACE_L,
        left: Spacing.SPACE_M,
        right: Spacing.SPACE_M,
        bottom: Spacing.SPACE_S,
      ),
      color: CustomColor.BRAND_PRIMARY_00,
      child: searchState.isSearchActive
          ? _buildSearchBar(searchNotifier)
          : _buildNormalAppBar(searchNotifier),
    );
  }

  Widget _buildNormalAppBar(searchNotifier) {
    return Row(
      mainAxisAlignment: widget.onBack != null
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.center,
      children: [
        if (widget.onBack != null)
          IconButton(
            iconSize: Spacing.SPACE_M,
            icon: const Icon(Icons.chevron_left),
            color: CustomColor.BRAND_PRIMARY_02,
            onPressed: widget.onBack,
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
        if (widget.showSearch)
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
              size: 24.sp,
            ),
            onPressed: () {
              searchNotifier.toggleSearch();
              Future.delayed(const Duration(milliseconds: 100), () {
                _searchFocusNode.requestFocus();
              });
            },
          ),
      ],
    );
  }

  Widget _buildSearchBar(searchNotifier) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 24.sp,
          ),
          onPressed: () {
            _searchController.clear();
            searchNotifier.clearSearch();
          },
        ),
        Expanded(
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
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
        if (_searchController.text.isNotEmpty)
          IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.white,
              size: 20.sp,
            ),
            onPressed: () {
              _searchController.clear();
              searchNotifier.updateSearchQuery('');
            },
          ),
      ],
    );
  }
}
