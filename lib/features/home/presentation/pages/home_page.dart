import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marvel_animation_app/features/home/presentation/state/home_provider.dart';
import 'package:marvel_animation_app/shared/presentation/organism/custom_grid.dart';
import 'package:marvel_animation_app/shared/presentation/tokens/tokens.dart';

import '../../../../shared/domain/models/item_model.dart';
import '../state/home_state.dart';
import '../state/search_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScrollEnd);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeProvider.notifier).getHeroes();
    });
  }

  void _onScrollEnd() {
    final bool isLoading =
        ref.read(homeProvider.select((HomeState state) => state.isLoading));
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !isLoading) {
      ref.read(homeProvider.notifier).getHeroes();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading =
        ref.watch(homeProvider.select((HomeState state) => state.isLoading));
    final List<ItemModel> heroes =
        ref.watch(homeProvider.select((HomeState state) => state.heroes));
    final int currentBatch =
        ref.watch(homeProvider.select((HomeState state) => state.currentBatch));
    final homeNotifier = ref.read(homeProvider.notifier);
    
    // Watch search state
    final searchState = ref.watch(searchProvider);
    
    // Determine which items to show
    final List<ItemModel> itemsToShow = searchState.isSearchActive && searchState.searchQuery.isNotEmpty
        ? searchState.searchResults
        : heroes;

    if (isLoading && currentBatch == 0 && !searchState.isSearchActive) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Search results info
        if (searchState.isSearchActive && searchState.searchQuery.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Spacing.SPACE_M),
            child: Text(
              'Found ${itemsToShow.length} heroes for "${searchState.searchQuery}"',
              style: CustomTextStyle.FONT_STYLE_DESCRIPTION.copyWith(
                color: CustomColor.BRAND_GRAY,
              ),
            ),
          ),
        // Grid of heroes
        Expanded(
          child: itemsToShow.isEmpty && searchState.isSearchActive && searchState.searchQuery.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: CustomColor.BRAND_GRAY,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No heroes found',
                        style: CustomTextStyle.FONT_STYLE_LABEL.copyWith(
                          color: CustomColor.BRAND_GRAY,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try searching with a different name',
                        style: CustomTextStyle.FONT_STYLE_DESCRIPTION.copyWith(
                          color: CustomColor.BRAND_GRAY,
                        ),
                      ),
                    ],
                  ),
                )
              : CustomGrid(
                  cardAction: () => context.push('/map'),
                  cardPressed: homeNotifier.navigateToHeroDetail,
                  items: itemsToShow,
                  controller: searchState.isSearchActive ? ScrollController() : _scrollController,
                ),
        ),
      ],
    );
  }
}
