import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return Scaffold(
      backgroundColor: palette.pageBackground,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 72,
              height: 72,
              child: CircularProgressIndicator(color: palette.accent),
            ),
            const SizedBox(height: 16),
            Text(
              'Preparando tu experiencia...',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: palette.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
