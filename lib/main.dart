import 'package:aguaapplication/Features/Home/Presentation/Presentation/Manager/Cubit/home_cubit.dart';
import 'package:aguaapplication/Features/LogIn/Data/Service/api_handler.dart';
import 'package:aguaapplication/Features/LogIn/Presentation/Manager/Cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Features/Home/Data/Service/api_handler.dart';
import 'Features/LogIn/Presentation/Views/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
providers: [
BlocProvider<LogInCubit>(create: (BuildContext context)=>LogInCubit(LogInService())),
BlocProvider<AddDrinkCubit>(create: (BuildContext context)=>AddDrinkCubit(AddDrinkService())),
],
      child: MaterialApp(
      debugShowCheckedModeBanner: false,

        home: LoginScreen()
      ),
    );
  }
}
