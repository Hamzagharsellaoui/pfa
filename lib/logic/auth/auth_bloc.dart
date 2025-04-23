import 'dart:developer';
  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
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
        final token = response.data!;
        await saveToken(token);
        final decodedUser = JwtDecoder.decode(token);
        final role = getRoleFromToken(token);

        emit(Authenticated(
          token: token,
          user: decodedUser,
          role: role ?? 'USER', // Default role if not specified
        ));
      }
    } catch (e, stack) {
      log('[BLoC] Error in login', error: e, stackTrace: stack);
      emit(AuthError(message: 'Login failed: ${e.toString()}'));
    }
  }

  Future<void> _handleAppStart(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final token = await getToken();
      if (token != null && !JwtDecoder.isExpired(token)) {
        final decodedUser = JwtDecoder.decode(token);
        final role = getRoleFromToken(token);
        emit(Authenticated(
          token: token,
          user: decodedUser,
          role: role ?? 'USER',
        ));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthError(message: 'Session check failed'));
    }
  }

  Future<void> _handleLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await deleteToken();
    emit(AuthInitial());
  }

  // Token management utilities
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  static String? getRoleFromToken(String token) {
    try {
      final decoded = JwtDecoder.decode(token);
      return decoded['role']?.toString().toUpperCase();
    } catch (e) {
      return null;
    }
  }

  static Future<String?> getEmailFromToken() async {
    final token = await getToken();
    return token != null ? JwtDecoder.decode(token)['email'] : null;
  }

  static Future<String?> getIdFromToken() async {
    final token = await getToken();
    return token != null ? JwtDecoder.decode(token)['userId'] : null;
  }
  static Future<String?> getUsernameFromToken() async {
    final token = await getToken();
    return token != null ? JwtDecoder.decode(token)['username'] : null;
  }

  static AuthBloc of(BuildContext context) {
    return BlocProvider.of<AuthBloc>(context);
  }

}