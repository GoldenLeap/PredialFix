import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../models/material_model.dart';
import 'auth_service.dart';

class MaterialService {
  final AuthService _authService = AuthService();

  /// Retorna todos os materiais com totalizadores de estoque
  Future<Map<String, dynamic>?> getMateriais({String? busca}) async {
    final token = await _authService.getToken();
    if (token == null) return null;

    final query = <String, String>{};
    if (busca != null && busca.isNotEmpty) query['busca'] = busca;

    final uri = Uri.parse('${ApiConfig.baseUrl}/materiais')
        .replace(queryParameters: query.isEmpty ? null : query);

    try {
      final response = await http.get(uri, headers: ApiConfig.headers(token));
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> createMaterial(Map<String, dynamic> materialData) async {
    final token = await _authService.getToken();
    if (token == null) return false;

    final url = Uri.parse('${ApiConfig.baseUrl}/materiais');
    try {
      final response = await http.post(
        url,
        headers: ApiConfig.headers(token),
        body: jsonEncode(materialData),
      );
      return response.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateMaterial(int id, Map<String, dynamic> materialData) async {
    final token = await _authService.getToken();
    if (token == null) return false;

    final url = Uri.parse('${ApiConfig.baseUrl}/materiais/$id');
    try {
      final response = await http.put(
        url,
        headers: ApiConfig.headers(token),
        body: jsonEncode(materialData),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteMaterial(int id) async {
    final token = await _authService.getToken();
    if (token == null) return false;

    final url = Uri.parse('${ApiConfig.baseUrl}/materiais/$id');
    try {
      final response =
          await http.delete(url, headers: ApiConfig.headers(token));
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (_) {
      return false;
    }
  }
}
