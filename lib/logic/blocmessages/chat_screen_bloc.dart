import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pfa_flutter/chat/websocket/web_socket_repository.dart';
import 'package:pfa_flutter/logic/blocmessages/chat_screen_event.dart';
import 'package:pfa_flutter/logic/blocmessages/chat_screen_state.dart';
import '../../chat/models/message_model.dart';
import '../../chat/repository/chat_repository.dart';

class ChatScreenBloc extends Bloc<ChatScreenEvent, ChatScreenState> {
  final ChatRepository chatRepository;
  final WebSocketRepository webSocketRepository;
  final String chatId;
  final String currentUserId;
  StreamSubscription<Message>? _messageSubscription;
  bool _isWebSocketInitialized = false;

  ChatScreenBloc({
    required this.chatRepository,
    required this.webSocketRepository,
    required this.chatId,
    required this.currentUserId,
  }) : super(ChatInitialState()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<NewIncomingMessageEvent>(_onNewIncomingMessage);
    webSocketRepository.messageStream.listen((message) {
      add(NewIncomingMessageEvent(message));
    });
    _initializeWebSocketOnce();

    add(LoadMessagesEvent(chatId));
  }

  void _initializeWebSocketOnce() {
    if (_isWebSocketInitialized) return;
    _isWebSocketInitialized = true;

    _messageSubscription = webSocketRepository.messageStream.listen((message) {
      if (message.chatId == chatId) {
        add(NewIncomingMessageEvent(message));
      }
    });

    webSocketRepository.connect(
      userId: currentUserId,
      onMessage: (message) {
        if (message.chatId == chatId) {
          add(NewIncomingMessageEvent(message));
        }
      },
    );

    int reconnectAttempts = 0;
    const maxReconnectAttempts = 5;

    webSocketRepository.connectionStream.listen((isConnected) {
      if (!isConnected && reconnectAttempts < maxReconnectAttempts) {
        reconnectAttempts++;
        Future.delayed(Duration(seconds: 2 * reconnectAttempts), () {
          webSocketRepository.connect(
            userId: currentUserId,
            onMessage: (message) {
              if (message.chatId == chatId) {
                add(NewIncomingMessageEvent(message));
              }
            },
          );
        });
      }
    });
  }

  Future<void> _onLoadMessages(LoadMessagesEvent event, Emitter<ChatScreenState> emit,) async {
    emit(MessagesLoadingState());
    try {
      final messages = await chatRepository.fetchMessages(chatId);
      emit(MessagesLoadedState(messages));
    } catch (e) {
      emit(MessageSendFailedState('Failed to load messages: ${e.toString()}'));
    }
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatScreenState> emit) async {
    try {
      webSocketRepository.sendMessage(
        content: event.message.content,
        chatId: chatId,
        senderId: currentUserId,
        receiverId: await chatRepository.getParticipants(event.message.chatId).then((value) => value[0]),
      );

      if (state is MessagesLoadedState) {
        final currentState = state as MessagesLoadedState;
        final updatedMessages = [...currentState.messages, event.message];
        emit(MessagesLoadedState(updatedMessages));
      }
    } catch (e) {
      emit(MessageSendFailedState('Failed to send message: ${e.toString()}'));
    }
  }
  void _onNewIncomingMessage(NewIncomingMessageEvent event, Emitter<ChatScreenState> emit) {
    print('🔄 BLoC received new message event: '
        'ID: ${event.message.chatId} '
        'Content: ${event.message.content}');

    if (state is MessagesLoadedState) {
      final currentState = state as MessagesLoadedState;
      print('📄 Current message count: ${currentState.messages.length}');

      final updatedMessages = [...currentState.messages, event.message];
      print('🆕 New message count: ${updatedMessages.length}');

      emit(MessagesLoadedState(updatedMessages));
      print('✅ State updated with new message');
    } else {
      print('⚠️ Received message in invalid state: ${state.runtimeType}');
    }
  }

  @override
  Future<void> close() async {
    await _messageSubscription?.cancel();
    return super.close();
  }
}
