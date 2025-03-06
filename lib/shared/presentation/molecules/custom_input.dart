import 'package:flutter/material.dart';

import '../tokens/custom_text_style.dart';
import '../tokens/spacing.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.isPassword = false,
    this.label,
  });

  factory CustomInput.password({
    String? label,
    required String hintText,
    required ValueChanged<String> onChanged,
  }) {
    return CustomInput(
      label: label,
      hintText: hintText,
      isPassword: true,
      onChanged: onChanged,
    );
  }

  final String hintText;
  final String? label;
  final bool isPassword;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) Text(label!, style: CustomTextStyle.FONT_STYLE_LABEL,),
        const SizedBox(height: Spacing.SPACE_XS,),
        TextField(
          onChanged: onChanged,
          obscureText: isPassword,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: hintText,
          ),
        ),
      ],
    );
  }
}
