
class Message {
  final String chatId;
  final String content;
  final String senderId;
  final String receiverId;
  final MessageType messageType;
  final DateTime createdAt;

  Message({
    required this.chatId,
    required this.content,
    required this.senderId,
    required this.createdAt,
    required this.receiverId, required this.messageType
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      chatId: json['chatId'],
      content: json['content'],
      senderId: json['senderId'],
      messageType: json['messageType'],
      receiverId: json['receiverId'],
      createdAt: DateTime.parse(json['createdAt']),
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
