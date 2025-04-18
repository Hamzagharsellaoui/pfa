import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:pfa_flutter/logic/auth/auth_bloc.dart';
import '../models/ChatModel.dart';
import '../models/message_model.dart';

class ChatRepository {
  final baseUrl = 'http://192.168.1.25:8081/api/v1/chats';


  Future<List<ChatModel>> getUserChats() async {
    final token = await AuthBloc.getToken();
    log("Sending request to: $baseUrl");
    log("Authorization token: ${token ?? 'NULL TOKEN'}");

    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },

      ).timeout(const Duration(seconds: 10));

      log("<<< Response Received >>>");
      log("Status Code: ${response.statusCode}");
      log("Headers: ${response.headers}");
      log("Raw Response Body: ${response.body}");
      log("<<< End Response >>>");

      if (response.statusCode == 200) {
        try {
          final body = jsonDecode(response.body);
          log("Decoded JSON: $body"); // Log decoded JSON

          if (body['data'] is List) {
            final List chats = body['data'];
            log("Number of chats received: ${chats.length}");

            if (chats.isNotEmpty) {
              log("First chat sample: ${chats.first}");
            }

            return chats.map((json) => ChatModel.fromJson(json)).toList();
          } else {
            log("Unexpected data format - data is not a list");
            throw Exception("Unexpected response format. Expected List, got ${body['data']?.runtimeType}");
          }
        } catch (e) {
          log("JSON Decoding Error: $e");
          throw Exception("Failed to parse response: $e");
        }
      } else {
        log("Error Response Body: ${response.body}"); // Detailed error log
        throw Exception("Request failed with status ${response.statusCode}: ${response.reasonPhrase}");
      }
    } on http.ClientException catch (e) {
      log("Network Error: ${e.message}");
      log("Request URL: ${e.uri}");
      rethrow;
    } on TimeoutException {
      log("Request timed out after 10 seconds");
      throw Exception("Connection timeout");
    } catch (e) {
      log("Unexpected error: $e");
      rethrow;
    }
  }
  Future<List<Message>> fetchMessages(String chatId) async {
    final token = await AuthBloc.getToken();
    final response = await http.get(
      Uri.parse('http://192.168.1.14:8081/api/v1/messages/chat/$chatId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      return data.map((item) => Message.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }
}