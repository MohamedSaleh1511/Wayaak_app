import 'package:flutter/material.dart';
import 'package:wayaak/app/data/constants/constants.dart';

class CouponPainter extends CustomPainter {
  final Color strokeColor;
  CouponPainter({required this.strokeColor});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paintStroke = Paint()
      ..color = strokeColor.withOpacity(0.1)
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    Paint paint = Paint()..color = Colors.white;
    Path path = Path();
    path.moveTo(size.width * 0.35, 0.0);
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
    path.close();
    canvas.drawShadow(path, Constants.grey.withOpacity(0.2), 12, true);
    canvas.drawPath(path, paint);
    canvas.drawPath(path, paintStroke);
  }

  @override
  bool shouldRepaint(CouponPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(CouponPainter oldDelegate) => true;
}
