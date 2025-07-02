import 'package:aguaapplication/Features/LogIn/Presentation/Views/widgets/login_content.dart';
import 'package:aguaapplication/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Home/Presentation/Presentation/Views/widgets/home_screen.dart';
import '../Manager/Cubit/login_cubit.dart';
import '../Manager/Cubit/login_states.dart';

final TextEditingController usernameController = TextEditingController();

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return const LoginScreenContent();
  }
}









