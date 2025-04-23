import '../models/ChatModel.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatModel> chats;
  ChatLoaded(this.chats);
}

class ChatError extends ChatState {
  final String error;
  ChatError(this.error);
}
