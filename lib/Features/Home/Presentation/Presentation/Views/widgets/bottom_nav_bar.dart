import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blue[700],
      unselectedItemColor: Colors.grey,
      onTap: onItemTapped,
      elevation: 8,
    );
  }
}
