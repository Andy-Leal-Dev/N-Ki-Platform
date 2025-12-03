import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/dashboard_tab.dart';

class DashboardSegmentedControl extends StatelessWidget {
  const DashboardSegmentedControl({
    super.key,
    required this.activeTab,
    required this.onChanged,
  });

  final DashboardTab activeTab;
  final ValueChanged<DashboardTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: palette.cardBackground,
        borderRadius: const BorderRadius.all(Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: palette.shadow,
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: DashboardTab.values.map((tab) {
          final bool isActive = tab == activeTab;
          final _TabMeta meta = _TabMeta.fromTab(tab);

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isActive ? palette.accent : Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(22)),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: palette.shadow,
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      meta.icon,
                      size: 18,
                      color: isActive ? Colors.white : palette.secondaryText,
                    ),
                    const SizedBox(width: 8),
                    Builder(
                      builder: (context) {
                        final TextStyle baseStyle = isActive
                            ? AppTextStyles.buttonLabel(context)
                            : AppTextStyles.sectionSubtitle(context);
                        final Color textColor = isActive
                            ? Colors.white
                            : palette.secondaryText;
                        return Text(
                          meta.label,
                          style: baseStyle.copyWith(color: textColor),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TabMeta {
  const _TabMeta(this.icon, this.label);
  final IconData icon;
  final String label;

  static _TabMeta fromTab(DashboardTab tab) {
    switch (tab) {
      case DashboardTab.loans:
        return const _TabMeta(Icons.attach_money_rounded, 'Préstamos');
      case DashboardTab.clients:
        return const _TabMeta(Icons.people_alt_rounded, 'Clientes');
    }
  }
}
