class ApiConfig {
  static const String baseUrl = "http://127.0.0.1:8000/api"; // Url base para a api(emulador é 10.0.2.2, celular seria 192.168.x.x, windows é 127.0.0.1)

  static Map<String, String> headers([String? token]){
    return {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if(token !=null) 'Authorization': 'Bearer $token',
    };

  }

}