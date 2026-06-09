import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import 'auth_service.dart';

class NotificationService {
  final AuthService _auth = AuthService();

  Future<List<dynamic>?> getNotifications() async {
    final token = await _auth.getToken();
    if (token == null) return null;

    final url = Uri.parse('${ApiConfig.baseUrl}/notifications');
    try {
      final response = await http.get(url, headers: ApiConfig.headers(token));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<bool> markAsRead(String id) async {
    final token = await _auth.getToken();
    if (token == null) return false;

    final url = Uri.parse('${ApiConfig.baseUrl}/notifications/$id/read');
    try {
      final response = await http.post(url, headers: ApiConfig.headers(token));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> markAllAsRead() async {
    final token = await _auth.getToken();
    if (token == null) return false;

    final url = Uri.parse('${ApiConfig.baseUrl}/notifications/read-all');
    try {
      final response = await http.post(url, headers: ApiConfig.headers(token));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
