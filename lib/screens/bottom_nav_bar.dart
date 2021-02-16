import 'package:flutter/material.dart';
import 'package:wha_app3/screens/practitioners/practitioner_profile_screen.dart';

import 'articles/article_overview_screen.dart';
import '../screens/article_search_screen.dart';
import 'practitioners/practitioner_directory_screen.dart';
import 'other/other_screen.dart';

class BottomNavBar extends StatefulWidget {
  final isPractitioner;
  BottomNavBar(this.isPractitioner);
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final List<Widget> _userPages = [
    ArticleOverviewScreen(),
    ArticleSearchScreen(),
    PractitionerDirectoryScreen(),
    OtherScreen(),
  ];

  final List<Widget> _practitionerPages = [
    ArticleOverviewScreen(),
    ArticleSearchScreen(),
    PractitionerDirectoryScreen(),
    PractitionerProfileScreen(),
    OtherScreen(),
  ];

  int _practitionerPageIndex = 0;
  int _userPageIndex = 0;

  void _selectUserPage(int index) {
    setState(() {
      _userPageIndex = index;
    });
  }

  void _selectPractitionerPage(int index) {
    setState(() {
      _practitionerPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isPractitioner) {
      return Scaffold(
        body: _userPages[_userPageIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectUserPage,
          type: BottomNavigationBarType.shifting,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.blueAccent,
          currentIndex: _userPageIndex,
          selectedFontSize: 20,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Search'),
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text('Practitioners'),
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.navigation),
              title: Text('Other'),
              backgroundColor: Colors.black,
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: _practitionerPages[_practitionerPageIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPractitionerPage,
          type: BottomNavigationBarType.shifting,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.blueAccent,
          currentIndex: _practitionerPageIndex,
          selectedFontSize: 20,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Search'),
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text('Practitioners'),
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('My Account'),
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.navigation),
              title: Text('Other'),
              backgroundColor: Colors.black,
            ),
          ],
        ),
      );
    }
  }
}
