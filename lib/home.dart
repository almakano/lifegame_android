import 'package:flutter/material.dart';

import '1stPage.dart';
import '2ndPage.dart';
import '3rdPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  getNavBody(int index) {
    setState(() {});
    if (index == 0) return FirstPage();
    if (index == 1) return SecondPage();
    if (index == 2) return ThirdPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getNavBody(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Графики',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Финансы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Настройки',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}
