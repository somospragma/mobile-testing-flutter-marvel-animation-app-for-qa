import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marvel_animation_app/shared/domain/models/item_model.dart';
import 'package:marvel_animation_app/shared/presentation/molecules/custom_card.dart';
import 'package:marvel_animation_app/shared/presentation/tokens/tokens.dart';

class CustomGrid extends ConsumerWidget {
  const CustomGrid({super.key, required this.items, required this.controller});
  final List<ItemModel> items;
  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.SPACE_M),
      child: GridView.builder(
          controller: controller,
          itemCount: items.length,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 0.6,
          ),
          itemBuilder: (BuildContext context, int index) {
            return CustomCard(
              item: items[index],
            );
          }),
    );
  }
}
