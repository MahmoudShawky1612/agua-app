import 'package:aguaapplication/Features/Home/Data/Service/api_handler.dart';
import 'package:aguaapplication/Features/Home/Presentation/Presentation/Manager/Cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_screen_content.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  final int userId;
  final String gender;

  const HomeScreen({
    Key? key,
    required this.username,
    required this.userId,
    required this.gender,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddDrinkCubit(AddDrinkService()),
      child: HomeScreenContent(
        username: widget.username,
        userId: widget.userId,
        gender: widget.gender,
      ),
    );
  }
}
