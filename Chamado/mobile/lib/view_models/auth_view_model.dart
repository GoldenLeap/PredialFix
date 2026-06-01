import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> updateProfile(String name, String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final success = await _authService.updateProfile(name, email);
    if (!success) {
      _errorMessage = 'Falha ao atualizar perfil.';
    }
    
    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<bool> updatePassword(String current, String newPass, String confirm) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final success = await _authService.updatePassword(current, newPass, confirm);
    if (!success) {
      _errorMessage = 'Falha ao alterar senha. Verifique a senha atual.';
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }
}
