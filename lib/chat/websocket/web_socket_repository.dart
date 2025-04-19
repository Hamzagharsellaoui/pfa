import 'dart:async';
import 'dart:convert';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:pfa_flutter/chat/models/message_model.dart';

class WebSocketRepository {
  late StompClient _client;
  final _messageController = StreamController<Message>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();
  bool _isConnected = false;

  Stream<Message> get messageStream => _messageController.stream;
  Stream<bool> get connectionStream => _connectionController.stream;

  void connect({
    required String userId,
    required void Function(Message message) onMessage,
  }) {
    if (_isConnected) return;
    _client = StompClient(
      config: StompConfig(
        url: 'ws://192.168.1.25:8081/websocket',
        onConnect: (StompFrame frame) {
          _isConnected = true;
          _connectionController.add(true);
          print('✅ WebSocket connected for user: $userId');

          _client.subscribe(
            destination: '/user/$userId/queue/messages',
            callback: (StompFrame frame) {
              _handleIncomingMessage(frame, onMessage);
            },
          );
        },
        beforeConnect: () async {
          print('🔄 Connecting WebSocket...');
          _connectionController.add(false);
          await Future.delayed(Duration(milliseconds: 500));
        },
        onStompError: (StompFrame frame) {
          print('❗ STOMP error: ${frame.body}');
          _handleConnectionError();
        },
        onWebSocketError: (dynamic error) {
          print('❌ WebSocket error: $error');
          _handleConnectionError();
        },
        onDisconnect: (StompFrame frame) {
          print('🔌 WebSocket disconnected');
          _handleConnectionError();
        },
        reconnectDelay: Duration(seconds: 5),
        heartbeatIncoming: Duration(seconds: 10),
        heartbeatOutgoing: Duration(seconds: 10),
      ),
    );

    _client.activate();
  }

  void _handleIncomingMessage(StompFrame frame, Function(Message) onMessage) {
    print('📩 Frame received: ${frame.body}');
    if (frame.body != null) {
      try {
        final data = jsonDecode(frame.body!);
        final message = Message.fromJson(data);
        _messageController.add(message);
        print('📤 Emitted to stream: ${message.content}');
        onMessage(message);
      } catch (e) {
        print('❌ Error parsing message: $e');
        _messageController.addError(e);
      }
    } else {
      print('⚠️ Received frame with null body.');
    }
  }

  void _handleConnectionError() {
    _isConnected = false;
    _connectionController.add(false);
  }

  void sendMessage(Message message) {
    if (!_client.connected) {
      print('⚠️ WebSocket not connected. Message not sent.');
      return;
    }

    final jsonBody = jsonEncode(message.toJson());
    _client.send(destination: '/app/chat.send', body: jsonBody);
    print('📤 Sent: ${message.toJson()}');
  }

  Future<void> disconnect() async {
    try {
      if (_isConnected) {
        print('🛑 Disconnecting WebSocket...');
        _client.deactivate(); // No await needed since it returns void
        _isConnected = false;
        _connectionController.add(false);
        print('✅ WebSocket disconnected');
      }
    } catch (e) {
      print('❌ Error during disconnection: $e');
      _connectionController.addError(e);
    }
  }

  Future<void> close() async {
    await disconnect();
    await _messageController.close();
    await _connectionController.close();
    print('♻️ All WebSocket resources cleaned up');
  }
}