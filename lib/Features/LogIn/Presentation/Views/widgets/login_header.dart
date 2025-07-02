import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome',
          style: GoogleFonts.poppins(
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          'Sign in to continue',
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
