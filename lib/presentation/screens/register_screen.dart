import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pfa_flutter/data/repositories/auth_repository.dart';
import '../../core/routes.dart';
import '../../logic/auth/auth_state.dart';
import '../../logic/register/register_event.dart';
import '../widgets/input_field.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'Patient';
  final AuthRepository authRepository = AuthRepository();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F4F7),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            children: [
              Container(
                height: 220,
                decoration: BoxDecoration(
                  color: Color(0xFF7C3AED),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 40,
                      child: SizedBox(
                        width: 250,
                        height: 200,
                        child: Lottie.asset('assets/register_animation.json'),
                      ),
                    ),
                  ],
                ),
              ),

              // Registration Form
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
                          // First Name
                          InputField(
                            controller: _firstNameController,
                            hintText: 'First Name',
                            prefixIcon: Icon(
                              Icons.person,
                              color: Color(0xFF7C3AED),
                            ),
                            validator:
                                (value) =>
                                    value!.isEmpty
                                        ? 'Please enter first name'
                                        : null,
                            onChanged: (value) {},
                            keyboardType: TextInputType.name,
                          ),
                          SizedBox(height: 20),

                          // Last Name
                          InputField(
                            controller: _lastNameController,
                            hintText: 'Last Name',
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Color(0xFF7C3AED),
                            ),
                            validator:
                                (value) =>
                                    value!.isEmpty
                                        ? 'Please enter last name'
                                        : null,
                            onChanged: (value) {},
                            keyboardType: TextInputType.name,
                          ),
                          SizedBox(height: 20),

                          // Email
                          InputField(
                            controller: _emailController,
                            hintText: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icon(
                              Icons.email,
                              color: Color(0xFF7C3AED),
                            ),
                            validator:
                                (value) =>
                                    value!.isEmpty
                                        ? 'Please enter email'
                                        : null,
                            onChanged: (value) {},
                          ),
                          SizedBox(height: 20),

                          // Password
                          InputField(
                            controller: _passwordController,
                            hintText: 'Password',
                            obscureText: true,
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Color(0xFF7C3AED),
                            ),
                            validator:
                                (value) =>
                                    value!.isEmpty
                                        ? 'Please enter password'
                                        : null,
                            onChanged: (value) {},
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(height: 20),

                          // Role Selection
                          DropdownButtonFormField<String>(
                            value: _selectedRole,
                            decoration: InputDecoration(
                              labelText: 'Role',
                              prefixIcon: Icon(
                                Icons.medical_services,
                                color: Color(0xFF7C3AED),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            items:
                                ['Patient', 'Doctor'].map((String role) {
                                  return DropdownMenuItem<String>(
                                    value: role,
                                    child: Text(role),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedRole = value!;
                              });
                            },
                            validator:
                                (value) =>
                                    value == null ? 'Please select role' : null,
                          ),
                          SizedBox(height: 30),

                          // Register Button
                          _buildRegisterButton(context),
                          SizedBox(height: 20),

                          // Login Link
                          _buildLoginButton(context),
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
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          authRepository.register(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            email: _emailController.text,
            password: _passwordController.text,
            role: _selectedRole,
          );
          Navigator.pushNamed(context, AppRoutes.login);
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
          'Register',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: RichText(
        text: TextSpan(
          text: "Already have an account? ",
          style: TextStyle(color: Colors.grey[600]),
          children: [
            TextSpan(
              text: 'Login',
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
