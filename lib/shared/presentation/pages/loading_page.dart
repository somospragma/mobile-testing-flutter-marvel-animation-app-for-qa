import 'package:flutter/material.dart';
import 'package:marvel_animation_app/shared/presentation/tokens/tokens.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          color: CustomColor.BRAND_PRIMARY_02,
          child: const CircularProgressIndicator()),
    );
  }
}
