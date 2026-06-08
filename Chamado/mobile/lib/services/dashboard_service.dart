import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import 'auth_service.dart';

class DashboardService {
  Future<Map<String, dynamic>> getDashboard({int? mes, int? ano}) async {
    final token = await AuthService().getToken();
    if (token == null) throw Exception('Token não encontrado');

    final query = <String, String>{};
    if (mes != null) query['mes'] = mes.toString();
    if (ano != null) query['ano'] = ano.toString();

    final uri = Uri.parse('${ApiConfig.baseUrl}/dashboard').replace(queryParameters: query.isEmpty ? null : query);
    final response = await http.get(uri, headers: ApiConfig.headers(token));
    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar dashboard: ${response.statusCode}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
