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

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _selectedCategory = '';
  String get selectedCategory => _selectedCategory;

  void setSearchQuery(String val) {
    _searchQuery = val;
    notifyListeners();
  }

  void setSelectedCategory(String val) {
    _selectedCategory = val;
    notifyListeners();
  }

  List<String> get categories {
    final cats = _materiais.map((m) => m.categoria).toSet().toList();
    cats.sort();
    return cats;
  }

  List<MaterialItem> get filteredMateriais {
    var result = _materiais;
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((m) => 
        m.nome.toLowerCase().contains(q) || 
        m.categoria.toLowerCase().contains(q) || 
        m.localizacao.toLowerCase().contains(q)
      ).toList();
    }
    if (_selectedCategory.isNotEmpty) {
      result = result.where((m) => m.categoria == _selectedCategory).toList();
    }
    return result;
  }

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
