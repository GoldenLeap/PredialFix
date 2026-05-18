import 'package:flutter/material.dart';
import 'package:mobile/services/auth_service.dart';

class HomeViewModel extends ChangeNotifier{
  final AuthService _authService = AuthService();


  Future<void> logout() async{
    
    await _authService.logout();
    notifyListeners();

  }

}