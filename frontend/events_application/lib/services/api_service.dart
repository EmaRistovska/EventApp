import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';

class ApiService {
  final String baseUrl = "http://192.168.100.82:8080";

  Future<List<Event>> getEvents() async {
    final response = await http.get(Uri.parse('$baseUrl/events'));

    if (response.statusCode == 200) {
      List jsonData = jsonDecode(response.body);
      return jsonData.map((e) => Event.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }
}
