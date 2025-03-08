import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marvel_animation_app/features/home/presentation/state/home_provider.dart';
import 'package:marvel_animation_app/shared/presentation/organism/custom_grid.dart';

import '../../../../shared/domain/models/item_model.dart';
import '../state/home_state.dart';

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
    final int offset =
        ref.watch(homeProvider.select((HomeState state) => state.offset));
    final homeNotifier =  ref.read(homeProvider.notifier);

    if (isLoading && offset == 0) {
      return const Center(child: CircularProgressIndicator());
    }

    return CustomGrid(
      cardAction: homeNotifier.getHeroeComics,
      cardPressed:  homeNotifier.getHeroeComics,
      items: heroes,
      controller: _scrollController,
    );
  }
}
