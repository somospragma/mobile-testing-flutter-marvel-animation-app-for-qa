import 'package:flutter/material.dart';
import 'package:marvel_animation_app/shared/presentation/tokens/custom_color.dart';

import '../tokens/spacing.dart';

class CustomAppBar extends StatelessWidget {
const CustomAppBar({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: Spacing.SPACE_L),
      color: CustomColor.BRAND_PRIMARY_00,
      child: Image.asset('assets/logo.png', width: 300, height: 60,),);
  }
}