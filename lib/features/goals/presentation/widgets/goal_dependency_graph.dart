import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/goal.dart';

/// Visualizes a [Goal] and its linked systems as a radial dependency
/// graph: the goal sits at the center, each system is a node arranged
/// around it, connected by a line whose opacity reflects that system's
/// progress.
class GoalDependencyGraph extends StatelessWidget {
  const GoalDependencyGraph({super.key, required this.goal, this.size = 320});

  final Goal goal;
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
            painter: _ConnectorPainter(systemCount: goal.linkedSystems.length),
          ),
          ..._buildSystemNodes(context),
          _buildCenterNode(context),
        ],
      ),
    );
  }

  Widget _buildCenterNode(BuildContext context) {
    return Container(
      width: size * 0.32,
      height: size * 0.32,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(goal.emoji, style: const TextStyle(fontSize: 22)),
          Text(
            '${(goal.progress * 100).round()}%',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSystemNodes(BuildContext context) {
    final count = goal.linkedSystems.length;
    final radius = size * 0.36;
    final center = size / 2;
    final nodeSize = size * 0.19;

    return [
      for (int i = 0; i < count; i++)
        Builder(builder: (context) {
          final angle = (2 * math.pi * i / count) - math.pi / 2;
          final dx = center + radius * math.cos(angle) - nodeSize / 2;
          final dy = center + radius * math.sin(angle) - nodeSize / 2;
          final system = goal.linkedSystems[i];

          return Positioned(
            left: dx,
            top: dy,
            child: Container(
              width: nodeSize,
              height: nodeSize,
              decoration: BoxDecoration(
                color: AppColors.darkSurfaceElevated,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.25 + 0.75 * system.progress),
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              child: Text(system.emoji, style: TextStyle(fontSize: nodeSize * 0.4)),
            ),
          );
        }),
    ];
  }
}

class _ConnectorPainter extends CustomPainter {
  _ConnectorPainter({required this.systemCount});

  final int systemCount;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.36;
    final paint = Paint()
      ..color = AppColors.darkBorder
      ..strokeWidth = 1.5;

    for (int i = 0; i < systemCount; i++) {
      final angle = (2 * math.pi * i / systemCount) - math.pi / 2;
      final target = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawLine(center, target, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConnectorPainter oldDelegate) =>
      oldDelegate.systemCount != systemCount;
}
