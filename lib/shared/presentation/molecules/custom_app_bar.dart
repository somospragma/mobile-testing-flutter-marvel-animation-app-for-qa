import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marvel_animation_app/shared/presentation/tokens/custom_color.dart';
import '../../../features/home/presentation/state/search_provider.dart';
import '../tokens/spacing.dart';
import 'custom_search_bar.dart';
import 'normal_app_bar.dart';

class CustomAppBar extends ConsumerStatefulWidget {
  const CustomAppBar({super.key, this.onBack, this.showSearch = false});
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
          ? CustomSearchBar(
              searchController: _searchController,
              searchFocusNode: _searchFocusNode,
            )
          : NormalAppBar(
              onBack: widget.onBack,
              showSearch: widget.showSearch,
              searchFocusNode: _searchFocusNode,
            ),
    );
  }
}
