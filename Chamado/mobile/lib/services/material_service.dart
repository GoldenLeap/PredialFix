import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import 'auth_service.dart';

class MaterialService {
  Future<Map<String, dynamic>> getMaterials({String? busca}) async {
    final token = await AuthService().getToken();
    if (token == null) throw Exception('Token não encontrado');

    final query = <String, String>{};
    if (busca != null && busca.isNotEmpty) query['busca'] = busca;

    final uri = Uri.parse('${ApiConfig.baseUrl}/materiais').replace(queryParameters: query.isEmpty ? null : query);
    final response = await http.get(uri, headers: ApiConfig.headers(token));
    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar materiais: ${response.statusCode}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
