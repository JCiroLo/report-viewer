// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final API_URL = 'http://sistemic.udea.edu.co:4000/reto';

  final headers = {
    'Authorization': 'Basic Zmx1dHRlci1yZXRvOnVkZWE=',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  Future<Map> login(String username, String password) async {
    final body = {
      'username': username,
      'password': password,
      'grant_type': 'password'
    };

    try {
      final response = await http.post(
          Uri.parse('$API_URL/autenticacion/oauth/token'),
          body: body,
          headers: headers);

      if (response.statusCode != 200) throw Exception('${response.statusCode}');

      return {'status': true, 'data': jsonDecode(response.body)};
    } catch (_) {
      return {
        'status': false,
        'data': {'message': 'Usuario o contraseña incorrecta'}
      };
    }
  }
}
