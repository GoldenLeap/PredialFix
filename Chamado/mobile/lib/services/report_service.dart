import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import 'auth_service.dart';

class ReportService {
  Future<Map<String, dynamic>> getReports({String? busca, String? status, String? tipo, int perPage = 10, int page = 1}) async {
    final token = await AuthService().getToken();
    if (token == null) throw Exception('Token não encontrado');

    final query = <String, String>{
      'por_pagina': perPage.toString(),
      'page': page.toString(),
    };

    if (busca != null && busca.isNotEmpty) query['busca'] = busca;
    if (status != null && status.isNotEmpty) query['status'] = status;
    if (tipo != null && tipo.isNotEmpty) query['tipo'] = tipo;

    final uri = Uri.parse('${ApiConfig.baseUrl}/relatorios').replace(queryParameters: query);
    final response = await http.get(uri, headers: ApiConfig.headers(token));
    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar relatórios: ${response.statusCode}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
