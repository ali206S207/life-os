import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../areas/domain/life_area.dart';

/// Renders a radar ("spider") chart of the user's [LifeArea] progress
/// values. An evenly-filled octagon means a balanced life; a lopsided
/// shape immediately shows which areas are being neglected — this is
/// the whole point of the "Life Balance Wheel" from the spec.
class LifeBalanceWheel extends StatelessWidget {
  const LifeBalanceWheel({super.key, required this.areas, this.size = 280});

  final List<LifeArea> areas;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RadarPainter(areas: areas),
          ),
          ..._buildLabels(context),
        ],
      ),
    );
  }

  List<Widget> _buildLabels(BuildContext context) {
    final count = areas.length;
    if (count == 0) return [];
    final center = size / 2;
    final labelRadius = size * 0.46;

    return [
      for (int i = 0; i < count; i++)
        Builder(builder: (context) {
          final angle = (2 * math.pi * i / count) - math.pi / 2;
          final dx = center + labelRadius * math.cos(angle);
          final dy = center + labelRadius * math.sin(angle);
          return Positioned(
            left: dx - 24,
            top: dy - 10,
            child: SizedBox(
              width: 48,
              child: Text(
                areas[i].emoji,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        }),
    ];
  }
}

class _RadarPainter extends CustomPainter {
  _RadarPainter({required this.areas});

  final List<LifeArea> areas;

  @override
  void paint(Canvas canvas, Size size) {
    final count = areas.length;
    if (count == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.36;

    final gridPaint = Paint()
      ..color = AppColors.darkBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Concentric rings (25%, 50%, 75%, 100%).
    for (int ring = 1; ring <= 4; ring++) {
      final path = Path();
      for (int i = 0; i <= count; i++) {
        final angle = (2 * math.pi * (i % count) / count) - math.pi / 2;
        final r = maxRadius * ring / 4;
        final point = Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      canvas.drawPath(path, gridPaint);
    }

    // Spokes from center to each axis.
    for (int i = 0; i < count; i++) {
      final angle = (2 * math.pi * i / count) - math.pi / 2;
      final point = Offset(
        center.dx + maxRadius * math.cos(angle),
        center.dy + maxRadius * math.sin(angle),
      );
      canvas.drawLine(center, point, gridPaint);
    }

    // Data polygon.
    final dataPath = Path();
    for (int i = 0; i <= count; i++) {
      final index = i % count;
      final angle = (2 * math.pi * index / count) - math.pi / 2;
      final r = maxRadius * areas[index].progress.clamp(0.0, 1.0);
      final point = Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));
      if (i == 0) {
        dataPath.moveTo(point.dx, point.dy);
      } else {
        dataPath.lineTo(point.dx, point.dy);
      }
    }
    dataPath.close();

    canvas.drawPath(
      dataPath,
      Paint()
        ..shader = AppColors.primaryGradient.createShader(Rect.fromCircle(center: center, radius: maxRadius))
        ..style = PaintingStyle.fill
        ..color = AppColors.primary.withOpacity(0.25),
    );
    canvas.drawPath(
      dataPath,
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Data point dots, colored per area for quick "what's weakest" scanning.
    for (int i = 0; i < count; i++) {
      final angle = (2 * math.pi * i / count) - math.pi / 2;
      final r = maxRadius * areas[i].progress.clamp(0.0, 1.0);
      final point = Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));
      canvas.drawCircle(point, 4, Paint()..color = areas[i].color);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) => oldDelegate.areas != areas;
}
