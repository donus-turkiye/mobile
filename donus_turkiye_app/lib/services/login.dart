// lib/services/login.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_storage.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8081';

  static Future<bool> login({
    String? telNumber,
    String? email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/login');

      final Map<String, dynamic> body = {
        'password': password,
      };

      if (email != null) {
        body['email'] = email;
      } else if (telNumber != null) {
        body['tel_number'] = telNumber;
      }

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print("➡️ Login body: $body");
      print("⬅️ Status: ${response.statusCode}");
      print("⬅️ Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        final int userId = jsonResponse['user_data']['user_id'];
        final sessionId = response.headers['x-session-id'];
        print('🔑 Session ID alındı: $sessionId');
        if (sessionId != null) {
          await AuthStorage.saveSessionId(sessionId);
        }

        await AuthStorage.saveUserId(userId.toString());
        if (sessionId != null) {
          await AuthStorage.saveSessionId(sessionId);
        }

        return true;
      }

      return false;
    } catch (e) {
      print("❌ Login API hatası: $e");
      return false;
    }
  }
}
