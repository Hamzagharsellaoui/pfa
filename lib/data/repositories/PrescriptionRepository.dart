import 'dart:convert';
import 'dart:io' as uio;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pfa_flutter/logic/auth/auth_bloc.dart';
import 'package:pfa_flutter/data/models/PrescriptionModel.dart';


class Prescriptionrepository {
  static const String _baseUrl = "http://192.168.1.25:8081/api/users";

  Future<bool> generatePrescription(PrescriptionData data) async {
    try {
      // Step 1: Validate token
      final token = await AuthBloc.getToken();
      if (token == null) {
        debugPrint("Error: No JWT token found. User may not be authenticated.");
        return false;
      }

      debugPrint("JWT Token: $token");
      final decoded = JwtDecoder.decode(token);
      debugPrint("Token Payload: $decoded");
      if (JwtDecoder.isExpired(token)) {
        debugPrint("Error: JWT token is expired.");
        return false;
      }

      // Step 2: Make API call
      debugPrint("Sending POST request to $_baseUrl/generate");
      final response = await http.post(
        Uri.parse("$_baseUrl/generate"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data.toJson()),
      );

      debugPrint("API Response Status: ${response.statusCode}");
      if (response.statusCode != 200) {
        debugPrint("Failed to generate prescription: Status ${response.statusCode}, Body: ${response.body}");
        return false;
      }

      debugPrint("Prescription PDF generated successfully");
      final pdfBytes = response.bodyBytes;
      final fileName = 'prescription_${DateTime.now().toIso8601String()}.pdf';

        // Mobile: Save to Downloads directory
        debugPrint("Accessing Downloads directory");
        final directory = await getDownloadsDirectory();
        if (directory == null) {
          debugPrint("Error: Downloads directory not available.");
          return false;
        }

        debugPrint("Downloads directory: ${directory.path}");
        final filePath = '${directory.path}/$fileName';
        debugPrint("Saving PDF to: $filePath");

        final file = uio.File(filePath);
        await file.writeAsBytes(pdfBytes);
        debugPrint("PDF saved to: $filePath");
        return true;

    } catch (e) {
      debugPrint("Error generating prescription: $e");
      return false;
    }
  }
}