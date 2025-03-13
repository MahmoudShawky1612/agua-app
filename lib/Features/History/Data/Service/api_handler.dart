import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../History/Data/Model/drink_model.dart';

class HistoryService {
  final String baseUrl = 'https://b173-217-55-27-125.ngrok-free.app/api/v1/drink'; // Change to your actual base URL

  Future<List<DrinksModel>> getDrinks(int userId) async {
    final url = Uri.parse('$baseUrl/get-drinks/$userId');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List<DrinksModel> drinks = (data['drank'] as List)
            .map((item) => DrinksModel.fromJson(item))
            .toList();

        return drinks;
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
