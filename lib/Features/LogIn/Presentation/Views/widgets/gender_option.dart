import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class GenderOption extends StatelessWidget {
  final String gender;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const GenderOption({
    Key? key,
    required this.gender,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.w),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? Colors.blueAccent : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.blueAccent : Colors.grey,
              ),
              SizedBox(width: 8.w),
              Text(
                gender,
                style: GoogleFonts.poppins(
                  color: isSelected ? Colors.blueAccent : Colors.grey,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
