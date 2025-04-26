  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:pfa_flutter/presentation/screens/chat_screen.dart';
  import 'package:pfa_flutter/presentation/screens/register_screen.dart';
import 'package:pfa_flutter/presentation/screens/doctor/doctor_scaffold_widget.dart';
  import 'package:pfa_flutter/presentation/widgets/main_scaffold_widget.dart';
  import 'chat/bloc/chat_bloc.dart';
  import 'chat/bloc/chat_event.dart';
  import 'chat/repository/chat_repository.dart';
  import 'chat/websocket/web_socket_repository.dart';
  import 'core/routes.dart';
  import 'data/repositories/auth_repository.dart';
  import 'logic/auth/auth_bloc.dart';
  import 'logic/auth/auth_event.dart';
  import 'logic/auth/auth_state.dart';
  import 'logic/blocmessages/chat_screen_bloc.dart';
  import 'navigation/NavigationCubit.dart';
  import 'presentation/screens/login_screen.dart';

  void main() {
    runApp(MyApp());
  }

  class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc(AuthRepository())..add(AppStarted())),
          BlocProvider(create: (_) => NavigationCubit()),
          RepositoryProvider(create: (_) => ChatRepository()),
          RepositoryProvider(create: (_) => WebSocketRepository()),
          BlocProvider(
            create: (context) => ChatBloc(
              chatRepository: RepositoryProvider.of<ChatRepository>(context),
              webSocketRepository: RepositoryProvider.of<WebSocketRepository>(context),
            )..add(LoadChatsEvent()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.initial,
          onGenerateRoute: AppRoutes.generateRoute,
        ),
      );

    }
  }

  class AppRoutes {
    static const String initial = '/';
    static const String home = '/home';
    static const String login = '/login';
    static const String register = '/register';
    static const String chat = '/chat';

    static Route<dynamic> generateRoute(RouteSettings settings) {
      switch (settings.name) {
        case initial:
          return MaterialPageRoute(builder: (_) => AuthWrapper());
        case home:
          final role = settings.arguments as String? ?? 'PATIENT';
          return MaterialPageRoute(
            builder: (_) => role == 'DOCTOR'
                ? DoctorMainScaffold()
                : PatientMainScaffold(),
          );
        case login:
          return MaterialPageRoute(builder: (_) => LoginScreen());
        case register:
          return MaterialPageRoute(builder: (_) => RegisterScreen());
        case chat:
          final args = settings.arguments as ChatScreenArguments;
          return MaterialPageRoute(
            builder: (context) => BlocProvider<ChatScreenBloc>(
              create: (_) => ChatScreenBloc(
                chatRepository: RepositoryProvider.of<ChatRepository>(context),
                webSocketRepository: RepositoryProvider.of<WebSocketRepository>(context), chatId: args.chatId, currentUserId: args.currentUserId,
              ),
              child: ChatScreen(
                chatId: args.chatId,
                currentUserId: args.currentUserId,
                receiverId: args.receiverId,
                receiverName: args.receiverName,
              ),
            ),
          );
        default:
          return _errorRoute();
      }
    }

    static Route<dynamic> _errorRoute() {
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('Page not found!')),
        ),
      );
    }
  }

  class AuthWrapper extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return BlocProvider.value(
              value: BlocProvider.of<NavigationCubit>(context),
              child: state.role == 'DOCTOR'
                  ? DoctorMainScaffold()
                  : PatientMainScaffold(),
            );
          }
          if (state is AuthLoading) return _LoadingScreen();
          return PatientMainScaffold();
        },
      );
    }
  }

  class _LoadingScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }
