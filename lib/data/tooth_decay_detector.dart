import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _apiKey = 'AIzaSyAsyN-M-HMw9cgv4Cz_gkTCwD7S4Da38oc';
  static const String _url =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_apiKey';

  static Future<Map<String, dynamic>?> analyzeToothImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse(_url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "inlineData": {
                    "mimeType": "image/jpeg",
                    "data": base64Image
                  }
                },
                {
                  "text": '''
You are an expert dental AI.

Analyze the image and answer the following:

1. Estimated percentage of tooth decay (number from 0 to 100).
2. Should the patient see a dentist? (Yes or No)
3. A short explanation (1-2 sentences max).

Respond **only** in this JSON format:
{
  "decay_percentage": "X%",
  "see_dentist": "Yes/No",
  "explanation": "Your explanation here."
}
                '''
                }
              ]
            }
          ]
        }),
      );
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final replyText = result['candidates'][0]['content']['parts'][0]['text'];
        return jsonDecode(replyText);
      } else {
        print("Gemini API error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }}
