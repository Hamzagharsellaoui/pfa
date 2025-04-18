  import 'dart:async';
  import 'dart:convert';
import 'dart:developer';
  import 'package:pfa_flutter/logic/auth/auth_bloc.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
  import 'package:pfa_flutter/chat/models/message_model.dart';

  class WebSocketRepository {
    late StompClient _client;
    final StreamController<Message> _messageController =
    StreamController<Message>.broadcast();

    Stream<Message> get messageStream => _messageController.stream;

    bool get isConnected => _client.connected;

    void connect({
      required String userId,
      required void Function(Message message) onMessage,
    }) {

      _client = StompClient(
        config: StompConfig(
          url: 'ws://192.168.1.25:8081/websocket',

          onConnect: (StompFrame frame) {
            print(' WebSocket connected for user: $userId');
            _client.subscribe(
              destination: '/user/$userId/queue/messages',
              callback: (frame) {
                if (frame.body != null) {
                  try {
                    final data = jsonDecode(frame.body!);
                    final message = Message.fromJson(data);
                    _messageController.add(message);
                    onMessage(message);
                  } catch (e) {
                    print('❌ Error parsing message: $e');
                  }
                }
              },
            );
          },
          beforeConnect: () async {
            print('🔄 Connecting...');
            await Future.delayed(Duration(milliseconds: 500));
          },
          onStompError: (StompFrame frame) {
            print(' STOMP error: ${frame.body}');
          },
          onWebSocketError: (dynamic error) {
            print('WebSocket error: $error');
          },
          onDisconnect: (StompFrame frame) {
            print('🔌 WebSocket disconnected');
          },
          onDebugMessage: (String message) {
            // Optional: print debug info
          },
          heartbeatIncoming: Duration(seconds: 10),
          heartbeatOutgoing: Duration(seconds: 10),
        ),
      );

      _client.activate();
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

    void disconnect() {
      _client.deactivate();
      _messageController.close();
      print('👋 WebSocket client deactivated.');
    }
  }