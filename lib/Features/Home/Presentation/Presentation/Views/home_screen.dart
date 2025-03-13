import 'dart:async';
import 'package:aguaapplication/Features/History/Presentation/Presentation/Views/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aguaapplication/Features/Home/Data/Service/api_handler.dart';
import 'package:aguaapplication/Features/Home/Presentation/Presentation/Manager/Cubit/home_cubit.dart';
import 'package:aguaapplication/Features/Home/Presentation/Presentation/Manager/Cubit/home_states.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  final int userId;

  const HomeScreen({Key? key, required this.username, required this.userId}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<int> _drinkTimes = [4, 9, 12, 15, 18, 21]; // Drinking schedule
  final List<bool> _drinksTaken = List.filled(6, false); // Track water intake
  final List<int> _timeLeft = List.filled(6, 0); // Track countdown timers
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdownTimers();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdownTimers() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      setState(() {
        for (int i = 0; i < _drinkTimes.length; i++) {
          int drinkHour = _drinkTimes[i];
          if (now.hour < drinkHour) {
            _timeLeft[i] = (drinkHour - now.hour) * 3600 - now.minute * 60 - now.second;
          } else {
            _timeLeft[i] = 0;
          }
        }
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _recordDrink(BuildContext context, int index) {
    BlocProvider.of<AddDrinkCubit>(context).addDrink(widget.userId);
    setState(() {
      _drinksTaken[index] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddDrinkCubit(AddDrinkService()),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: _buildAppBar(),
        body: _selectedIndex == 0 ? _buildHomeBody() : HistoryScreen(userId: widget.userId),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue[700],
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Text(
            widget.username,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),

    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.water_drop_outlined),
          activeIcon: Icon(Icons.water_drop),
          label: 'Today',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.insert_chart_outlined),
          activeIcon: Icon(Icons.insert_chart),
          label: 'History',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue[700],
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
      elevation: 8,
    );
  }

  Widget _buildHomeBody() {
    return BlocConsumer<AddDrinkCubit, AddDrinkStates>(
      listener: (context, state) {
        if (state is SuccessAddDrinkState) {
          _showFeedback(context, "Drink recorded successfully!", isError: false);
        } else if (state is ErrorAddDrinkState) {
          _showFeedback(context, state.message, isError: true);
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDailySummary(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text(
                  "Today's Schedule",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _drinkTimes.length,
                  itemBuilder: (context, index) {
                    return _buildDrinkCard(context, index);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDailySummary() {
    final completedCount = _drinksTaken.where((taken) => taken).length;
    final progress = completedCount / _drinksTaken.length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Daily Progress",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$completedCount/${_drinksTaken.length} glasses",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 6,
                      ),
                      Text(
                        "${(progress * 100).toInt()}%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrinkCard(BuildContext context, int index) {
    final now = DateTime.now();
    final int drinkHour = _drinkTimes[index];
    bool isTimeToDrink = now.hour == drinkHour && !_drinksTaken[index];
    bool isPassed = now.hour > drinkHour;
    bool isDrinkTaken = _drinksTaken[index];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isDrinkTaken
              ? Colors.blue.withOpacity(0.1)
              : Colors.white,
          border: isDrinkTaken
              ? Border.all(color: Colors.blue, width: 1.5)
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDrinkTaken ? Colors.blue : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isDrinkTaken ? Icons.check : Icons.water_drop_outlined,
                color: isDrinkTaken ? Colors.white : Colors.blue[700],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${drinkHour < 12 ? drinkHour : (drinkHour == 12 ? 12 : drinkHour - 12)}:00 ${drinkHour < 12 ? 'AM' : 'PM'}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isDrinkTaken
                        ? "Completed"
                        : (isPassed ? "Missed" : "Upcoming"),
                    style: TextStyle(
                      color: isDrinkTaken
                          ? Colors.blue[700]
                          : (isPassed ? Colors.red : Colors.grey[600]),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (isTimeToDrink)
              ElevatedButton(
                onPressed: () => _recordDrink(context, index),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Drink Now"),
              )
            else if (!isPassed && !isDrinkTaken)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _formatTimeLeft(_timeLeft[index]),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              )
            else if (isDrinkTaken)
                Icon(Icons.check_circle, color: Colors.blue[700]),
          ],
        ),
      ),
    );
  }

  String _formatTimeLeft(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;

    if (hours > 0) {
      return "$hours h ${minutes.toString().padLeft(2, '0')} m";
    } else if (minutes > 0) {
      return "$minutes m ${secs.toString().padLeft(2, '0')} s";
    } else {
      return "$secs s";
    }
  }

  void _showFeedback(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  Widget _buildHistoryScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.insert_chart, size: 70, color: Colors.blue[300]),
          const SizedBox(height: 20),
          Text(
            "Water Intake History",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Track your daily water consumption",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "View Statistics",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}