import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_config.dart';
import '../models/chamado_model.dart';

class ChamadoService {
  Future<List<Chamado>> getChamados() async {
    final token = await _getToken();
    if (token == null) throw Exception('Token não encontrado');

    final url = Uri.parse('${ApiConfig.baseUrl}/chamados');
    final response = await http.get(
      url,
      headers: ApiConfig.headers(token),
    );

    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body) as List;
      return jsonList.map((json) => Chamado.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar chamados: ${response.statusCode}');
    }
  }

  Future<bool> updateStatus(int id, String status, {String? observacao}) async {
    final token = await _getToken();
    if (token == null) throw Exception('Token não encontrado');

    final url = Uri.parse('${ApiConfig.baseUrl}/chamados/$id');
    final body = {'status': status};
    if (observacao != null && observacao.isNotEmpty) {
      body['observacao'] = observacao;
    }

    final response = await http.put(
      url,
      headers: ApiConfig.headers(token),
      body: jsonEncode(body),
    );

    return response.statusCode == 200;
  }

  Future<Chamado?> createChamado({
    required String tipo,
    required String local,
    required String assunto,
    required String descricao,
    required String prioridade,
    required String tipoServico,
    String? observacao,
  }) async {
    final token = await _getToken();
    if (token == null) throw Exception('Token não encontrado');

    final url = Uri.parse('${ApiConfig.baseUrl}/chamados');
    final body = {
      'tipo': tipo,
      'local': local,
      'assunto': assunto,
      'descricao': descricao,
      'prioridade': prioridade,
      'tipo_servico': tipoServico,
      if (observacao != null && observacao.isNotEmpty)
        'observacao': observacao,
    };

    final response = await http.post(
      url,
      headers: ApiConfig.headers(token),
      body: jsonEncode(body),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Chamado.fromJson(data['data'] ?? data);
    }
    return null;
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}