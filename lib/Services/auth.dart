// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:report_app/Store/userPreferences.dart';

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
    } catch (e) {
      return {
        'status': false,
        'data': {'message': e.toString()}
      };
    }
  }

  Future<Map> registrySendCode(
      String username, String email, String password) async {
    final body = json.encode({
      'username': username,
      'email': email,
      'password': password,
    });

    headers['Content-Type'] = 'application/json';

    try {
      final response = await http.post(
          Uri.parse('$API_URL/usuarios/registro/enviar'),
          body: body,
          headers: headers);

      if (response.statusCode != 201) throw Exception('${response.statusCode}');

      return {'status': true, 'data': jsonDecode(response.body)};
    } catch (e) {
      return {
        'status': false,
        'data': {'message': e.toString()}
      };
    }
  }

  Future<Map> registryConfirmationCode(String username, String codigo) async {
    final body = {'codigo': codigo};

    try {
      final response = await http.post(
        Uri.parse('$API_URL/usuarios/registro/confirmar/$username'),
        body: body,
      );

      if (response.statusCode != 201) throw Exception('${response.statusCode}');

      return {'status': true, 'data': jsonDecode(response.body)};
    } catch (e) {
      return {
        'status': false,
        'data': {'message': e.toString()}
      };
    }
  }
}
