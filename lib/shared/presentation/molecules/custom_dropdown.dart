import 'package:flutter/material.dart';

import '../tokens/custom_text_style.dart';
import '../tokens/spacing.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.onSelected,
    this.label,
    required this.menuEntries,
  });

  final String? label;
  final ValueChanged<String?> onSelected;
  final List<DropdownMenuEntry<String>> menuEntries;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label!,
            style: CustomTextStyle.FONT_STYLE_LABEL,
          ),
        const SizedBox(
          height: Spacing.SPACE_XS,
        ),
        DropdownMenu<String>(
          width: double.infinity,
          onSelected: onSelected,
          dropdownMenuEntries: menuEntries,
        ),
      ],
    );
  }
}
