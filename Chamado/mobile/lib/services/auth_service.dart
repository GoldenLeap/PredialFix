import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_config.dart';


class AuthService{

  // Logar
  Future<bool> login(String email, String password) async{
    final url = Uri.parse("${ApiConfig.baseUrl}/login");

    try {
      final response = await http.post(
        url,
        headers: ApiConfig.headers(),
        body: jsonEncode({
          'email':email,
          'password':password,
          'device_name': 'android_phone'
          }),
      );
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('user_name', data['user']['name']);
        return true;
      }else{
        print('Erro no login ${response.body}');
        return false;
      }
    }catch(e){
      print("Erro de conexão $e");
      return false;
    }
  }

  // Pegar o token 

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

  }



}