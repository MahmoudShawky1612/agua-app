import 'dart:convert';

import '../Model/drink_model.dart';
import 'package:http/http.dart' as http;

class AddDrinkService{
  final String baseUrl = "https://679c-154-238-130-209.ngrok-free.app/api/v1/drink";

  Future<DrankModel> addDrink (int userId)async {
    final url = Uri.parse('$baseUrl/add-drink/${userId}');

    try{
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      if(response.statusCode == 201){
        final data = jsonDecode(response.body);
        return DrankModel.fromJson(data['drank']);
      }else {
        final errorData = jsonDecode(response.body);
        throw Exception('Failed: ${errorData['msg']}');
      }
    }catch(e){
      print('Error: $e');
      throw Exception('Something went wrong: $e');
    }
  }

}