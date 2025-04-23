abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  LoginEvent(this.email, this.password);
}
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
}
class LogoutEvent extends AuthEvent {}
class AppStarted extends AuthEvent {}
