import '../auth/auth_event.dart';

class RegisterEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String role;

  RegisterEvent({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.role,
  });

  @override
  List<Object> get props => [firstName, lastName, email, password, role];
}