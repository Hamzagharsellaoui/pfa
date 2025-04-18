class ChatModel {
  final String id;
  final String name;
  final int unreadCount;
  final String? lastMessage;
  final String? lastMessageTime;
  final bool? isRecipientOnline;
  final String senderId;
  final String recipientId;

  ChatModel({
    required this.id,
    required this.name,
    required this.unreadCount,
    this.lastMessage,
    this.lastMessageTime,
    this.isRecipientOnline,
    required this.senderId,
    required this.recipientId,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      name: json['name'],
      unreadCount: json['unreadCount'],
      lastMessage: json['lastMessage'],
      lastMessageTime: json['lastMessageTime'],
      isRecipientOnline: json['isRecipientOnline'],
      senderId: json['senderId'],
      recipientId: json['recipientId'],
    );
  }
}
