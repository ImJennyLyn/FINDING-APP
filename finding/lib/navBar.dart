import 'package:flutter/material.dart';
import 'home.dart';
import 'package:finding/MESSAGE PAGE/messageScreen.dart';
import 'package:finding/ACCOUNT PAGE/accountScreen.dart';

void main() {
  runApp(MaterialApp(
    home: NavigationBarPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class NavigationBarPage extends StatefulWidget {
  @override
  _NavigationBarPageState createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: <Widget>[
          HomePage(),
          MessagePage(),
          AccountPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex == 0 ? Icons.home : Icons.home_outlined,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex == 1 ? Icons.message : Icons.message_outlined,
            ),
            label: "Message",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex == 2 ? Icons.account_circle : Icons.account_circle_outlined,
            ),
            label: "Account",
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(255, 238, 230, 230),
        backgroundColor: const Color.fromARGB(255, 14, 79, 71),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
