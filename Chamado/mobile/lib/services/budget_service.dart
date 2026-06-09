import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import 'auth_service.dart';

class BudgetService {
<<<<<<< HEAD
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>?> getBudgetInfo(int mes, int ano) async {
    final token = await _authService.getToken();
    if (token == null) return null;

    final url = Uri.parse('${ApiConfig.baseUrl}/orcamento?mes=$mes&ano=$ano');
    try {
      final response = await http.get(url, headers: ApiConfig.headers(token));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Erro ao carregar orçamento: $e');
      return null;
    }
  }

  Future<bool> defineBudget(int mes, int ano, double valorTotal) async {
    final token = await _authService.getToken();
    if (token == null) return false;

    final url = Uri.parse('${ApiConfig.baseUrl}/orcamento');
    try {
      final response = await http.post(
        url,
        headers: ApiConfig.headers(token),
        body: jsonEncode({
          // Nomes corretos que a API espera
          'month': mes,
          'year': ano,
          'total_budget': valorTotal,
        }),
      );
      
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Erro ao salvar orçamento: $e');
      return false;
    }
=======
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
>>>>>>> fa6256c34e6d440e3b2bb93a2b5a899aad3e923c
  }
}
