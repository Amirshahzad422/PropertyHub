import 'package:flutter/material.dart';
import 'package:propertyhub/core/themes/app_typography.dart';

class JustListedBadge extends StatelessWidget {
  const JustListedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Just Listed',
        style: AppTypography.labelMedium.copyWith(color: Colors.white),
      ),
    );
  }
}
