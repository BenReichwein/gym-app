import 'package:client/util/check_token.dart';
import 'package:client/util/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:client/fragments/home_fragment.dart';
import 'package:client/data_models/user.dart';
import 'package:client/providers/user_provider.dart';
import 'package:provider/provider.dart';

class RouterScreen extends StatefulWidget {
  static String id = "router_screen";

  @override
  _RouterScreenState createState() => _RouterScreenState();
}

class _RouterScreenState extends State<RouterScreen> {
  int _currentIndex = 0;
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //list of widgets to call ontap
  final widgetOptions = [
    Home(),
    Home(),
    Home(),
    Home(),
  ];

  final widgetTitle = ["Home", "...", "..."];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widgetTitle.elementAt(_selectedIndex))),
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.grey,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
