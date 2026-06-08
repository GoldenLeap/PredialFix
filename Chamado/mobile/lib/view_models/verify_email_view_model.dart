import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class VerifyEmailViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  String _successMessage = "";
  String get successMessage => _successMessage;

  Future<bool> verifyEmail(String code) async {
    _isLoading = true;
    _errorMessage = "";
    _successMessage = "";
    notifyListeners();

    bool success = await _authService.verifyEmail(code);

    if (success) {
      _successMessage = "E-mail verificado com sucesso!";
    } else {
      _errorMessage = "Código inválido ou expirado. Tente novamente.";
    }
    _isLoading = false;
    notifyListeners();

    return success;
  }

  Future<bool> resendVerificationCode(String email) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    bool success = await _authService.resendVerificationCode(email);

    if (success) {
      _successMessage = "Código reenviado para seu e-mail.";
    } else {
      _errorMessage = "Falha ao reenviar código.";
    }
    _isLoading = false;
    notifyListeners();

    return success;
  }
}
