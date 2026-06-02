import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
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
  }
}
