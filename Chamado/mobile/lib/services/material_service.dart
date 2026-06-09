import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
<<<<<<< HEAD
import '../models/material_model.dart';
import 'auth_service.dart';

class MaterialService {
  final AuthService _authService = AuthService();

  Future<List<MaterialItem>?> getMateriais() async {
    final token = await _authService.getToken();
    if (token == null) return null;

    final url = Uri.parse('${ApiConfig.baseUrl}/materiais');
    try {
      final response = await http.get(url, headers: ApiConfig.headers(token));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // A API retorna { totalizadores: {...}, materiais: [...] }
        final list = data['materiais'] as List;
        return list.map((e) => MaterialItem.fromJson(e)).toList();
      }
      return null;
    } catch (e) {
      print('Erro ao carregar materiais: $e');
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
      final response = await http.delete(url, headers: ApiConfig.headers(token));
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (_) {
      return false;
    }
=======
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
>>>>>>> fa6256c34e6d440e3b2bb93a2b5a899aad3e923c
  }
}
