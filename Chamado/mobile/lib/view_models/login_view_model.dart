import 'package:flutter/material.dart';
import '../services/auth_service.dart';


class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    bool success = await _authService.login(email, password);

    if(!success){
      _errorMessage = "Falha ao autenticar, verifique suas credenciais.";
    }
    _isLoading = false;
    notifyListeners();

    return success;

  }

}