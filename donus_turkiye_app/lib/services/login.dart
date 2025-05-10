import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080'; // Android emulator
  // Gerçek cihaz kullanıyorsan: 192.168.x.x gibi yerel IP adresini yaz.

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

      return response.statusCode == 200;
    } catch (e) {
      print("❌ Login API hatası: $e");
      return false;
    }
  }
}
