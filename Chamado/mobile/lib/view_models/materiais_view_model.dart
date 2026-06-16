import 'package:flutter/material.dart';
import '../services/material_service.dart';
import '../models/material_model.dart';

class MateriaisViewModel extends ChangeNotifier {
  final MaterialService _service = MaterialService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<MaterialItem> _materiais = [];
  List<MaterialItem> get materiais => _materiais;

  Future<void> loadMateriais() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final data = await _service.getMateriais();
    
    if (data != null) {
      final list = data['materiais'] as List<dynamic>? ?? [];
      _materiais = list.map((m) => MaterialItem.fromJson(m)).toList();
    } else {
      _errorMessage = "Erro ao carregar materiais.";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> saveMaterial(Map<String, dynamic> data, {int? id}) async {
    _isLoading = true;
    notifyListeners();

    bool success;
    if (id == null) {
      success = await _service.createMaterial(data);
    } else {
      success = await _service.updateMaterial(id, data);
    }

    if (success) {
      await loadMateriais();
    } else {
      _errorMessage = "Erro ao salvar material.";
      _isLoading = false;
      notifyListeners();
    }

    return success;
  }

  Future<bool> deleteMaterial(int id) async {
    _isLoading = true;
    notifyListeners();

    final success = await _service.deleteMaterial(id);
    if (success) {
      await loadMateriais();
    } else {
      _errorMessage = "Erro ao excluir material.";
      _isLoading = false;
      notifyListeners();
    }
    return success;
  }
}
