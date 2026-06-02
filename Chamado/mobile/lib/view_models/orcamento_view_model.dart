import 'package:flutter/material.dart';
import '../services/budget_service.dart';

class OrcamentoViewModel extends ChangeNotifier {
  final BudgetService _service = BudgetService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Dados reais da API
  Map<String, dynamic>? _config;
  Map<String, dynamic>? get config => _config;

  double _totalGasto = 0;
  double get totalGasto => _totalGasto;

  double _orcamentoRestante = 0;
  double get orcamentoRestante => _orcamentoRestante;

  double get orcamentoTotal => (_config?['total_budget'] as num?)?.toDouble() ?? 0.0;

  List<Map<String, dynamic>> _historico = [];
  List<Map<String, dynamic>> get historico => _historico;

  int _selectedMonth = DateTime.now().month;
  int get selectedMonth => _selectedMonth;

  int _selectedYear = DateTime.now().year;
  int get selectedYear => _selectedYear;

  void setDate(int month, int year) {
    _selectedMonth = month;
    _selectedYear = year;
    loadBudget();
  }

  Future<void> loadBudget() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final data = await _service.getBudgetInfo(_selectedMonth, _selectedYear);
    
    if (data != null) {
      _config = data['config'];
      _totalGasto = (data['total_gasto'] as num?)?.toDouble() ?? 0.0;
      _orcamentoRestante = (data['orcamento_restante'] as num?)?.toDouble() ?? 0.0;
      
      final hist = data['historico'] as List<dynamic>? ?? [];
      _historico = hist.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      _errorMessage = "Erro ao carregar dados financeiros.";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> saveBudget(double valorTotal) async {
    _isLoading = true;
    notifyListeners();

    final success = await _service.defineBudget(_selectedMonth, _selectedYear, valorTotal);
    
    if (success) {
      await loadBudget();
    } else {
      _errorMessage = "Erro ao salvar orçamento.";
      _isLoading = false;
      notifyListeners();
    }
    
    return success;
  }
}
