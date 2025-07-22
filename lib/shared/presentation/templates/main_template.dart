import 'package:flutter/material.dart';
import 'package:marvel_animation_app/shared/presentation/molecules/custom_bottom_bar.dart';

import '../atoms/responsive_padding.dart';
import '../molecules/custom_app_bar.dart';
import '../tokens/tokens.dart';

class MainTemplate extends StatelessWidget {
  const MainTemplate(
      {super.key,
      required this.body,
      this.floatingActionButton,
      this.floatingActionButtonLocation,
      this.horizontalPadding = Spacing.SPACE_S,
      this.displayAppBar = true,
      this.displayBottomBar = false,
      this.hasScroll = true,
      this.onBack,
      this.showSearch = false});
  final Widget body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final double horizontalPadding;
  final bool displayAppBar;
  final bool displayBottomBar;
  final bool hasScroll;
  final VoidCallback? onBack;
  final bool showSearch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: ResponsivePadding(
          mobilePadding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          webPadding:
              EdgeInsets.symmetric(horizontal: Spacing.SPACE_RESPONSIVE_XL),
          child: Column(
            children: [
              if (displayAppBar) CustomAppBar(onBack: onBack, showSearch: showSearch),
              Expanded(
                  child: hasScroll ? SingleChildScrollView(child: body) : body),
              if (displayBottomBar) const CustomBottomBar(),
            ],
          )),
    );
  }
}
