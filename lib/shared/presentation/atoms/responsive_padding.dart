import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

class ResponsivePadding extends StatelessWidget {

  const ResponsivePadding({
    super.key,
    required this.child,
    this.mobilePadding,
    this.webPadding,
  });
  final Widget child;
  final EdgeInsets? mobilePadding;
  final EdgeInsets? webPadding;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets effectivePadding = kIsWeb
        ? webPadding ?? const EdgeInsets.all(Spacing.SPACE_XL)
        : mobilePadding ?? const EdgeInsets.all(Spacing.SPACE_L);

    return Padding(
      padding: effectivePadding,
      child: child,
    );
  }
}
