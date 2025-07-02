import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../History/Presentation/Presentation/Views/history_screen.dart';
import '../../Manager/Cubit/home_cubit.dart';
import '../../Manager/Cubit/home_states.dart';
import '../home_body.dart';
import 'app_bar_builder.dart';
import 'bottom_nav_bar.dart';

class HomeScreenContent extends StatefulWidget {
  final String username;
  final int userId;
  final String gender;

  const HomeScreenContent({
    Key? key,
    required this.username,
    required this.userId,
    required this.gender,
  }) : super(key: key);

  @override
  _HomeScreenContentState createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  int _selectedIndex = 0;
  final List<int> _drinkTimes = [3, 9, 12, 15, 18, 23];
  List<bool> _drinksTaken = List.filled(6, false);
  final List<int> _timeLeft = List.filled(6, 0);
  Timer? _timer;
  int _currentDay = DateTime.now().day;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentDay = DateTime.now().day;
    _loadDrinksTaken().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    _startCountdownTimers();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadDrinksTaken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 0; i < _drinkTimes.length; i++) {
        _drinksTaken[i] = prefs.getBool('drinkTaken_$i') ?? false;
      }
    });
  }

  Future<void> _saveDrinksTaken(int index, {String? recordedTime}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('drinkTaken_$index', _drinksTaken[index]);
    if (recordedTime != null) {
      await prefs.setString('drinkTime_$index', recordedTime);
    }
  }

  Future<void> _resetDrinksTakenInPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < _drinkTimes.length; i++) {
      await prefs.setBool('drinkTaken_$i', false);
      await prefs.remove('drinkTime_$i');
    }
  }

  void _startCountdownTimers() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();

      if (now.day != _currentDay) {
        setState(() {
          _currentDay = now.day;
          _drinksTaken = List.filled(_drinkTimes.length, false);
          _resetDrinksTakenInPrefs();
        });
      }

      bool needsUpdate = false;
      final newTimeLeft = List<int>.filled(_drinkTimes.length, 0);
      for (int i = 0; i < _drinkTimes.length; i++) {
        final int drinkHour = _drinkTimes[i];
        if (now.hour < drinkHour) {
          newTimeLeft[i] =
              (drinkHour - now.hour) * 3600 - now.minute * 60 - now.second;
        }
        if (newTimeLeft[i] != _timeLeft[i]) {
          needsUpdate = true;
        }
      }

      if (needsUpdate) {
        setState(() {
          _timeLeft.setAll(0, newTimeLeft);
        });
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _recordDrink(BuildContext context, int index) {
    final state = BlocProvider.of<AddDrinkCubit>(context).state;
    if (state is LoadingAddDrinkState) return;

    final now = DateTime.now();
    final currentTime = now.toIso8601String();
    BlocProvider.of<AddDrinkCubit>(context).addDrink(
        widget.userId, now.hour, index, DateFormat('EEEE').format(now));
    setState(() {
      _drinksTaken[index] = true;
    });
    _saveDrinksTaken(index, recordedTime: currentTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBarBuilder.buildAppBar(widget.gender, widget.username),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _selectedIndex == 0
              ? HomeBody(
                  drinkTimes: _drinkTimes,
                  drinksTaken: _drinksTaken,
                  timeLeft: _timeLeft,
                  onRecordDrink: (index) => _recordDrink(context, index),
                )
              : HistoryScreen(userId: widget.userId),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
