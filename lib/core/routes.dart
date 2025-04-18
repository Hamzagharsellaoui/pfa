import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/auth_repository.dart';
import '../logic/auth/auth_bloc.dart';
import '../logic/auth/auth_state.dart';
import '../presentation/screens/calendar_screen.dart';
import '../presentation/screens/chat_screen.dart';
import '../presentation/screens/contacts_chat_screen.dart';
import '../presentation/screens/login_screen.dart';

import '../presentation/screens/profile_screen.dart';
import '../presentation/screens/search_screen.dart';
import '../presentation/widgets/main_scaffold_widget.dart';

// main.dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(AuthRepository()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthWrapper(),
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        log('[AuthWrapper] Current state: ${state.runtimeType}');

        if (state is Authenticated) {
          log('[AuthWrapper] Navigating to Home');
          return MainScaffold();
        }
        if (state is AuthLoading) return _LoadingScreen();
        return LoginScreen();
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class ChatScreenArguments {
  final String currentUserId;
  final String receiverId;
  final String receiverName;
  final String chatId;

  ChatScreenArguments({
    required this.currentUserId,
    required this.receiverId,
    required this.chatId,
    required this.receiverName,
  });
}

class AppRoutes {
  static const String initial = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String calendar = '/calendar';
  static const String search = '/search';
  static const String contacts = '/contacts';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        return MaterialPageRoute(builder: (_) => AuthWrapper());

      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case home:
        return MaterialPageRoute(builder: (_) => MainScaffold());

      case profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen());

      case calendar:
        return MaterialPageRoute(builder: (_) => CalendarScreen());

      case search:
        return MaterialPageRoute(builder: (_) => SearchScreen());

      case contacts:
        return MaterialPageRoute(builder: (_) => ContactsChatScreen());
      case chat:
        final args = settings.arguments as ChatScreenArguments;
        return MaterialPageRoute(
          builder: (_) => ChatScreen(
            chatId: args.chatId,
            currentUserId: args.currentUserId,
            receiverId: args.receiverId,
            receiverName: args.receiverName,
          ),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('Page not found!')),
        );
      },
    );
  }

  // Optional: Helper method for navigation with arguments
  static Future<dynamic> pushNamed(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }
}
