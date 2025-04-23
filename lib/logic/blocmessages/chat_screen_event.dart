import 'package:equatable/equatable.dart';

import '../../chat/models/message_model.dart';

abstract class ChatScreenEvent extends Equatable {
  const ChatScreenEvent();

  @override
  List<Object?> get props => [];
}

class LoadMessagesEvent extends ChatScreenEvent {
  final String chatId;
  const LoadMessagesEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class ConnectWebSocketEvent extends ChatScreenEvent {
  final String userId;

  const ConnectWebSocketEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class DisconnectWebSocketEvent extends ChatScreenEvent {}

class SendMessageEvent extends ChatScreenEvent {
  final Message message;

  const SendMessageEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class NewIncomingMessageEvent extends ChatScreenEvent {
  final Message message;

  const NewIncomingMessageEvent(this.message);

  @override
  List<Object?> get props => [message];
}