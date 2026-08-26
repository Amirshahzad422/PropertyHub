import 'package:flutter/material.dart';
import 'package:propertyhub/core/themes/app_colors.dart';
import 'package:propertyhub/core/themes/app_typography.dart';
import 'package:propertyhub/data/models/chat_model.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isMe;
  final String? propertyTitle;

  const MessageBubble({super.key, required this.message, required this.isMe, this.propertyTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe) const SizedBox(width: 8), // Avatar space if needed later
              
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isMe ? AppColors.primary : AppColors.surfaceVariant.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16).copyWith(
                      bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
                      bottomLeft: !isMe ? const Radius.circular(4) : const Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.text,
                        style: AppTypography.bodyMedium.copyWith(
                          color: isMe ? Colors.white : AppColors.charcoalText,
                        ),
                      ),
                      
                      if (message.isViewingProposal) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFFF7E6),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.calendar_today, color: Color(0xFFD48806), size: 16),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Proposed Viewing',
                                          style: AppTypography.bodyMedium.copyWith(color: AppColors.charcoalText, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          propertyTitle ?? 'Property',
                                          style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: AppColors.surfaceVariant),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      child: const Text('Reschedule', style: TextStyle(color: AppColors.charcoalText)),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      child: const Text('Confirm', style: TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 8, left: 8),
            child: Text(
              "${message.timestamp.hour > 12 ? message.timestamp.hour - 12 : (message.timestamp.hour == 0 ? 12 : message.timestamp.hour)}:${message.timestamp.minute.toString().padLeft(2, '0')} ${message.timestamp.hour >= 12 ? 'PM' : 'AM'}",
              style: AppTypography.bodySmall.copyWith(color: AppColors.outline, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
