// lib/services/user_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'auth_storage.dart';

class UserService {
  static const String baseUrl = 'http://10.0.2.2:8081';

  static Future<UserModel?> getCurrentUser() async {
    final sessionId = await AuthStorage.getSessionId(); // Session ID’yi al
    if (sessionId == null) {
      print("❌ Oturum ID bulunamadı");
      return null;
    }

    final url = Uri.parse('$baseUrl/user');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-Session-ID': sessionId, // 👈 Header'a session ID'yi koy
        },

      );

      print("📥 /user GET status: ${response.statusCode}");
      print("📥 /user GET body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final userMap = jsonData['user'];
        return UserModel.fromJson(userMap);
      } else {
        print("❌ Kullanıcı bilgisi alınamadı: ${response.statusCode} ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Kullanıcı getirme hatası: $e");
      return null;
    }
  }
}
