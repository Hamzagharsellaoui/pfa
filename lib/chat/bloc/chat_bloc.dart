import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pfa_flutter/chat/bloc/chat_event.dart';
import 'package:pfa_flutter/chat/bloc/chat_state.dart';
import 'package:pfa_flutter/chat/repository/chat_repository.dart';
import 'package:pfa_flutter/chat/websocket/web_socket_repository.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc({required this.chatRepository, required WebSocketRepository webSocketService}) : super(ChatInitial()) {
    on<LoadChatsEvent>(_onLoadChats);
  }

  Future<void> _onLoadChats(
      LoadChatsEvent event,
      Emitter<ChatState> emit,
      ) async {
    emit(ChatLoading());
    try {
      final chats = await chatRepository.getUserChats();
      emit(ChatLoaded(chats));
    } catch (e) {
      emit(ChatError("Failed to load chats"));
    }
  }
}
