import 'package:flutter/material.dart';

class MessageInput extends StatefulWidget {
  final Function(String content) onSend;

  const MessageInput({Key? key, required this.onSend}) : super(key: key);

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),color: Color(0xFF7C3AED),
            onPressed: () {
              final content = _controller.text;
              if (content.isNotEmpty) {
                widget.onSend(content);
                _controller.clear();  // Clear the input after sending
              }
            },
          ),
        ],
      ),
    );
  }
}
