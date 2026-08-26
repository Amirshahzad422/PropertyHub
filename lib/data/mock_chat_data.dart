import 'package:propertyhub/data/models/chat_model.dart';

class MockChatData {
  static final List<ChatModel> chats = [
    ChatModel(
      id: 'chat_1',
      otherUserId: 'user_arthur',
      otherUserName: 'Arthur Pendelton',
      otherUserAvatar: 'https://images.unsplash.com/photo-1560250097-0b93528c311a',
      isOnline: true,
      lastMessage: "I've sent the floor plans for the penthouse at...",
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 15)),
      unreadCount: 2,
      propertyId: '1',
      propertyTitle: 'The Glass Pavilion',
      propertyPrice: 14500000,
      propertyImage: 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9',
    ),
    ChatModel(
      id: 'chat_2',
      otherUserId: 'user_sarah',
      otherUserName: 'Sarah Jenkins',
      otherUserAvatar: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2',
      isOnline: false,
      lastMessage: "The sellers have accepted the counter-...",
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 0,
      propertyId: '2',
      propertyTitle: 'Sunset Villa',
      propertyPrice: 3200000,
      propertyImage: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750',
    ),
    ChatModel(
      id: 'chat_3',
      otherUserId: 'user_elena',
      otherUserName: 'Elena Costa',
      otherUserAvatar: 'https://images.unsplash.com/photo-1580489944761-15a19d654956',
      isOnline: false,
      lastMessage: "Thank you for touring the estate. Attached a...",
      lastMessageTime: DateTime.now().subtract(const Duration(days: 3)),
      unreadCount: 0,
      propertyId: '3',
      propertyTitle: 'Historic Manor',
      propertyPrice: 5800000,
      propertyImage: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
    ),
  ];

  static final List<ChatMessageModel> chat1Messages = [
    ChatMessageModel(
      id: 'msg_1',
      chatId: 'chat_1',
      senderId: 'user_arthur',
      text: "Good morning! I saw you were interested in The Glass Pavilion. It's truly a spectacular property.",
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
    ChatMessageModel(
      id: 'msg_2',
      chatId: 'chat_1',
      senderId: 'current_user',
      text: "Yes, absolutely stunning. Is it possible to arrange a private viewing this week?",
      timestamp: DateTime.now().subtract(const Duration(minutes: 40)),
    ),
    ChatMessageModel(
      id: 'msg_3',
      chatId: 'chat_1',
      senderId: 'user_arthur',
      text: "I can certainly arrange that. How does Thursday afternoon work for you?",
      timestamp: DateTime.now().subtract(const Duration(minutes: 35)),
      isViewingProposal: true,
      proposedViewingDate: "Thursday, 3:00 PM",
    ),
  ];
}
