import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import 'auth_service.dart';

class BudgetService {
  Future<Map<String, dynamic>> getBudget({int? mes, int? ano}) async {
    final token = await AuthService().getToken();
    if (token == null) throw Exception('Token não encontrado');

    final query = <String, String>{};
    if (mes != null) query['mes'] = mes.toString();
    if (ano != null) query['ano'] = ano.toString();

    final uri = Uri.parse('${ApiConfig.baseUrl}/orcamento').replace(queryParameters: query.isEmpty ? null : query);
    final response = await http.get(uri, headers: ApiConfig.headers(token));
    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar orçamento: ${response.statusCode}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<bool> saveBudget({required int mes, required int ano, required double totalBudget, bool alertEnabled = false}) async {
    final token = await AuthService().getToken();
    if (token == null) throw Exception('Token não encontrado');

    final uri = Uri.parse('${ApiConfig.baseUrl}/orcamento');
    final response = await http.post(
      uri,
      headers: ApiConfig.headers(token),
      body: jsonEncode({
        'month': mes,
        'year': ano,
        'total_budget': totalBudget,
        'alert_enabled': alertEnabled,
      }),
    );

    return response.statusCode == 201 || response.statusCode == 200;
  }
}
