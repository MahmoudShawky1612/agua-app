import 'dart:convert';

import 'package:aguaapplication/Features/LogIn/Data/Model/user_model.dart';
import 'package:http/http.dart' as http;

class LogInService{
  final String baseUrl = "https://agua-fawn.vercel.app/api/v1/user/create-user";

Future<UserModel?> logIn (String username, String gender)async{
final url =  Uri.parse(baseUrl);

try{
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({"username":username, "gender": gender}),
  );

  if(response.statusCode == 201){
  final data = jsonDecode(response.body);
  return UserModel.fromJson(data['user']);
  }else {
    final errorData = jsonDecode(response.body);
    throw Exception('Failed: ${errorData['msg']}');
  }
}catch(e){
  print(e);

  throw Exception('Something went wrong ${e}' );
  }
}
}