import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../chat/bloc/chat_bloc.dart';
import '../../chat/bloc/chat_event.dart';
import '../../chat/bloc/chat_state.dart';
import '../../core/routes.dart';
import '../../logic/auth/auth_bloc.dart';
import '../../logic/auth/auth_state.dart';

class ContactsChatScreen extends StatefulWidget {
  const ContactsChatScreen({super.key});

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
      currentUserId = AuthBloc.getIdFromToken();
      log('Current User ID: $currentUserId');
      context.read<ChatBloc>().add(LoadChatsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFF7C3AED);
    const backgroundColor = Color(0xFFF4F4F7);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0,
        title: const Text(
          "Chats", // More concise title like Messenger
          style: TextStyle(
            fontSize: 22, // Slightly larger title
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize( // Optional: Add a subtle bottom border or search bar
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16), // Reduced horizontal padding
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatLoading) {
              return const Center(child: CircularProgressIndicator(color: mainColor));
            } else if (state is ChatLoaded) {
              if (state.chats.isEmpty) {
                return const Center(
                  child: Text(
                    "No chats yet",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return FutureBuilder<String?>(
                future: currentUserId,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: mainColor));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text("No user ID found"));
                  }

                  final resolvedUserId = snapshot.data!;
                  log('Resolved User ID: $resolvedUserId');

                  return ListView.separated( // Use ListView.separated for dividers
                    itemCount: state.chats.length,
                    separatorBuilder: (context, index) => const Divider(indent: 70), // Subtle divider
                    itemBuilder: (context, index) {
                      final chat = state.chats[index];
                      return InkWell( // Use InkWell for better tap feedback
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

                          AppRoutes.pushNamed(context, AppRoutes.chat,
                              arguments: chatArgs);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 28, // Slightly larger profile picture
                                backgroundColor: mainColor,
                                child: Text(
                                  chat.name[0].toUpperCase(),
                                  style: const TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chat.name,
                                      style: const TextStyle(
                                        fontSize: 17, // Slightly larger username
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      chat.lastMessage ?? "No message yet",
                                      overflow: TextOverflow.ellipsis, // Handle long messages
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (chat.lastMessageTime != null)
                                Text(
                                  chat.lastMessageTime!,
                                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is ChatError) {
              return Center(child: Text(state.error));
            }
            return const Center(
              child: Text(
                "Start chatting!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        child: const Icon(Icons.message, color: Colors.white),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Start a new chat - feature coming soon!")),
          );
        },
      ),
    );
  }
}