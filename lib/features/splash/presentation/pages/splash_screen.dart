import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/presentation/tokens/tokens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  double _logoSize = 100.0;

  @override
  void initState() {
    super.initState();
    
    Future.delayed(const Duration(milliseconds: 700), () {
      setState(() {
        _opacity = 1.0;
        _logoSize = 200.0;
      });
    });

    Future.delayed(const Duration(seconds: 3), () {
      context.go('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.BRAND_PRIMARY_00,
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          width: _logoSize,
          height: _logoSize,
          child: AnimatedOpacity(
            duration: const Duration(seconds: 1),
            opacity: _opacity,
            child: Image.asset('assets/logo.png'),
          ),
        ),
      ),
    );
  }
}
