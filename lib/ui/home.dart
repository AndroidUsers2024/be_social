import 'package:be_social/ui/home_tabs/add_post_tab.dart';
import 'package:be_social/ui/home_tabs/home_tab.dart';
import 'package:flutter/material.dart';

import 'home_tabs/ProfileTab.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeTab(),
    SearchTab(),
    AddPostScreen(),
    NotificationsTab(),
    ProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex==0) {
      // Show a dialog asking the user if they are sure they want to leave without saving
      return (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Text('Do you really want to leave?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // User wants to leave without saving
                },
                child: Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // User wants to stay on the screen
                },
                child: Text('No'),
              ),
            ],
          );
        },
      )) ??
          false; // Default to not pop if dialog is dismissed without an answer
    } else {
      // If no unsaved data, allow the pop
      _onItemTapped(0);
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope (
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Be Social'),
        ),
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.pink,
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }
}

// Dummy Widgets for each tab

class SearchTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Search Tab'));
  }
}

class NotificationsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Notifications Tab'));
  }
}
