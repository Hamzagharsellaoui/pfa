import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:pfa_flutter/logic/auth/auth_bloc.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:pfa_flutter/chat/models/message_model.dart';
import '../repository/chat_repository.dart';

class WebSocketRepository {
  final _messageStreamController = StreamController<Message>.broadcast();
  final _connectionStreamController = StreamController<bool>.broadcast();
  final _errorStreamController = StreamController<String>.broadcast();
  final _connectionCompleter = Completer<void>();

  late StompClient _client;
  final ChatRepository _chatRepository = ChatRepository();

  bool _isConnected = false;
  bool _isConnecting = false;
  String? _currentUserId;

  // Public streams
  Stream<Message> get messageStream => _messageStreamController.stream;
  Stream<bool> get connectionStream => _connectionStreamController.stream;
  Stream<String> get errorStream => _errorStreamController.stream;

  /// Connects to the WebSocket server and subscribes to messages
  Future<void> connect({
    required String userId,
    required void Function(Message message) onMessage,
  }) async {
    if (_isConnected || _isConnecting) return;

    _isConnecting = true;
    _currentUserId = userId;
    _connectionStreamController.add(false);

    try {
      final token = await _getAuthToken();
      _initializeClient(token);
      _client.activate();
    } catch (e) {
      _handleConnectionError();
      log('❌ Connection failed: $e');
    }
  }

  /// Sends a message through the WebSocket connection
  Future<void> sendMessage({
    required String content,
    required String chatId,
    required String senderId,
    required String receiverId,
  }) async {
    log('Sending message: senderId=$senderId, receiverId=$receiverId, chatId=$chatId, content=$content');
    if (!_isConnected) {
      log('⚠️ Cannot send message - not connected to WebSocket');
      return;
    }

    final message = Message(
      content: content,
      senderId: senderId,
      receiverId: receiverId,
      chatId: chatId,
      createdAt: DateTime.now(),
      messageType: MessageType.TEXT,
    );

    try {
      _client.send(
        destination: '/app/chat.send',
        body: jsonEncode(message.toJson()),
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
      );
      log('📤 Sent message to /app/chat.send with senderId: $senderId');
    } catch (e) {
      log('❌ Failed to send message: $e');
    }
  }

  /// Disconnects from the WebSocket server
  Future<void> disconnect() async {
    try {
      if (_isConnected) {
        _client.deactivate();
        _updateConnectionState(false);
        log('🛑 Disconnected from WebSocket');
      }
    } catch (e) {
      log('❌ Error during disconnection: $e');
    }
  }

  /// Closes all resources
  Future<void> close() async {
    await disconnect();
    await _messageStreamController.close();
    await _connectionStreamController.close();
    await _errorStreamController.close();
    _connectionCompleter.complete();
  }

  /// Gets the receiver ID for a chat
  Future<String> getReceiverId(String chatId, String currentUserId) async {
    try {
      final chats = await _chatRepository.getUserChats();
      final chat = chats.firstWhere((c) => c.id == chatId);
      return chat.senderId == currentUserId ? chat.recipientId! : chat.senderId!;
    } catch (e) {
      log('❌ Failed to get receiver ID: $e');
      throw Exception('Could not determine receiver ID');
    }
  }

  // Private helper methods

  Future<String> _getAuthToken() async {
    final token = await AuthBloc.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('No authentication token available');
    }
    return token;
  }

  void _initializeClient(String token) {
    _client = StompClient(
      config: StompConfig(
        url: 'ws://192.168.1.25:8081/websocket',
        stompConnectHeaders: {
          'Authorization': 'Bearer $token',
          'heart-beat': '10000,10000',
        },
        webSocketConnectHeaders: {
          'Authorization': 'Bearer $token',
        },
        onConnect: (frame) async {
          log('Connected to WebSocket with session: ${frame.headers['session']}');
          await _subscribeToMessages();
          _handleSuccessfulConnection(frame);
        },
        beforeConnect: () async {
          log('⏳ Connecting to WebSocket...');
          await Future.delayed(const Duration(milliseconds: 300));
        },
        onStompError: (frame) {
          log('❗ STOMP Error: ${frame.body}');
          _handleConnectionError();
        },
        onWebSocketError: (error) {
          log('❌ WebSocket error: $error');
          _handleConnectionError();
        },
        onDisconnect: (frame) {
          log('🔌 Disconnected');
          _handleConnectionError();
        },
        reconnectDelay: const Duration(seconds: 5),
        heartbeatIncoming: const Duration(seconds: 10),
        heartbeatOutgoing: const Duration(seconds: 10),
      ),
    );
  }

  void _handleSuccessfulConnection(StompFrame frame) {
    _isConnected = true;
    _isConnecting = false;
    _updateConnectionState(true);
    log('✅ WebSocket connected!');
    _connectionCompleter.complete();
  }

    Future<void> _subscribeToMessages() async {
      final destination = '/user/$_currentUserId/queue/messages';
      final errorDestination = '/user/$_currentUserId/queue/errors';
      Completer<void> subscriptionCompleter = Completer();
      _client.subscribe(
        destination: destination,
        headers: {'id': 'sub-$_currentUserId'},
        callback: (frame) {
          if (frame.body != null) {
            _handleIncomingMessage(frame.body!);
          }
        },
      );
      _client.subscribe(
        destination: errorDestination,
        headers: {'id': 'sub-errors-$_currentUserId'},
        callback: (frame) {
          if (frame.body != null) {
            log('❌ Error received: ${frame.body}');
            _errorStreamController.add(frame.body!);
          }
        },
      );
      log('Subscribed to $destination and $errorDestination');
      // Simulate subscription confirmation
      Future.delayed(Duration(milliseconds: 500), () {
        subscriptionCompleter.complete();
      });
      return subscriptionCompleter.future;
    }

  void _handleIncomingMessage(String messageBody) {
    log('Raw message received: $messageBody');
    try {
      final data = jsonDecode(messageBody);
      log('Parsed JSON: $data');
      final message = Message.fromJson(data);
      _messageStreamController.add(message);
      log('📩 New message received: ${message.content}, senderId: ${message.senderId}, chatId: ${message.chatId}');
    } catch (e, stackTrace) {
      log('❌ Failed to decode message: $e\n$stackTrace');
    }
  }
  void _handleConnectionError() {
    _isConnected = false;
    _isConnecting = false;
    _updateConnectionState(false);
    _connectionCompleter.completeError('Connection error');
  }

  void _updateConnectionState(bool isConnected) {
    _isConnected = isConnected;
    _connectionStreamController.add(isConnected);
  }
}