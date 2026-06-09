import 'package:flutter/material.dart';
import '../services/report_service.dart';

class RelatoriosViewModel extends ChangeNotifier {
  final ReportService _service = ReportService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Items são Maps simples (a API já transforma os campos)
  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> get items => _items;

  Map<String, dynamic> _totalizadores = {};
  Map<String, dynamic> get totalizadores => _totalizadores;

  int _currentPage = 1;
  int _lastPage = 1;
  bool get hasMorePages => _currentPage < _lastPage;

  // Filtros
  String busca = '';
  String status = '';
  String prioridade = '';
  String tipo = '';
  String dataInicio = '';
  String dataFim = '';

  void resetFilters() {
    busca = '';
    status = '';
    prioridade = '';
    tipo = '';
    dataInicio = '';
    dataFim = '';
    loadReports(reset: true);
  }

  Future<void> loadReports({bool reset = false}) async {
    if (reset) {
      _currentPage = 1;
      _items.clear();
    }
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final data = await _service.fetchRelatorios(
      busca: busca,
      status: status,
      prioridade: prioridade,
      tipo: tipo,
      dataInicio: dataInicio,
      dataFim: dataFim,
      pagina: _currentPage,
    );
    
    if (data != null) {
      final newItems = (data['items'] as List).map((e) => Map<String, dynamic>.from(e)).toList();
      if (reset) {
        _items = newItems;
      } else {
        _items.addAll(newItems);
      }
      _totalizadores = data['totalizadores'] ?? {};
      _lastPage = data['ultima_pagina'] ?? 1;
    } else {
      _errorMessage = "Erro ao carregar relatórios.";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadNextPage() async {
    if (hasMorePages && !_isLoading) {
      _currentPage++;
      await loadReports();
    }
  }
}
