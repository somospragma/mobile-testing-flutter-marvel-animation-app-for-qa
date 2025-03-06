import 'package:flutter/material.dart';

import '../tokens/custom_text_style.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox(
      {Key? key, required this.label, this.onChanged, required this.isChecked})
      : super(key: key);
  final String label;
  final void Function(bool?)? onChanged;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          checkColor: Colors.white,
          value: isChecked,
          onChanged: onChanged,
        ),
        Text(
          label,
          style: CustomTextStyle.FONT_STYLE_DESCRIPTION,
        )
      ],
    );
  }
}
