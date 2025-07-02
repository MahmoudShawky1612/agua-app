import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/drink_model.dart';

class AddDrinkService {
  final String baseUrl = "https://caa9-217-55-26-242.ngrok-free.app/api/v1/drink";

  Future<DrankModel> addDrink(int userId, int drinkHour, int index, String day) async {
    final url = Uri.parse('$baseUrl/add-drink/$userId');

     final now = DateTime.now().toUtc();
    final drinkTime = DateTime(now.year, now.month, now.day, drinkHour).toIso8601String();

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'drinkTime': {drinkTime:  index}, 'day': day
        }),
      );
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return DrankModel.fromJson(data['drank']);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception('Failed: ${errorData['msg']}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Something went wrong: $e');
    }
  }
}