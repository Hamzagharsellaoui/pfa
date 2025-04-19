import 'dart:developer';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:pfa_flutter/chat/websocket/web_socket_repository.dart';

import '../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo;
  static final _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  AuthBloc(this.repo) : super(AuthInitial()) {
    on<LoginEvent>(_handleLogin);
    on<AppStarted>(_handleAppStart);
    on<LogoutEvent>(_handleLogout);
  }


  Future<void> _handleLogin(LoginEvent event, Emitter<AuthState> emit) async {
    log('[BLoC] Login event received');
    try {
      emit(AuthLoading());
      final response = await repo.login(event.email, event.password);
      if (response.error) {
        emit(AuthError(message: response.message));
      } else {
        await saveToken(response.data!);
        final decodedUser = JwtDecoder.decode(response.data!);
        emit(Authenticated(token: response.data!, user: decodedUser));
      }
    } catch (e, stack) {
      log('[BLoC] Error in login', error: e, stackTrace: stack);
      emit(AuthError(message: 'System error: ${e.toString()}'));
    }
  }

  Future<void> _handleAppStart(AppStarted event,
      Emitter<AuthState> emit) async {
    final token = await getToken();
    if (token != null && !JwtDecoder.isExpired(token)) {
      final decodedUser = JwtDecoder.decode(token);
      emit(Authenticated(token: token, user: decodedUser));
    }
  }

  Future<void> _handleLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await deleteToken();
    emit(AuthInitial());
    WebSocketRepository().disconnect();
  }

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  static Future<Map<String, dynamic>?> decodeToken() async {
    final token = await getToken();
    if (token == null) return null;
    return JwtDecoder.decode(token);
  }

  static Future<String?> getUsernameFromToken() async {
    final decoded = await decodeToken();
    return decoded?['username'];
  }
  static Future<String?> getIdFromeToken() async {
    final decoded = await decodeToken();
    return decoded?['userId'];
  }
  static AuthBloc of(BuildContext context) {
    return BlocProvider.of<AuthBloc>(context);
  }

}


