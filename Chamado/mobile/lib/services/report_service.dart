import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import 'auth_service.dart';

class ReportService {
<<<<<<< HEAD
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>?> fetchRelatorios({
    String busca = '',
    String status = '',
    String prioridade = '',
    String tipo = '',
    String dataInicio = '',
    String dataFim = '',
    int pagina = 1,
  }) async {
    final token = await _authService.getToken();
    if (token == null) return null;

    final queryParams = [
      if (busca.isNotEmpty) 'busca=$busca',
      if (status.isNotEmpty) 'status=$status',
      if (prioridade.isNotEmpty) 'prioridade=$prioridade',
      if (tipo.isNotEmpty) 'tipo=$tipo',
      if (dataInicio.isNotEmpty) 'data_inicio=$dataInicio',
      if (dataFim.isNotEmpty) 'data_fim=$dataFim',
      'page=$pagina',
      'por_pagina=15',
    ].join('&');

    final url = Uri.parse('${ApiConfig.baseUrl}/relatorios?$queryParams');
    
    try {
      final response = await http.get(url, headers: ApiConfig.headers(token));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // A API retorna 'relatorio' (paginado) e 'totalizadores'
        final relatorio = data['relatorio'];
        final items = relatorio['data'] as List;
        
        return {
          'items': items, // Lista de Maps com campos transformados pela API
          'totalizadores': data['totalizadores'],
          'ultima_pagina': relatorio['last_page'],
        };
      }
      return null;
    } catch (e) {
      print('Erro ao carregar relatórios: $e');
      return null;
    }
=======
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
>>>>>>> fa6256c34e6d440e3b2bb93a2b5a899aad3e923c
  }
}
