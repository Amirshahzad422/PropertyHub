import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:propertyhub/core/themes/app_colors.dart';
import 'package:propertyhub/core/themes/app_typography.dart';
import 'package:propertyhub/data/models/chat_model.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ChatModel chat;

  const ChatAppBar({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.charcoalText),
        onPressed: () => context.pop(),
      ),
      title: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.surfaceVariant,
                backgroundImage: chat.otherUserAvatar.isNotEmpty ? NetworkImage(chat.otherUserAvatar) : null,
              ),
              if (chat.isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chat.otherUserName,
                style: AppTypography.titleMedium.copyWith(color: AppColors.charcoalText, fontSize: 16),
              ),
              Text(
                chat.isOnline ? 'Online' : 'Offline',
                style: AppTypography.bodySmall.copyWith(
                  color: chat.isOnline ? AppColors.secondary : AppColors.outline,
                  fontWeight: chat.isOnline ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppColors.charcoalText),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
