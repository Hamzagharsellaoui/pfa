import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../../chat/models/message_model.dart';

abstract class ChatScreenState extends Equatable {
  const ChatScreenState();

  @override
  List<Object?> get props => [];
}

class ChatInitialState extends ChatScreenState {}

class MessagesLoadedState extends ChatScreenState {
  final List<Message> messages;

  MessagesLoadedState(this.messages);
}

class ChatLoadingState extends ChatScreenState {}

class MessagesLoadingState extends ChatScreenState {}

class ChatLoadedState extends ChatScreenState {
  final List<Message> messages;
  final ScrollController scrollController;

  ChatLoadedState({required this.messages, required this.scrollController});
}
class MessageSendFailedState extends ChatScreenState {
  final String errorMessage;

  MessageSendFailedState(this.errorMessage);
}
class ChatErrorState extends ChatScreenState {
  final String message;

  const ChatErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
