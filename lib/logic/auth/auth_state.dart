import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String token;
  final Map<String, dynamic> user;
  final String role;

  Authenticated({required this.token, required this.user, required this.role});

  @override
  List<Object?> get props => [token, user];
}
class AuthSuccess extends AuthState{}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
