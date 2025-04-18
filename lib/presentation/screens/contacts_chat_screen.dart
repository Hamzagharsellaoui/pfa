import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../chat/bloc/chat_bloc.dart';
import '../../chat/bloc/chat_state.dart';
import '../../chat/bloc/chat_event.dart';
import '../../core/routes.dart';
import '../../logic/auth/auth_bloc.dart';
import '../../logic/auth/auth_state.dart';

class ContactsChatScreen extends StatefulWidget {
  ContactsChatScreen({super.key});

  @override
  State<ContactsChatScreen> createState() => _ContactsChatScreenState();
}

class _ContactsChatScreenState extends State<ContactsChatScreen> {
  late Future<String?> currentUserId;

  @override
  void initState() {
    super.initState();
    final authState = AuthBloc.of(context).state;
    if (authState is Authenticated) {
      currentUserId = AuthBloc.getIdFromeToken();
      log('Current User ID: $currentUserId');
      context.read<ChatBloc>().add(LoadChatsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    log('Current User ID: $currentUserId');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Chats",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatLoaded) {
            if (state.chats.isEmpty) {
              return const Center(child: Text("No chats yet"));
            }

            return FutureBuilder<String?>(
              future: currentUserId,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text("No user ID found"));
                }

                final resolvedUserId = snapshot.data!;
                log('Resolved User ID: $resolvedUserId');

                return ListView.builder(
                  itemCount: state.chats.length,
                  itemBuilder: (context, index) {
                    final chat = state.chats[index];

                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(chat.name[0].toUpperCase()),
                      ),
                      title: Text(chat.name),
                      subtitle: Text(chat.lastMessage ?? "No message yet"),
                      trailing: chat.lastMessageTime != null
                          ? Text(chat.lastMessageTime!)
                          : null,
                      onTap: () {
                        final chatArgs = ChatScreenArguments(
                          currentUserId: resolvedUserId,
                          receiverId: chat.recipientId,
                          receiverName: chat.name,
                          chatId: chat.id,
                        );
                        log('Chat Arguments - currentUserId: ${chatArgs.currentUserId}');
                        log('Chat Arguments - receiverId: ${chatArgs.receiverId}');
                        log('Chat Arguments - receiverName: ${chatArgs.receiverName}');
                        log('Chat Arguments - chatId: ${chatArgs.chatId}');

                        AppRoutes.pushNamed(context, AppRoutes.chat, arguments: chatArgs);
                      },
                    );
                  },
                );
              },
            );
          } else if (state is ChatError) {
            return Center(child: Text(state.error));
          }
          return const Center(child: Text("Start chatting!"));
        },
      ),
    );
  }
}
