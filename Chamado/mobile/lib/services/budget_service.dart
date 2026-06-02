import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import 'auth_service.dart';

class BudgetService {
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
  }
}
