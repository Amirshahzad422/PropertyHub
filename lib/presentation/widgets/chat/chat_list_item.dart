import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:propertyhub/core/themes/app_colors.dart';
import 'package:propertyhub/core/themes/app_typography.dart';
import 'package:propertyhub/data/models/chat_model.dart';

class ChatListItem extends StatelessWidget {
  final ChatModel chat;

  const ChatListItem({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    // Determine avatar initials for fallback
    final initials = chat.otherUserName.split(' ').take(2).map((e) => e.isNotEmpty ? e[0].toUpperCase() : '').join('');

    return GestureDetector(
      onTap: () => context.push('/chat-detail/${chat.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: chat.unreadCount > 0 
            ? const Border(left: BorderSide(color: AppColors.primary, width: 4))
            : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar with Online Indicator
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.surfaceVariant,
                  backgroundImage: chat.otherUserAvatar.isNotEmpty ? NetworkImage(chat.otherUserAvatar) : null,
                  child: chat.otherUserAvatar.isEmpty
                      ? Text(initials, style: const TextStyle(color: AppColors.charcoalText, fontWeight: FontWeight.bold))
                      : null,
                ),
                if (chat.isOnline)
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            
            // Name and Last Message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          chat.otherUserName,
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.charcoalText,
                            fontWeight: chat.unreadCount > 0 ? FontWeight.bold : FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatTime(chat.lastMessageTime),
                        style: AppTypography.bodySmall.copyWith(
                          color: chat.unreadCount > 0 ? AppColors.primary : AppColors.outline,
                          fontWeight: chat.unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat.lastMessage,
                    style: AppTypography.bodyMedium.copyWith(
                      color: chat.unreadCount > 0 ? AppColors.charcoalText : AppColors.onSurfaceVariant,
                      fontWeight: chat.unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            
            // Property Thumbnail and Unread Badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (chat.propertyImage != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      chat.propertyImage!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (chat.unreadCount > 0) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${chat.unreadCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays == 0) {
      return "${time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour)}:${time.minute.toString().padLeft(2, '0')} ${time.hour >= 12 ? 'PM' : 'AM'}";
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      return days[time.weekday - 1];
    } else {
      return '${time.month}/${time.day}/${time.year}';
    }
  }
}
