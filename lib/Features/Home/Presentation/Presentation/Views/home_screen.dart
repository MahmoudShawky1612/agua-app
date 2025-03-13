import 'dart:async';
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
  final List<int> _drinkTimes = [3, 9, 12, 15, 18, 21]; // Drinking schedule
  final List<bool> _drinksTaken = List.filled(6, false); // Track water intake
  final List<int> _timeLeft = List.filled(6, 0); // Track countdown timers

  @override
  void initState() {
    super.initState();
    _startCountdownTimers();
  }

  void _startCountdownTimers() {
    Timer.periodic(Duration(seconds: 1), (timer) {
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddDrinkCubit(AddDrinkService()),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, color: Colors.white),
              ),
              SizedBox(width: 10),
              Text(widget.username),
            ],
          ),
        ),
        body: _selectedIndex == 0 ? _buildHomeBody() : _buildHistoryScreen(),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildHomeBody() {
    return BlocConsumer<AddDrinkCubit, AddDrinkStates>(
      listener: (context, state) {
        if (state is SuccessAddDrinkState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Drink recorded successfully!")),
          );
        } else if (state is ErrorAddDrinkState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: List.generate(6, (index) {
              final now = DateTime.now();
              final int drinkHour = _drinkTimes[index];
              bool isTimeToDrink = now.hour == drinkHour && !_drinksTaken[index];
              bool isPassed = now.hour > drinkHour;

              return Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _drinksTaken[index] ? Colors.blue[200] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Drink at ${drinkHour}:00"),
                    if (isTimeToDrink)
                      ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<AddDrinkCubit>(context).addDrink(widget.userId);
                          setState(() {
                            _drinksTaken[index] = true;
                          });
                        },
                        child: Text("I Drank"),
                      )
                    else if (!isPassed)
                      Text(
                        _formatTimeLeft(_timeLeft[index]),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }

  String _formatTimeLeft(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return "$hours h $minutes m $secs s";
  }

  Widget _buildHistoryScreen() {
    return Center(child: Text("History Screen"));
  }
}
