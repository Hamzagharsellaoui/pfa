import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pfa_flutter/chat/models/message_model.dart';
import 'package:pfa_flutter/logic/blocmessages/chat_screen_bloc.dart';
import 'package:pfa_flutter/logic/blocmessages/chat_screen_event.dart';
import 'package:pfa_flutter/logic/blocmessages/chat_screen_state.dart';

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

  @override
  void initState() {
    super.initState();
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
    const mainColor = Color(0xFF7C3AED);

    return BlocProvider(
      create: (context) => ChatScreenBloc(
        chatRepository: RepositoryProvider.of(context),
        webSocketRepository: RepositoryProvider.of(context),
        chatId: widget.chatId,
        currentUserId: widget.currentUserId,
      )..add(LoadMessagesEvent(widget.chatId)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          foregroundColor: Colors.white,
          title: Row(
            children: [
              const CircleAvatar(
                radius: 18, // Slightly larger profile picture
                backgroundImage: AssetImage(
                  "assets/images/frikh-3379374-small.gif", // Replace with actual receiver profile image
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.receiverName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  // Optional: Add online status
                  // const Text(
                  //   "Online",
                  //   style: TextStyle(fontSize: 12, color: Colors.white70),
                  // ),
                ],
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
              onPressed: () {}, // Implement video call functionality
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
                    return const Center(child: CircularProgressIndicator(color: mainColor));
                  }

                  if (state is MessagesLoadedState) {
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: state.messages.length,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        final isMe = message.senderId == widget.currentUserId;
                        return _buildMessageBubble(message, isMe);
                      },
                    );
                  }

                  if (state is ChatErrorState) {
                    return Center(child: Text(state.message));
                  }

                  return const Center(child: Text('Start a conversation!'));
                },
              ),
            ),
            _buildMessageInput(context, mainColor),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Message message, bool isMe) {
    const senderColor = Colors.deepPurpleAccent;
    final receiverColor = Colors.grey[300]!;
    final textColor = Colors.black87;
    final myTextColor = Colors.white;

    return Align(
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isMe ? senderColor : receiverColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(color: isMe ? myTextColor : textColor),
            ),
            const SizedBox(height: 4),
            Text(
              // Format the timestamp as needed (e.g., "h:mm a")
              "${message.createdAt.hour}:${message.createdAt.minute.toString().padLeft(2, '0')}",
              style: TextStyle(fontSize: 10.0, color: isMe ? myTextColor.withOpacity(0.7) : textColor.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, Color mainColor) {
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
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              ),
              onSubmitted: (_) => _sendMessage(context),
            ),
          ),
          const SizedBox(width: 8.0),
          CircleAvatar(
            backgroundColor: mainColor,
            radius: 24.0,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () => _sendMessage(context),
            ),
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