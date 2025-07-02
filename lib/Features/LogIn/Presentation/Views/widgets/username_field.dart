import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../login.dart';

class UsernameField extends StatelessWidget {
  const UsernameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20.r,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: usernameController,
        style: GoogleFonts.poppins(),
        decoration: InputDecoration(
          hintText: "Username",
          hintStyle: GoogleFonts.poppins(color: Colors.grey),
          prefixIcon: const Icon(Icons.person_outline, color: Colors.blueAccent),
          border: InputBorder.none,
          contentPadding:   EdgeInsets.symmetric(vertical: 20.w),
        ),
      ),
    );
  }
}
