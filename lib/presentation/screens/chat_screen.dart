import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pfa_flutter/chat/models/message_model.dart';
import 'package:pfa_flutter/logic/blocmessages/chat_screen_bloc.dart';
import 'package:pfa_flutter/logic/blocmessages/chat_screen_state.dart';
import '../../chat/repository/chat_repository.dart';
import '../../chat/websocket/web_socket_repository.dart';
import '../../logic/blocmessages/MessageBubble.dart';
import '../../logic/blocmessages/chat_screen_event.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String receiverId;
  final String receiverName;
  final String chatId;

  const ChatScreen({
    Key? key,
    required this.currentUserId,
    required this.receiverId,
    required this.receiverName,
    required this.chatId,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  late WebSocketRepository _webSocketRepo;

  @override
  void initState() {
    super.initState();
    _webSocketRepo = RepositoryProvider.of<WebSocketRepository>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }



  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatScreenBloc(
        chatRepository: RepositoryProvider.of<ChatRepository>(context),
        webSocketRepository: _webSocketRepo,
        chatId: widget.chatId,
        currentUserId: widget.currentUserId,
      )..add(LoadMessagesEvent(widget.chatId)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          title: Row(
            children: [
              const CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage("assets/images/frikh-3379374-small.gif"),
              ),
              const SizedBox(width: 10),
              Text(
                widget.receiverName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.call, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.videocam, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocConsumer<ChatScreenBloc, ChatScreenState>(
                listener: (context, state) {
                  if (state is MessagesLoadedState) {
                    _scrollToBottom();
                  }
                },
                builder: (context, state) {
                  if (state is MessagesLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is MessagesLoadedState) {
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        return MessageBubble(
                          message: message,
                          isMe: message.senderId == widget.currentUserId,
                          chatId: widget.chatId,
                        );
                      },
                    );
                  }

                  // if (state is MessageErrorState) {
                  //   return Center(child: Text(state.message));
                  // }

                  return const Center(child: Text('Start a conversation!'));
                },
              ),
            ),
            _buildMessageInput(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onSubmitted: (_) => _sendMessage(context),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _sendMessage(context),
          ),
        ],
      ),
    );
  }

  void _sendMessage(BuildContext context) {
    final content = _messageController.text.trim();
    if (content.isNotEmpty) {
      final message = Message(
        content: content,
        senderId: widget.currentUserId,
        receiverId: widget.receiverId,
        chatId: widget.chatId,
        messageType: MessageType.TEXT,
        createdAt: DateTime.now(),
      );

      context.read<ChatScreenBloc>().add(SendMessageEvent(message));
      _messageController.clear();
    }
  }
}