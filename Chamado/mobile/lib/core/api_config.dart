class ApiConfig {
  static const String baseUrl = "http://localhost:8000/api"; // Url base para a api(emulador é 10.0.2.2, celular seria 192.168.x.x)

  static Map<String, String> headers([String? token]){
    return {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if(token !=null) 'Authorization': 'Bearer $token',
    };

  }

}