import 'package:flutter/material.dart';
import '../services/chamado_service.dart';
import '../models/chamado_model.dart';
import '../services/auth_service.dart';
class HomeViewModel extends ChangeNotifier {
  final ChamadoService _chamadoService = ChamadoService();

  int _userId = 0;
  int get userId => _userId;

  List<Chamado> _chamados = [];
  List<Chamado> get chamados {
    if (_userCargo == 'solicitante') {
      return _chamados.where((c) => c.usuarioId == _userId).toList();
    }
    return _chamados;
  }

  List<Chamado> get chamadosAbertos {
    final list = _userCargo == 'solicitante'
        ? _chamados.where((c) => c.usuarioId == _userId).toList()
        : _chamados;
    return list.where((c) => c.status != 'Concluído').toList();
  }

  List<Chamado> get chamadosConcluidos {
    final list = _userCargo == 'solicitante'
        ? _chamados.where((c) => c.usuarioId == _userId).toList()
        : _chamados;
    return list.where((c) => c.status == 'Concluído').toList();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _userName = '';
  String get userName => _userName;

  String _userCargo = '';
  String get userCargo => _userCargo;

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
    final list = _userCargo == 'solicitante'
        ? _chamados.where((c) => c.usuarioId == _userId).toList()
        : _chamados;
    switch (_currentFilter) {
      case 'Abertos':
        return list.where((c) => c.status != 'Concluído').toList();
      case 'Concluídos':
        return list.where((c) => c.status == 'Concluído').toList();
      default:
        return list;
    }
  }

  Future<void> loadChamados() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      if (_userName.isEmpty || _userCargo.isEmpty) {
        final authService = AuthService();
        final userData = await authService.getUserData();
        if (userData != null) {
          _userName = userData['name'] ?? '';
          _userCargo = userData['cargo'] ?? '';
          _userId = userData['id'] ?? 0;
        }
      }

      _chamados = await _chamadoService.getChamados();
      
      if (_userCargo != 'solicitante' && _tecnicos.isEmpty) {
        fetchTecnicos();
      }
    } catch (e) {
      _errorMessage = 'Erro ao carregar chamados: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> _tecnicos = [];
  List<Map<String, dynamic>> get tecnicos => _tecnicos;

  Future<void> fetchTecnicos() async {
    try {
      final list = await _chamadoService.getTecnicos();
      if (list != null) {
        _tecnicos = list;
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<bool> updateStatus(
    int id, 
    String status, {
    String? observacao,
    int? tecnicoId,
    double? custoMaoObra,
    double? custoMateriais,
  }) async {
    try {
      final success = await _chamadoService.updateStatus(
        id, 
        status, 
        observacao: observacao,
        tecnicoId: tecnicoId,
        custoMaoObra: custoMaoObra,
        custoMateriais: custoMateriais,
      );
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

  Future<bool> updateLaborCost(int id, String currentStatus, double custoMaoObra) async {
    return await updateStatus(id, currentStatus, custoMaoObra: custoMaoObra);
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
    try {
      final novo = await _chamadoService.createChamado(
        tipo: tipo,
        local: local,
        assunto: assunto,
        descricao: descricao,
        prioridade: prioridade,
        tipoServico: tipoServico,
        observacao: observacao,
        imagemPath: imagemPath,
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

  Future<bool> adicionarMaterial(int chamadoId, int materialId, int quantidade) async {
    try {
      final success = await _chamadoService.adicionarMaterial(chamadoId, materialId, quantidade);
      if (success) await loadChamados();
      return success;
    } catch (e) {
      _errorMessage = 'Erro ao adicionar material: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> solicitarMaterial(int chamadoId, String observacao) async {
    try {
      final success = await _chamadoService.solicitarMaterial(chamadoId, observacao);
      if (success) await loadChamados();
      return success;
    } catch (e) {
      _errorMessage = 'Erro ao solicitar material: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> uploadEvidencias(int chamadoId, List<String> filePaths, List<String> tipos) async {
    try {
      final success = await _chamadoService.uploadEvidencias(chamadoId, filePaths, tipos);
      if (success) await loadChamados();
      return success;
    } catch (e) {
      _errorMessage = 'Erro ao fazer upload de evidências: $e';
      notifyListeners();
      return false;
    }
  }
}