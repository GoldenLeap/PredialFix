import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SettingsViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  String _successMessage = "";
  String get successMessage => _successMessage;

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  // Password change
  Future<bool> updatePassword(String currentPassword, String password, String passwordConfirmation) async {
    _isLoading = true;
    _errorMessage = "";
    _successMessage = "";
    notifyListeners();

    bool success = await _authService.updatePassword(currentPassword, password, passwordConfirmation);

    if (success) {
      _successMessage = "Senha alterada com sucesso!";
    } else {
      _errorMessage = "Falha ao alterar senha. Verifique sua senha atual.";
    }
    _isLoading = false;
    notifyListeners();

    return success;
  }

  // Two-factor settings
  Future<bool> enableTwoFactor() async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    bool success = await _authService.enableTwoFactor();

    if (!success) {
      _errorMessage = "Falha ao ativar autenticação em dois fatores.";
    }
    _isLoading = false;
    notifyListeners();

    return success;
  }

  Future<bool> disableTwoFactor(String password) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    bool success = await _authService.disableTwoFactor(password);

    if (success) {
      _successMessage = "Autenticação em dois fatores desativada.";
    } else {
      _errorMessage = "Falha ao desativar 2FA. Verifique sua senha.";
    }
    _isLoading = false;
    notifyListeners();

    return success;
  }

  // Theme settings
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setTheme(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }
}
