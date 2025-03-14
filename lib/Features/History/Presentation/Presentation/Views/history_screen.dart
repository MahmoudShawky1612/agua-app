import 'package:aguaapplication/Features/LogIn/Data/Model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aguaapplication/Features/History/Data/Model/drink_model.dart';
import 'package:aguaapplication/Features/History/Data/Service/api_handler.dart';
import '../Manager/Cubit/history_cubit.dart';
import '../Manager/Cubit/history_states.dart';
import '../Manager/UserCubit/user_cubit.dart';
import '../Manager/UserCubit/user_states.dart';

class HistoryScreen extends StatefulWidget {
  final int userId;

  const HistoryScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Expected drink times
  final List<int> drinkTimes = [3, 9, 12, 15, 18, 21];
  late UserCubit userCubit;


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      userCubit = BlocProvider.of<UserCubit>(context, listen: false);

      // Start the fetch process
      userCubit.fetchUser(widget.userId);

    });
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DrinkCubit(HistoryService())..fetchDrinks(widget.userId),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: BlocConsumer<DrinkCubit, DrinkStates>(
          listener: (context, state) {
            if (state is ErrorDrinkState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.all(10),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is LoadingDrinkState) {
              return _buildLoadingState();
            } else if (state is SuccessDrinkState) {
              return _buildHistoryContent(state.drinks);
            } else if (state is ErrorDrinkState) {
              return _buildErrorState(state.message);
            }
            return _buildLoadingState();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.blue[700]),
          const SizedBox(height: 16),
          Text(
            "Loading your hydration history...",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            "Oops! Something went wrong",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              BlocProvider.of<DrinkCubit>(context).fetchDrinks(widget.userId);
            },
            icon: const Icon(Icons.refresh),
            label: const Text("Try Again"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryContent(List<DrinksModel> drinks) {
    Map<String, List<DrinksModel>> drinksByDay = {};
    for (var drink in drinks) {
      if (!drinksByDay.containsKey(drink.day)) {
        drinksByDay[drink.day] = [];
      }
      drinksByDay[drink.day]!.add(drink);
    }

    // Sort days in descending order (most recent first)

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHistoryHeader(),
          _buildSummaryCard(drinks),
        ],
      ),
    );
  }

  Widget _buildHistoryHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Hydration History",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.calendar_today, color: Colors.blue[700]),
              onPressed: () {
                // Calendar filter functionality could go here
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(List<DrinksModel> drinks) {

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[700]!, Colors.blue[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Overall Performance",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    BlocBuilder<UserCubit, UserStates>(
                      builder: (context, state) {
                        if (state is SuccessUserState) {
                          return _buildSummaryStat(
                            "${state.user.totalDrinks}",
                            "Total Drinks",
                            Icons.trending_up,
                          );
                        }
                        return _buildSummaryStat(
                          "0", // Default value
                          "Total Drinks",
                          Icons.trending_up,
                        );
                      },
                    ),

                    BlocBuilder<UserCubit, UserStates>(
                      builder: (context, state) {
                        if (state is SuccessUserState) {
                          return _buildSummaryStat(
                            "${state.user.onTimeDrinks}%",
                            "On Time",
                            Icons.trending_up,
                          );
                        }
                        return _buildSummaryStat(
                          "0%", // Default value
                          "On Time",
                          Icons.trending_up,
                        );
                      },
                    ),

                    BlocBuilder<UserCubit, UserStates>(
                      builder: (context, state) {
                        if (state is SuccessUserState) {
                          return _buildSummaryStat(
                            "${state.user.accuracy}%",
                            "Accuracy",
                            Icons.trending_up,
                          );
                        }
                        return _buildSummaryStat(
                          "0%", // Default value
                          "Accuracy",
                          Icons.trending_up,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSummaryStat(String value, String label, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
  }