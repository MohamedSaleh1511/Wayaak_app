import 'package:flutter/material.dart';

class GlobalShaderMask extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  const GlobalShaderMask(
      {super.key, required this.child, required this.colors});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: colors,
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}
