import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterService {
  static const String baseUrl = 'http://10.0.2.2:8081'; // Android emulator için
  // Gerçek cihaz için IP örneği: 'http://192.168.x.x:8080'

  static Future<bool> registerUser({
    required String fullName,
    required String email,
    required String password,
    required int roleId,
    required String telNumber,
    required String address,
    required String coordinate,
  }) async {
    final url = Uri.parse('$baseUrl/user');

    final Map<String, dynamic> body = {
      "full_name": fullName,
      "email": email,
      "password": password,
      "role_id": roleId,
      "tel_number": telNumber,
      "address": address,
      "coordinate": coordinate,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('🔹 Register API çağrıldı');
      print('➡️ Gönderilen veri: $body');
      print('⬅️ Status Code: ${response.statusCode}');
      print('⬅️ Body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Kayıt API hatası: $e');
      return false;
    }
  }
}
