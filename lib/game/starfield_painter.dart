import 'package:flutter/material.dart';

// Starfield painter for scrolling stars
class StarfieldPainter extends CustomPainter {
  final double offset;

  StarfieldPainter(this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    // Draw gradient background
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: const [Color(0xFF000428), Color(0xFF004e92)],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..shader = gradient);

    // Draw stars (simple fixed positions that scroll)
    final stars = [
      [0.1, 0.1],
      [0.2, 0.15],
      [0.3, 0.05],
      [0.4, 0.2],
      [0.5, 0.1],
      [0.6, 0.18],
      [0.7, 0.08],
      [0.8, 0.22],
      [0.9, 0.12],
      [0.15, 0.3],
      [0.25, 0.35],
      [0.35, 0.28],
      [0.45, 0.38],
      [0.55, 0.32],
      [0.65, 0.42],
      [0.75, 0.29],
      [0.85, 0.45],
      [0.95, 0.33],
      [0.1, 0.5],
      [0.2, 0.55],
      [0.3, 0.48],
      [0.4, 0.58],
      [0.5, 0.52],
      [0.6, 0.62],
      [0.7, 0.49],
      [0.8, 0.65],
      [0.9, 0.53],
      [0.12, 0.7],
      [0.22, 0.75],
      [0.32, 0.68],
      [0.42, 0.78],
      [0.52, 0.72],
      [0.62, 0.82],
      [0.72, 0.69],
      [0.82, 0.85],
      [0.92, 0.73],
      [0.05, 0.9],
      [0.18, 0.95],
      [0.28, 0.88],
      [0.38, 0.92],
      [0.48, 0.91],
      [0.58, 0.92],
      [0.68, 0.89],
      [0.78, 0.93],
      [0.88, 0.92],
    ];

    for (final star in stars) {
      final y = (star[1] + offset) % 1.0;
      if (y > 0 && y < 1) {
        canvas.drawCircle(
          Offset(star[0] * size.width, y * size.height),
          1.5,
          paint,
        );
      }
    }

    // Draw a second layer for depth
    final paintSmall = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.fill;

    final smallStars = [
      [0.08, 0.18],
      [0.23, 0.12],
      [0.33, 0.25],
      [0.48, 0.15],
      [0.63, 0.22],
      [0.73, 0.28],
      [0.88, 0.11],
      [0.98, 0.19],
      [0.13, 0.38],
      [0.27, 0.42],
      [0.37, 0.35],
      [0.52, 0.48],
      [0.67, 0.38],
      [0.77, 0.52],
      [0.87, 0.41],
      [0.97, 0.45],
      [0.07, 0.68],
      [0.17, 0.72],
      [0.33, 0.65],
      [0.47, 0.72],
      [0.63, 0.68],
      [0.77, 0.75],
      [0.87, 0.69],
      [0.93, 0.72],
    ];

    for (final star in smallStars) {
      final y = (star[1] + offset) % 1.0;
      if (y > 0 && y < 1) {
        canvas.drawCircle(
          Offset(star[0] * size.width, y * size.height),
          1,
          paintSmall,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Rocket painter for custom spaceship design
class RocketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;

    final path = Path();

    // Draw spaceship body (triangle shape pointing up)
    path.moveTo(size.width / 2, 0); // Top point
    path.lineTo(size.width * 0.2, size.height * 0.6); // Left bottom
    path.lineTo(size.width * 0.3, size.height * 0.9); // Left engine
    path.lineTo(size.width * 0.7, size.height * 0.9); // Right engine
    path.lineTo(size.width * 0.8, size.height * 0.6); // Right bottom
    path.close();

    canvas.drawPath(path, paint);

    // Draw rocket engines/thrusters at bottom
    final enginePaint = Paint()
      ..color = Colors.red[800]!
      ..style = PaintingStyle.fill;

    // Left engine
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.3, size.height * 0.9, size.width * 0.15,
          size.height * 0.1),
      enginePaint,
    );

    // Right engine
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.55, size.height * 0.9, size.width * 0.15,
          size.height * 0.1),
      enginePaint,
    );

    // Draw cockpit
    final cockpitPaint = Paint()
      ..color = Colors.blue[300]!
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.3),
      size.width * 0.15,
      cockpitPaint,
    );

    // Add glow effect
    final glowPaint = Paint()
      ..color = Colors.orange.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    path.reset();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width * 0.2, size.height * 0.6);
    path.lineTo(size.width * 0.3, size.height * 0.9);
    path.lineTo(size.width * 0.7, size.height * 0.9);
    path.lineTo(size.width * 0.8, size.height * 0.6);
    path.close();
    canvas.drawPath(path, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
