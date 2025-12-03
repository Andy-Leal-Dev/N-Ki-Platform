import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class SummaryStatCard extends StatelessWidget {
  const SummaryStatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.background,
  });

  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background ?? palette.cardBackground,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: palette.shadow,
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: (background ?? palette.accentSoft).withAlpha(
                      (0.32 * 255).round(),
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(14)),
                  ),
                  child: Icon(icon, color: palette.accent, size: 20),
                ),
                Text(title, style: AppTextStyles.statLabel(context)),
              ],
            ),
          if (icon != null) const SizedBox(height: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: AppTextStyles.statValue(context)),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!, style: AppTextStyles.sectionSubtitle(context)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
