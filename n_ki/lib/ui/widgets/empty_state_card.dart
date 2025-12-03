import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({
    super.key,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(message, style: AppTextStyles.emptyStateTitle(context)),
        if (actionLabel != null && onAction != null) ...[
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: onAction,
            style: TextButton.styleFrom(
              backgroundColor: palette.cardBackground,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(color: palette.accent),
              ),
              foregroundColor: palette.accent,
              textStyle: AppTextStyles.ghostButtonLabel(context),
            ),
            icon: const Icon(Icons.add_circle_outline_rounded),
            label: Text(actionLabel!),
          ),
        ],
      ],
    );

    return CustomPaint(
      painter: _DashedBorderPainter(palette.dashedBorder),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
        decoration: BoxDecoration(
          color: palette.subtleGreenBackground,
          borderRadius: BorderRadius.circular(22),
        ),
        child: content,
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter(this.borderColor);

  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final RRect outer = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(22),
    );

    final Path path = Path()..addRRect(outer);
    const double dashLength = 8;
    const double gap = 6;

    for (final ui.PathMetric metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final double next = distance + dashLength;
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
