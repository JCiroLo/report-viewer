// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:report_app/Store/userPreferences.dart';

class EventsService {
  final API_URL = 'http://sistemic.udea.edu.co:4000/reto';

  final headers = {
    'Authorization': 'Bearer ${UserPreferences().userToken}',
  };

  Future<Map<String, dynamic>> getEvents() async {
    try {
      final response = await http
          .get(Uri.parse('$API_URL/events/eventos/listar'), headers: headers);

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
