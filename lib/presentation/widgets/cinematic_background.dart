import 'package:flutter/material.dart';
import 'package:propertyhub/core/themes/app_colors.dart';

class CinematicBackground extends StatelessWidget {
  final Widget child;
  final String imageUrl;

  const CinematicBackground({
    super.key,
    required this.child,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            color: AppColors.primary.withValues(alpha: 0.4),
            colorBlendMode: BlendMode.darken,
          ),
          
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withValues(alpha: 0.3),
                  AppColors.primary.withValues(alpha: 0.8),
                ],
              ),
            ),
          ),

          SafeArea(
            child: child,
          ),
        ],
      ),
    );
  }
}
