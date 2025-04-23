import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/routes.dart';
import '../../logic/auth/auth_bloc.dart';
import '../../logic/auth/auth_event.dart';
import '../../logic/auth/auth_state.dart';
import '../widgets/input_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F4F7), // Matching your home screen background
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              children: [
                // Header Section (matches your app bar style)
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Color(0xFF7C3AED), // Your purple color
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.medical_services,
                          size: 50,
                          color: Colors.white,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Form Section
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            InputField(
                              controller: _emailController,
                              hintText: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icon(Icons.email, color: Color(0xFF7C3AED)),
                              validator: (value) => value!.isEmpty ? 'Please enter email' : null, onChanged: (value) {  },
                            ),
                            SizedBox(height: 20),
                            InputField(
                              controller: _passwordController,
                              hintText: 'Password',
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              prefixIcon: Icon(Icons.lock, color: Color(0xFF7C3AED)),
                              validator: (value) => value!.isEmpty ? 'Please enter password' : null, onChanged: (value) {  },
                            ),
                            SizedBox(height: 30),
                            _buildLoginButton(context),
                            SizedBox(height: 20),
                            _buildRegisterButton(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return CircularProgressIndicator(color: Color(0xFF7C3AED));
        }
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<AuthBloc>().add(
                  LoginEvent(
                    _emailController.text.trim(),
                    _passwordController.text.trim(),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF7C3AED),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'LOGIN',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
      child: RichText(
        text: TextSpan(
          text: "Don't have an account? ",
          style: TextStyle(color: Colors.grey[600]),
          children: [
            TextSpan(
              text: 'Register',
              style: TextStyle(
                color: Color(0xFF7C3AED),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}