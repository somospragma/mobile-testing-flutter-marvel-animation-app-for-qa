// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:marvel_animation_app/shared/presentation/tokens/tokens.dart';

class CustomTextStyle {
  static const TextStyle FONT_STYLE_TITLE = TextStyle(
    letterSpacing: 0,
    height: 1.333,
    fontSize: 23,
    fontWeight: FontWeight.bold
  );

  static const TextStyle FONT_STYLE_LABEL = TextStyle(
    letterSpacing: 0,
    height: 1.333,
    fontSize: 18,
    fontWeight: FontWeight.bold
  );

  static const TextStyle FONT_STYLE_DESCRIPTION = TextStyle(
    letterSpacing: 0,
    height: 1.333,
    fontSize: 16,
  );

  static const TextStyle FONT_STYLE_BUTTON = TextStyle(
    letterSpacing: 0,
    height: 1.333,
    fontSize: 16,
  );

  static const TextStyle FONT_STYLE_SECONDARY_BUTTON = TextStyle(
    letterSpacing: 0,
    height: 1.333,
    fontSize: 16,
    color: CustomColor.BRAND_PRIMARY_02
  );

  static const TextStyle FONT_STYLE_LINK_BUTTON = TextStyle(
    letterSpacing: 0,
    height: 1.333,
    fontSize: 14,
    decorationStyle: TextDecorationStyle.solid,
    decoration: TextDecoration.underline,
  );

  static const TextStyle FONT_STYLE_TITLE_CARD = TextStyle(
    fontFamily: 'Helvetica',
    letterSpacing: 4,
    height: 1.333,
    fontSize: 12,
    color: CustomColor.BRAND_PRIMARY_02,
    fontWeight: FontWeight.bold
  );

  static const TextStyle FONT_STYLE_DESCRIPTION_CARD = TextStyle(
    fontFamily: 'Helvetica',
    letterSpacing: 4,
    height: 1.333,
    fontSize: 11,
    color: CustomColor.BRAND_GRAY,
    fontWeight: FontWeight.bold
  );

  static const TextStyle FONT_STYLE_BUTTON_CARD = TextStyle(
    fontFamily: 'Helvetica',
    letterSpacing: 1,
    height: 1.333,
    fontSize: 15,
    color: CustomColor.BRAND_PRIMARY_02,
    fontWeight: FontWeight.bold
  );
}
