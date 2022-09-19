// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:report_app/Store/userPreferences.dart';

class UserService {
  final API_URL = 'http://sistemic.udea.edu.co:4000/reto';

  final headers = {
    'Authorization': 'Bearer ${UserPreferences().userToken}',
  };

  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      final response = await http.get(
          Uri.parse(
              '$API_URL/usuarios/usuarios/encontrar/${UserPreferences().username}'),
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

  Future<Map<String, dynamic>> updatedUserInfo(
      String name, String lastname) async {
    final body = {"name": name, "lastName": lastname};

    print(body);

    try {
      final response = await http.post(
          Uri.parse(
              '$API_URL/usuarios/usuarios/editar/${UserPreferences().username}'),
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
}
