import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aguaapplication/Features/History/Data/Model/drink_model.dart';
import 'package:aguaapplication/Features/History/Data/Service/api_handler.dart';
import 'package:intl/intl.dart';

import '../Manager/Cubit/history_cubit.dart';
import '../Manager/Cubit/history_states.dart';

class HistoryScreen extends StatefulWidget {
  final int userId;

  const HistoryScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Expected drink times
  final List<int> drinkTimes = [3, 9, 12, 15, 18, 21];

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
    // Group drinks by day
    Map<String, List<DrinksModel>> drinksByDay = {};
    for (var drink in drinks) {
      if (!drinksByDay.containsKey(drink.day)) {
        drinksByDay[drink.day] = [];
      }
      drinksByDay[drink.day]!.add(drink);
    }

    // Sort days in descending order (most recent first)
    List<String> sortedDays = drinksByDay.keys.toList()
      ..sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHistoryHeader(),
          _buildSummaryCard(drinks),
          Expanded(
            child: sortedDays.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              itemCount: sortedDays.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemBuilder: (context, index) {
                String day = sortedDays[index];
                List<DrinksModel> dayDrinks = drinksByDay[day]!;
                return _buildDayCard(day, dayDrinks);
              },
            ),
          ),
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
    int totalDrinks = drinks.length;
    int onTimeDrinks = drinks.where((drink) => drink.isOnTime).length;
    double onTimePercentage = totalDrinks > 0 ? (onTimeDrinks / totalDrinks) * 100 : 0;

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
                    _buildSummaryStat(
                      "$totalDrinks",
                      "Total Drinks",
                      Icons.water_drop,
                    ),
                    _buildSummaryStat(
                      "$onTimeDrinks",
                      "On Time",
                      Icons.check_circle,
                    ),
                    _buildSummaryStat(
                      "${onTimePercentage.toStringAsFixed(0)}%",
                      "Accuracy",
                      Icons.trending_up,
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

  Widget _buildDayCard(String day, List<DrinksModel> dayDrinks) {
    String formattedDate = day; // Directly use the weekday string

    // Calculate completion percentage
    int totalExpected = drinkTimes.length;
    int completed = dayDrinks.length;
    double completionPercentage = (completed / totalExpected) * 100;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate, // Now uses the weekday directly
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  "${completionPercentage.toStringAsFixed(0)}% Complete",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _getCompletionColor(completionPercentage),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildHydrationChart(dayDrinks),
            const SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Color _getCompletionColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }

  Widget _buildHydrationChart(List<DrinksModel> dayDrinks) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: List.generate(drinkTimes.length, (index) {
          // Find the drink for this time slot, if any
          final expectedTime = drinkTimes[index];
          final drink = dayDrinks.firstWhere(
                (d) => d.time == expectedTime,
            orElse: () => DrinksModel(
              id: -1,
              userId: -1,
              day: '',
              time: expectedTime,
              isOnTime: false,
              litre: 0,
            ),
          );

          // Determine the status and color
          Color color = Colors.red;  // Default: Not drunk (red)
          if (drink.id != -1) {
            color = drink.isOnTime ? Colors.green : Colors.amber;  // On time (green) or late (yellow)
          }

          return Expanded(
            child: Container(
              margin: EdgeInsets.only(
                left: index == 0 ? 0 : 2,
                right: index == drinkTimes.length - 1 ? 0 : 2,
              ),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  "${expectedTime > 12 ? expectedTime - 12 : expectedTime}${expectedTime >= 12 ? 'PM' : 'AM'}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem("On Time", Colors.green),
        const SizedBox(width: 16),
        _buildLegendItem("Late", Colors.amber),
        const SizedBox(width: 16),
        _buildLegendItem("Missed", Colors.red),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.water_drop_outlined, size: 70, color: Colors.blue[300]),
          const SizedBox(height: 16),
          Text(
            "No Hydration Data Yet",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Start drinking water to track your hydration!",
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
            label: const Text("Refresh"),
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
}