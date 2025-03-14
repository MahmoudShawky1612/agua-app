import 'package:aguaapplication/Features/History/Data/Service/api_handler.dart';
import 'package:aguaapplication/Features/History/Data/Service/user_api_handler.dart';
import 'package:aguaapplication/Features/History/Presentation/Presentation/Manager/Cubit/history_cubit.dart';
import 'package:aguaapplication/Features/History/Presentation/Presentation/Manager/UserCubit/user_cubit.dart';
import 'package:aguaapplication/Features/Home/Presentation/Presentation/Manager/Cubit/home_cubit.dart';
import 'package:aguaapplication/Features/LogIn/Data/Service/api_handler.dart';
import 'package:aguaapplication/Features/LogIn/Presentation/Manager/Cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Features/Home/Data/Service/api_handler.dart';
import 'Features/Home/Presentation/Presentation/Views/home_screen.dart';
import 'Features/LogIn/Presentation/Views/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Future<List?> getSavedUser() async {
    final sharedPref = await SharedPreferences.getInstance();
    return [
      sharedPref.getString("username") ,
      sharedPref.getInt("userId") ,
      sharedPref.getString("gender")
    ];
  }


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LogInCubit>(create: (context) => LogInCubit(LogInService())),
        BlocProvider<AddDrinkCubit>(create: (context) => AddDrinkCubit(AddDrinkService())),
        BlocProvider<UserCubit>(create: (context) => UserCubit(UserService())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder<List?>(
          future: getSavedUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            } else if (snapshot.hasData && snapshot.data![0] != null && snapshot.data![1] != null) {
              return HomeScreen(username: snapshot.data![0] as String, userId: snapshot.data![1] as int, gender: snapshot.data![2] as String,);
            } else {
              return const LoginScreen();
            }
          },
        ),

    ),
    );
  }
}
