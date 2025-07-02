import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Manager/Cubit/home_cubit.dart';
import '../../Manager/Cubit/home_states.dart';

class DrinkCard extends StatelessWidget {
  final int drinkHour;
  final bool isDrinkTaken;
  final int timeLeft;
  final VoidCallback onRecordDrink;

  const DrinkCard({
    Key? key,
    required this.drinkHour,
    required this.isDrinkTaken,
    required this.timeLeft,
    required this.onRecordDrink,
  }) : super(key: key);

  String _formatTimeLeft(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return "${hours}h ${minutes.toString().padLeft(2, '0')}m";
    } else if (minutes > 0) {
      return "${minutes}m ${secs.toString().padLeft(2, '0')}s";
    } else {
      return "${secs}s";
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    bool isTimeToDrink = now.hour == drinkHour;
    bool isPassed = now.hour > drinkHour;
    bool isUpcoming = now.hour < drinkHour;

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: isDrinkTaken ? Colors.blue.withOpacity(0.1) : Colors.white,
          border: isDrinkTaken
              ? Border.all(color: Colors.blue, width: 1.5.w)
              : null,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.w),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: isDrinkTaken ? Colors.blue : Colors.grey[200],
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                isDrinkTaken ? Icons.check : Icons.water_drop_outlined,
                color: isDrinkTaken ? Colors.white : Colors.blue[700],
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${drinkHour < 12 ? drinkHour : (drinkHour == 12 ? 12 : drinkHour - 12)}:00 ${drinkHour < 12 ? 'AM' : 'PM'}",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    isDrinkTaken
                        ? "Completed"
                        : (isPassed ? "Missed" : "Upcoming"),
                    style: TextStyle(
                      color: isDrinkTaken
                          ? Colors.blue[700]
                          : (isPassed ? Colors.red : Colors.grey[600]),
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            if (!isDrinkTaken)
              if (isUpcoming)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    _formatTimeLeft(timeLeft),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                )
              else
                ElevatedButton(
                  onPressed: BlocProvider.of<AddDrinkCubit>(context).state
                          is LoadingAddDrinkState
                      ? null
                      : onRecordDrink,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(isTimeToDrink ? "Drink Now" : "Catch Up"),
                )
            else
              Icon(Icons.check_circle, color: Colors.blue[700]),
          ],
        ),
      ),
    );
  }
}
