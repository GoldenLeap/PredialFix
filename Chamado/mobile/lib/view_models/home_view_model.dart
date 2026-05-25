import 'package:flutter/material.dart';
import '../services/chamado_service.dart';
import '../models/chamado_model.dart';

class HomeViewModel extends ChangeNotifier {
  final ChamadoService _chamadoService = ChamadoService();

  List<Chamado> _chamados = [];
  List<Chamado> get chamados => _chamados;

  List<Chamado> get chamadosAbertos =>
      _chamados.where((c) => c.status != 'Concluído').toList();

  List<Chamado> get chamadosConcluidos =>
      _chamados.where((c) => c.status == 'Concluído').toList();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _userName = '';
  String get userName => _userName;

  set userName(String value) {
    _userName = value;
    notifyListeners();
  }

  String _currentFilter = 'Abertos';
  String get currentFilter => _currentFilter;
  set currentFilter(String value) {
    _currentFilter = value;
    notifyListeners();
  }

  List<Chamado> get filteredChamados {
    switch (_currentFilter) {
      case 'Abertos':
        return _chamados.where((c) => c.status != 'Concluído').toList();
      case 'Concluídos':
        return _chamados.where((c) => c.status == 'Concluído').toList();
      default:
        return _chamados;
    }
  }

  Future<void> loadChamados() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _chamados = await _chamadoService.getChamados();
    } catch (e) {
      _errorMessage = 'Erro ao carregar chamados: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateStatus(int id, String status, {String? observacao}) async {
    try {
      final success = await _chamadoService.updateStatus(id, status, observacao: observacao);
      if (success) {
        await loadChamados();
      }
      return success;
    } catch (e) {
      _errorMessage = 'Erro ao atualizar: $e';
      notifyListeners();
      return false;
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
  }) async {
    try {
      final novo = await _chamadoService.createChamado(
        tipo: tipo,
        local: local,
        assunto: assunto,
        descricao: descricao,
        prioridade: prioridade,
        tipoServico: tipoServico,
        observacao: observacao,
      );
      if (novo != null) {
        await loadChamados();
      }
      return novo;
    } catch (e) {
      _errorMessage = 'Erro ao criar chamado: $e';
      notifyListeners();
      return null;
    }
  }
}