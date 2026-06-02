import 'package:flutter/material.dart';
import '../services/dashboard_service.dart';

class DashboardViewModel extends ChangeNotifier {
  final DashboardService _service = DashboardService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Map<String, dynamic>? _dashboardData;
  Map<String, dynamic>? get dashboardData => _dashboardData;

  int _selectedMonth = DateTime.now().month;
  int get selectedMonth => _selectedMonth;

  int _selectedYear = DateTime.now().year;
  int get selectedYear => _selectedYear;

  void setDate(int month, int year) {
    _selectedMonth = month;
    _selectedYear = year;
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final data = await _service.getDashboardData(_selectedMonth, _selectedYear);
    
    if (data != null) {
      _dashboardData = data;
    } else {
      _errorMessage = "Erro ao carregar dados do dashboard.";
    }

    _isLoading = false;
    notifyListeners();
  }
}
