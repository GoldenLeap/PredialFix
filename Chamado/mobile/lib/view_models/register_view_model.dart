import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  Future<bool> register(String name, String email, String password, String passwordConfirmation) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    bool success = await _authService.register(name, email, password, passwordConfirmation);

    if (!success) {
      _errorMessage = "Falha ao registrar. Verifique os dados e tente novamente.";
    }
    _isLoading = false;
    notifyListeners();

    return success;
  }
}
