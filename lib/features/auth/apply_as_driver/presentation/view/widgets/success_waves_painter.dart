import 'package:flutter/material.dart';
import 'package:tracking_app/core/const/app_colors.dart';

class SuccessWavesPainter extends CustomPainter {
  const SuccessWavesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final wave1Paint = Paint()
      ..color = AppColors.purpleBase.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    final wave2Paint = Paint()
      ..color = AppColors.purpleBase.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;

    final path1 = Path();
    path1.moveTo(0, size.height * 0.4);
    path1.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.1,
      size.width * 0.5,
      size.height * 0.5,
    );
    path1.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.9,
      size.width,
      size.height * 0.45,
    );
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();
    canvas.drawPath(path1, wave1Paint);

    final path2 = Path();
    path2.moveTo(0, size.height * 0.65);
    path2.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.85,
      size.width * 0.65,
      size.height * 0.4,
    );
    path2.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.2,
      size.width,
      size.height * 0.6,
    );
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, wave2Paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
