import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:propertyhub/core/themes/app_colors.dart';

class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onAvatarTapped;
  final VoidCallback? onNotificationTapped;
  final String? avatarUrl;

  const GlassAppBar({
    super.key,
    required this.title,
    this.onAvatarTapped,
    this.onNotificationTapped,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          color: AppColors.surface.withValues(alpha: 0.85),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            bottom: 8,
            left: 24,
            right: 24,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onAvatarTapped,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.surfaceVariant,
                  backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                  child: avatarUrl == null 
                      ? const Icon(Icons.person, color: AppColors.onSurfaceVariant) 
                      : null,
                ),
              ),
              
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),

              GestureDetector(
                onTap: onNotificationTapped,
                child: const Icon(
                  Icons.notifications_none,
                  color: AppColors.primary,
                  size: 26,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);
}
