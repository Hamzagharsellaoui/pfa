import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/base_response_model.dart';

class AuthRepository {
  final url = Uri.parse('http://192.168.0.119:8081/Auth/login');
  final http.Client client;

  AuthRepository({http.Client? client}) : client = client ?? http.Client();

  Future<BaseResponseModel<String>> login(String email, String password) async {
    final url = Uri.parse('http://192.168.0.119:8081/Auth/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'email': email, 'password': password});

    try {
      final response = await http.post(url, headers: headers, body: body);
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = jsonResponse['data']['token'] as String?;

        if (token != null) {
          return BaseResponseModel<String>(
            message: jsonResponse['message'],
            error: jsonResponse['error'],
            status: response.statusCode,
            data: token,
          );
        }

        return BaseResponseModel<String>(
          message: 'Token missing in response structure',
          error: true,
          status: response.statusCode,
          data: null,
        );
      }

      return BaseResponseModel<String>(
        message: jsonResponse['message'] ?? 'Login failed',
        error: true,
        status: response.statusCode,
        data: null,
      );

    } catch (e) {
      return BaseResponseModel<String>(
        message: 'Login error: ${e.toString()}',
        error: true,
        status: -1,
        data: null,
      );
    }
  }
  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String role,
  }) async {
    final url = Uri.parse('http://192.168.0.119:8081/Auth/Register');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'firstName': firstName,
      'LastName': lastName,
      'email': email,
      'password': password,
      'role': role.toUpperCase(),
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'error': data['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }}

