import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class TwoFactorChallengeViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  Future<bool> verifyTwoFactorCode(String code) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    bool success = await _authService.verifyTwoFactorCode(code);

    if (!success) {
      _errorMessage = "Código 2FA inválido. Tente novamente.";
    }
    _isLoading = false;
    notifyListeners();

    return success;
  }

  Future<bool> verifyTwoFactorBackupCode(String code) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    bool success = await _authService.verifyTwoFactorBackupCode(code);

    if (!success) {
      _errorMessage = "Código de backup inválido. Tente novamente.";
    }
    _isLoading = false;
    notifyListeners();

    return success;
  }
}
