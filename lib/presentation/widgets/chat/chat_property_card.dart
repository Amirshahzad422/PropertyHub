import 'package:flutter/material.dart';
import 'package:propertyhub/core/themes/app_colors.dart';
import 'package:propertyhub/core/themes/app_typography.dart';
import 'package:propertyhub/data/models/chat_model.dart';

class ChatPropertyCard extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback onClose;

  const ChatPropertyCard({
    super.key,
    required this.chat,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surfaceVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: chat.propertyImage != null
                  ? Image.network(chat.propertyImage!, width: 60, height: 60, fit: BoxFit.cover)
                  : Container(width: 60, height: 60, color: AppColors.surfaceVariant),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.propertyTitle!,
                    style: AppTypography.titleMedium.copyWith(color: AppColors.charcoalText),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (chat.propertyPrice != null)
                    Text(
                      '\$${chat.propertyPrice!.toStringAsFixed(0).replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',')}',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.outline),
              onPressed: onClose,
            ),
          ],
        ),
      ),
    );
  }
}
