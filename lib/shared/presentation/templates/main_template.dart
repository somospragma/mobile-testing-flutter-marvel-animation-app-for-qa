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
      this.displayBottomBar = false});
  final Widget body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final double horizontalPadding;
  final bool displayAppBar;
  final bool displayBottomBar;

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
              if (displayAppBar) const CustomAppBar(),
              Expanded(child: SingleChildScrollView(child: body)),
              if (displayBottomBar) const CustomBottomBar(),
            ],
          )),
    );
  }
}
