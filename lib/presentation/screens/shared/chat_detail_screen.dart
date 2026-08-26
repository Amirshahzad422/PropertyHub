import 'package:flutter/material.dart';

import 'package:propertyhub/core/themes/app_colors.dart';
import 'package:propertyhub/core/themes/app_typography.dart';
import 'package:propertyhub/data/mock_chat_data.dart';
import 'package:propertyhub/data/models/chat_model.dart';
import 'package:propertyhub/presentation/widgets/chat/message_bubble.dart';
import 'package:propertyhub/presentation/widgets/chat/chat_app_bar.dart';
import 'package:propertyhub/presentation/widgets/chat/chat_property_card.dart';
import 'package:propertyhub/presentation/widgets/chat/chat_input_area.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatId;

  const ChatDetailScreen({super.key, required this.chatId});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late ChatModel chat;
  late List<ChatMessageModel> messages;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showPropertyCard = true;

  @override
  void initState() {
    super.initState();
    chat = MockChatData.chats.firstWhere((c) => c.id == widget.chatId, orElse: () => MockChatData.chats.first);
    messages = MockChatData.chat1Messages.where((m) => m.chatId == widget.chatId).toList();
    if (messages.isEmpty) {
      messages = MockChatData.chat1Messages;
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    setState(() {
      messages.add(
        ChatMessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          chatId: chat.id,
          senderId: 'current_user',
          text: _messageController.text.trim(),
          timestamp: DateTime.now(),
        ),
      );
      _messageController.clear();
    });
    
    // Scroll to bottom after message is added
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChatAppBar(chat: chat),
      body: Column(
        children: [
          // Property Card
          if (_showPropertyCard && chat.propertyTitle != null)
            ChatPropertyCard(
              chat: chat,
              onClose: () {
                setState(() {
                  _showPropertyCard = false;
                });
              },
            ),
            
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message.senderId == 'current_user';
                
                // Add timestamp logic if it's the first message or a new day
                bool showTimestamp = false;
                if (index == 0) {
                  showTimestamp = true;
                } else {
                  final prevMessage = messages[index - 1];
                  if (message.timestamp.difference(prevMessage.timestamp).inMinutes > 30) {
                    showTimestamp = true;
                  }
                }
                
                return Column(
                  children: [
                    if (showTimestamp)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _formatTime(message.timestamp),
                            style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
                          ),
                        ),
                      ),
                      
                    MessageBubble(message: message, isMe: isMe, propertyTitle: chat.propertyTitle),
                  ],
                );
              },
            ),
          ),
          
          // Input Area
          ChatInputArea(
            controller: _messageController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
  
  String _formatTime(DateTime time) {
    return "Today, ${time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour)}:${time.minute.toString().padLeft(2, '0')} ${time.hour >= 12 ? 'PM' : 'AM'}";
  }
}


