import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class XPBar extends StatelessWidget {
  final int xp;
  final int max;
  final bool animated;
  final Duration animationDuration;

  const XPBar({
    super.key,
    required this.xp,
    required this.max,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 800),
  });

  @override
  Widget build(BuildContext context) {
    final progress = (xp / max).clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'XP',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$xp / $max',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ],
        ),
        SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progress),
            duration: animationDuration,
            curve: Curves.easeOutCubic,
            builder: (context, animatedProgress, child) {
              return LinearProgressIndicator(
                value: animatedProgress,
                minHeight: 8,
                backgroundColor: AppColors.border.withAlpha(77),
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              );
            },
          ),
        ),
      ],
    );
  }
}
