import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  String _successMessage = "";
  String get successMessage => _successMessage;

  Future<bool> sendResetLink(String email) async {
    _isLoading = true;
    _errorMessage = "";
    _successMessage = "";
    notifyListeners();

    bool success = await _authService.forgotPassword(email);

    if (success) {
      _successMessage = "Link de recuperação enviado para seu e-mail.";
    } else {
      _errorMessage = "Falha ao enviar link de recuperação. Tente novamente.";
    }
    _isLoading = false;
    notifyListeners();

    return success;
  }
}
