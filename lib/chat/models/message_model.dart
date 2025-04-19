
class Message {
  final String chatId;
  final String content;
  final String senderId;
  final String receiverId;
  final MessageType messageType;
  final MessageState messageState;
  final DateTime createdAt;

  Message({
    required this.chatId,
    required this.content,
    required this.senderId,
    required this.createdAt,
    this.messageState = MessageState.sent, // Default value
    required this.receiverId, required this.messageType
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'] ?? '',
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      messageType: MessageType.values.firstWhere(
            (e) => e.toString().split('.').last == json['messageType'],
        orElse: () => MessageType.TEXT,
      ),
      chatId: json['chatId'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }



  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'senderId': senderId,
      'receiverId': receiverId,
      'messageType': messageType.toString().split('.').last,
      'chatId':chatId
    };
  }
}

enum MessageType { text, image, file, TEXT }

enum MessageState { sent, seen }
