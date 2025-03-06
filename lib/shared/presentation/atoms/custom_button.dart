import 'package:flutter/material.dart';

import '../tokens/custom_color.dart';
import '../tokens/custom_text_style.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.text,
      this.onTap,
      this.type = CustomBtnType.FILLED,});

  factory CustomButton.link(
      {Key? key, required String text, VoidCallback? onTap, CustomBtnType type = CustomBtnType.LINK}) {
    return CustomButton(
      key: key,
      text: text,
      onTap: onTap,
      type: type,
    );
  }
  final String text;
  final VoidCallback? onTap;
  final CustomBtnType type;

  @override
  Widget build(BuildContext context) {
    return type == CustomBtnType.LINK
        ? TextButton(
            onPressed: onTap,
            child:  Text(text, style: CustomTextStyle.FONT_STYLE_LINK_BUTTON),
          )
        : FilledButton(
            onPressed: onTap,
            child: Text(
              text,
              style: CustomTextStyle.FONT_STYLE_BUTTON
                  .copyWith(color: CustomColor.BRAND_PRIMARY_02),
            ));
  }
}

enum CustomBtnType { LINK, FILLED }
