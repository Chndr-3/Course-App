import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/Course.dart';

class CourseService {
  final String endpoint =
      'https://engineer-test-eight.vercel.app/course-status.json';
  Future<Course> getCourseStatus() async {
    try {
      final response = await http.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return Course.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load course status');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}