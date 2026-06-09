import 'dart:convert';
import 'dart:async';
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

  Future<bool> updateStatus(
    int id, 
    String status, {
    String? observacao,
    int? tecnicoId,
    double? custoMaoObra,
    double? custoMateriais,
  }) async {
    final token = await _getToken();
    if (token == null) throw Exception('Token não encontrado');

    final url = Uri.parse('${ApiConfig.baseUrl}/chamados/$id');
    final body = <String, dynamic>{'status': status};
    if (observacao != null && observacao.isNotEmpty) {
      body['observacao'] = observacao;
    }
    if (tecnicoId != null) {
      body['tecnico_id'] = tecnicoId;
    }
    if (custoMaoObra != null) {
      body['custo_mao_obra'] = custoMaoObra;
    }
    if (custoMateriais != null) {
      body['custo_materiais'] = custoMateriais;
    }

    final response = await http.put(
      url,
      headers: ApiConfig.headers(token),
      body: jsonEncode(body),
    );

    return response.statusCode == 200;
  }

  Future<List<Map<String, dynamic>>?> getTecnicos() async {
    final token = await _getToken();
    if (token == null) throw Exception('Token não encontrado');

    final url = Uri.parse('${ApiConfig.baseUrl}/tecnicos');
    try {
      final response = await http.get(
        url,
        headers: ApiConfig.headers(token),
      );

      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List;
        return list.map((e) => Map<String, dynamic>.from(e)).toList();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<Chamado?> createChamado({
    required String tipo,
    required String local,
    required String assunto,
    required String descricao,
    required String prioridade,
    required String tipoServico,
    String? observacao,
    String? imagemPath,
  }) async {
    final token = await _getToken();
    if (token == null) throw Exception('Token não encontrado');

    final url = Uri.parse('${ApiConfig.baseUrl}/chamados');
    final headers = ApiConfig.headers(token);
    headers.remove('Content-Type');

    final request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);

    request.fields['tipo'] = tipo;
    request.fields['local'] = local;
    request.fields['assunto'] = assunto;
    request.fields['descricao'] = descricao;
    request.fields['prioridade'] = prioridade;
    request.fields['tipo_servico'] = tipoServico;
    if (observacao != null && observacao.isNotEmpty) {
      request.fields['observacao'] = observacao;
    }

    if (imagemPath != null && imagemPath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('imagem', imagemPath));
    }

    final streamedResponse = await request.send().timeout(
      const Duration(seconds: 60),
      onTimeout: () {
        throw TimeoutException('O servidor demorou demais para responder.');
      },
    );
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Chamado.fromJson(data['data'] ?? data);
    }
    return null;
  }

  Future<bool> adicionarMaterial(int chamadoId, int materialId, int quantidade) async {
    final token = await _getToken();
    if (token == null) return false;

    final url = Uri.parse('${ApiConfig.baseUrl}/chamados/$chamadoId/materiais');
    final response = await http.post(
      url,
      headers: ApiConfig.headers(token),
      body: jsonEncode({
        'material_id': materialId,
        'quantidade': quantidade,
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> solicitarMaterial(int chamadoId, String observacao) async {
    final token = await _getToken();
    if (token == null) return false;

    final url = Uri.parse('${ApiConfig.baseUrl}/chamados/$chamadoId/solicitar-material');
    final response = await http.post(
      url,
      headers: ApiConfig.headers(token),
      body: jsonEncode({
        'observacao': observacao,
      }),
    );
    return response.statusCode == 200;
  }

  Future<bool> uploadEvidencias(int chamadoId, List<String> filePaths, List<String> tipos) async {
    final token = await _getToken();
    if (token == null) return false;

    final url = Uri.parse('${ApiConfig.baseUrl}/chamados/$chamadoId/evidencias');
    final headers = ApiConfig.headers(token);
    headers.remove('Content-Type');

    final request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);

    for (int i = 0; i < filePaths.length; i++) {
      request.files.add(await http.MultipartFile.fromPath('evidencias[]', filePaths[i]));
      request.fields['tipos[$i]'] = tipos[i];
    }

    final streamedResponse = await request.send();
    return streamedResponse.statusCode == 200 || streamedResponse.statusCode == 201;
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}