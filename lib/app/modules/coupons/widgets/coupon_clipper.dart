import 'package:flutter/material.dart';

class CouponClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    path.lineTo(size.width * 0.35, 0.0);
    path.relativeArcToPoint(const Offset(30, 0),
        radius: const Radius.circular(15.0), largeArc: true, clockwise: false);
    path.lineTo(size.width - 15, 0);
    path.quadraticBezierTo(size.width, 0.0, size.width, 15.0);
    path.lineTo(size.width, size.height - 15);
    path.quadraticBezierTo(
        size.width, size.height, size.width - 15, size.height);
    path.lineTo(size.width * 0.35 + 30, size.height);
    path.arcToPoint(Offset((size.width * 0.35), size.height),
        radius: const Radius.circular(15.0), clockwise: false);
    path.lineTo(15.0, size.height);
    path.quadraticBezierTo(0.0, size.height, 0.0, size.height - 15);
    path.lineTo(0.0, 15.0);
    path.quadraticBezierTo(0.0, 0.0, 15.0, 0.0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
