

import 'package:flutter/material.dart';

import '../../shared/presentation/tokens/tokens.dart';



class AppTheme {

  AppTheme({ required this.isDarkmode });

  final bool isDarkmode;


  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: CustomColor.BRAND_PRIMARY_01,
    brightness: isDarkmode ? Brightness.dark : Brightness.light,

    listTileTheme: const ListTileThemeData(
      iconColor: CustomColor.BRAND_PRIMARY_01,
    ),
    
  );
}
