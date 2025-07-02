import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBarBuilder {
  static PreferredSizeWidget buildAppBar(String gender, String username) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue[700],
            radius: 20.r,
            child: ClipOval(
              child: Image.asset(
                gender == 'Male'
                    ? "assets/images/avatar.jpg"
                    : "assets/images/8c6ddb5fe6600fcc4b183cb2ee228eb7.jpg",
                fit: BoxFit.contain,
              ),
            ),
          ),
            SizedBox(width: 10.w),
          Text(
            username,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
