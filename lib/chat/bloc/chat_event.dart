import 'package:equatable/equatable.dart';
import 'package:pfa_flutter/chat/models/message_model.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadChatsEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}

class LoadMessagesEvent extends ChatEvent {
  final String chatId;

  LoadMessagesEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}


class ReceiveMessageEvent extends ChatEvent {
  final Message message;

  ReceiveMessageEvent(this.message);

  @override
  List<Object?> get props => [message];
}
