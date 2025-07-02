import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'gender_option.dart';

class GenderSelector extends StatelessWidget {
  final String selectedGender;
  final Function(String) onGenderSelected;

  const GenderSelector({
    Key? key,
    required this.selectedGender,
    required this.onGenderSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            GenderOption(
              gender: 'Male',
              icon: Icons.male,
              isSelected: selectedGender == 'Male',
              onTap: () => onGenderSelected('Male'),
            ),
            SizedBox(width: 20.w),
            GenderOption(
              gender: 'Female',
              icon: Icons.female,
              isSelected: selectedGender == 'Female',
              onTap: () => onGenderSelected('Female'),
            ),
          ],
        ),
      ],
    );
  }
}
