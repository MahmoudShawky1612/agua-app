import 'package:aguaapplication/Features/LogIn/Presentation/Views/widgets/username_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'gender.dart';
import 'login_button.dart';
import 'login_header.dart';

class LoginScreenContent extends StatefulWidget {
  const LoginScreenContent({Key? key}) : super(key: key);

  @override
  _LoginScreenContentState createState() => _LoginScreenContentState();
}
class _LoginScreenContentState extends State<LoginScreenContent> with SingleTickerProviderStateMixin {
  String _selectedGender = 'Male';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            child: Padding(
              padding:   EdgeInsets.symmetric(horizontal: 24.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60.h),
                  const LoginHeader(),
                  SizedBox(height: 50.h),
                  const UsernameField(),
                  SizedBox(height: 20.h),
                  GenderSelector(
                    selectedGender: _selectedGender,
                    onGenderSelected: (gender) {
                      setState(() {
                        _selectedGender = gender;
                      });
                    },
                  ),
                  SizedBox(height: 50.h),
                  LoginButton(
                    selectedGender: _selectedGender,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
