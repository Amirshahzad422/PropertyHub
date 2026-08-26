class ChatModel {
  final String id;
  final String otherUserId;
  final String otherUserName;
  final String otherUserAvatar;
  final bool isOnline;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final String? propertyId;
  final String? propertyTitle;
  final String? propertyImage;
  final double? propertyPrice;

  const ChatModel({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserAvatar,
    this.isOnline = false,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.propertyId,
    this.propertyTitle,
    this.propertyImage,
    this.propertyPrice,
  });
}

class ChatMessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isViewingProposal;
  final String? proposedViewingDate;

  const ChatMessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.isViewingProposal = false,
    this.proposedViewingDate,
  });
}
