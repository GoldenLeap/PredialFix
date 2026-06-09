import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import 'auth_service.dart';

class DashboardService {
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>?> getDashboardData(int month, int year) async {
    final token = await _authService.getToken();
    if (token == null) return null;

    final url = Uri.parse('${ApiConfig.baseUrl}/dashboard?mes=$month&ano=$year');
    try {
      final response = await http.get(url, headers: ApiConfig.headers(token));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
