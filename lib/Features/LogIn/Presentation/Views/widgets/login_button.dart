import 'package:aguaapplication/Features/LogIn/Presentation/Views/widgets/user_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Home/Presentation/Presentation/Views/widgets/feed_back_helper.dart';
import '../../../../Home/Presentation/Presentation/Views/widgets/home_screen.dart';
import '../../Manager/Cubit/login_cubit.dart';
import '../../Manager/Cubit/login_states.dart';
import '../login.dart';

class LoginButton extends StatelessWidget {
  final String selectedGender;

  const LoginButton({
    Key? key,
    required this.selectedGender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogInCubit, LogInStates>(
      listener: (context, state) {
        if (state is SuccessLogInState) {
          FeedbackHelper.showFeedback(
            context,
            "Welcome, ${state.user.username}!",
            isError: false,
          );
          UserStorage.saveUser(state.user.username, state.user.id, state.user.gender);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                username: state.user.username,
                userId: state.user.id,
                gender: state.user.gender,
              ),
            ),
                (route) => false,
          );
        } else if (state is ErrorLogInState) {
          FeedbackHelper.showFeedback(
            context,
            state.message,
            isError: true,
          );
        }
      },
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 55.h,
          child: ElevatedButton(
            onPressed: state is LoadingLogInState
                ? null
                : () => _handleLogin(context, selectedGender),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: state is LoadingLogInState
                ?   SizedBox(
              height: 24.h,
              width: 24.w,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.w,
              ),
            )
                : Text(
              'Sign In',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleLogin(BuildContext context, String selectedGender) {
    final username = usernameController.text.trim();
    if (username.isNotEmpty) {
      context.read<LogInCubit>().login(username, selectedGender);
    } else {
      FeedbackHelper.showFeedback(
        context,
        "Please enter a username",
        isError: true,
      );
    }
  }
}
