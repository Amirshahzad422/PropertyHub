import 'package:flutter/material.dart';
import 'package:propertyhub/core/themes/app_colors.dart';
import 'package:propertyhub/data/mock_chat_data.dart';
import 'package:propertyhub/presentation/widgets/chat/chat_list_item.dart';
import 'package:propertyhub/data/models/chat_model.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ChatModel> _filteredChats = [];

  @override
  void initState() {
    super.initState();
    _filteredChats = MockChatData.chats;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredChats = MockChatData.chats;
      } else {
        _filteredChats = MockChatData.chats.where((chat) {
          final matchesName = chat.otherUserName.toLowerCase().contains(query);
          final matchesProperty = chat.propertyTitle?.toLowerCase().contains(query) ?? false;
          final matchesMessage = chat.lastMessage.toLowerCase().contains(query);
          return matchesName || matchesProperty || matchesMessage;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search conversations...',
                    hintStyle: TextStyle(color: AppColors.outline),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),
            
            // Chat List
            Expanded(
              child: _filteredChats.isEmpty
                  ? const Center(child: Text("No conversations found.", style: TextStyle(color: AppColors.outline)))
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: _filteredChats.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final chat = _filteredChats[index];
                        return ChatListItem(chat: chat);
                      },
                    ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}


