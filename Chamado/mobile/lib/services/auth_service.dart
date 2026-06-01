import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_config.dart';

class AuthService {
  // Logar
  Future<bool> login(String email, String password) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/login");

    try {
      final response = await http.post(
        url,
        headers: ApiConfig.headers(),
        body: jsonEncode({
          'email': email,
          'password': password,
          'device_name': 'android_phone',
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('user_name', data['user']['name']);
        await prefs.setString('user_email', data['user']['email']);
        await prefs.setString('user_cargo', data['user']['cargo']);
        await prefs.setInt('user_id', data['user']['id']);
        return true;
      } else {
        print('Erro no login ${response.body}');
        return false;
      }
    } catch (e) {
      print("Erro de conexão $e");
      return false;
    }
  }

  // Pegar o token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name');
    final email = prefs.getString('user_email');
    final cargo = prefs.getString('user_cargo');
    final id = prefs.getInt('user_id');
    if (name == null) return null;
    return {
      'name': name,
      'email': email ?? '',
      'cargo': cargo ?? '',
      'id': id ?? 0,
    };
  }

  Future<bool> updateProfile(String name, String email) async {
    final token = await getToken();
    if (token == null) return false;

    final url = Uri.parse("${ApiConfig.baseUrl}/profile");
    try {
      final response = await http.put(
        url,
        headers: ApiConfig.headers(token),
        body: jsonEncode({
          'name': name,
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_name', data['user']['name']);
        await prefs.setString('user_email', data['user']['email']);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updatePassword(String currentPassword, String password, String passwordConfirmation) async {
    final token = await getToken();
    if (token == null) return false;

    final url = Uri.parse("${ApiConfig.baseUrl}/profile/password");
    try {
      final response = await http.put(
        url,
        headers: ApiConfig.headers(token),
        body: jsonEncode({
          'current_password': currentPassword,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> logout() async {
    final token = await getToken();
    if (token != null) {
      try {
        await http.post(
          Uri.parse('${ApiConfig.baseUrl}/logout'),
          headers: ApiConfig.headers(token),
        );
      } catch (_) {}
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    return true;
  }
}
