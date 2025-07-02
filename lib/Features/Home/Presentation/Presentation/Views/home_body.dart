import 'package:aguaapplication/Features/Home/Presentation/Presentation/Views/widgets/daily_summery.dart';
import 'package:aguaapplication/Features/Home/Presentation/Presentation/Views/widgets/drink_card.dart';
import 'package:aguaapplication/Features/Home/Presentation/Presentation/Views/widgets/feed_back_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Manager/Cubit/home_cubit.dart';
import '../Manager/Cubit/home_states.dart';

class HomeBody extends StatelessWidget {
  final List<int> drinkTimes;
  final List<bool> drinksTaken;
  final List<int> timeLeft;
  final Function(int) onRecordDrink;

  const HomeBody({
    Key? key,
    required this.drinkTimes,
    required this.drinksTaken,
    required this.timeLeft,
    required this.onRecordDrink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddDrinkCubit, AddDrinkStates>(
      listener: (context, state) {
        if (state is SuccessAddDrinkState) {
          FeedbackHelper.showFeedback(context, "Drink recorded successfully!",
              isError: false);
        } else if (state is ErrorAddDrinkState) {
          FeedbackHelper.showFeedback(context, state.message, isError: true);
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DailySummary(drinksTaken: drinksTaken),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.w),
                child: Text(
                  "Today's Schedule",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: drinksTaken.length,
                  itemBuilder: (context, index) {
                    return DrinkCard(
                      drinkHour: drinkTimes[index],
                      isDrinkTaken: drinksTaken[index],
                      timeLeft: timeLeft[index],
                      onRecordDrink: () => onRecordDrink(index),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
