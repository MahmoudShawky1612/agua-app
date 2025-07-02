import 'dart:convert';

import 'package:aguaapplication/Features/LogIn/Data/Model/user_model.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = "https://agua-fawn.vercel.app/api/v1/user";

  Future<UserModel> getUser(int userId) async {
    final url = Uri.parse('$baseUrl/get-user/$userId');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data['user']);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception('Failed: ${errorData['msg']}');
      }
    } catch (e) {
      throw Exception('Something went wrong: $e');
    }
  }
}
