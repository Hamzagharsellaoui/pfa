import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/base_response_model.dart';

class AuthRepository {
  final url = Uri.parse('http://192.168.1.25'
      ':8081/Auth/login');
  final http.Client client;

  AuthRepository({http.Client? client}) : client = client ?? http.Client();

  Future<BaseResponseModel<String>> login(String email, String password) async {
    final url = Uri.parse('http://192.168.1.25:8081/Auth/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'email': email, 'password': password});

    try {
      final response = await http.post(url, headers: headers, body: body);
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Proper nested access
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
  }}

