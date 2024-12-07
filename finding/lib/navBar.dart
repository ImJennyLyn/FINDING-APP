import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';

import 'home.dart';
import 'ACCOUNT PAGE/accountScreen.dart';
import 'MESSAGE PAGE/messageScreen.dart';

// void main() {
//   runApp(MaterialApp(
//     home: NavigationBarPage(),
//     debugShowCheckedModeBanner: false,
//   ));
// }
class NavigationBarPage extends StatefulWidget {
  final String userId; // Add this
  final String email; // Add this

  NavigationBarPage({required this.userId, required this.email});

  @override
  _NavigationBarPageState createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage>
    with SingleTickerProviderStateMixin {
  late MotionTabBarController _motionTabBarController;

  @override
  void initState() {
    super.initState();
    print("User navigated to NavigationBarPage.");
    print("Logged-in User:");
    print("User ID: ${widget.userId}");
    print("Email: ${widget.email}");
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _motionTabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Exit App"),
            content: Text("Are you sure you want to exit the app?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("Exit"),
              ),
            ],
          ),
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
        bottomNavigationBar: MotionTabBar(
          controller: _motionTabBarController,
          initialSelectedTab: "Home",
          labels: const ["Home", "Message", "Account"],
          icons: const [Icons.home, Icons.message, Icons.account_circle],
          tabSize: 50,
          tabBarHeight: 55,
          textStyle: const TextStyle(
            fontSize: 12,
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w500,
          ),
          tabIconColor: const Color.fromARGB(255, 255, 255, 255),
          tabIconSize: 28.0,
          tabIconSelectedSize: 26.0,
          tabSelectedColor: const Color.fromARGB(255, 252, 252, 252),
          tabIconSelectedColor: const Color.fromARGB(255, 14, 79, 71),
          tabBarColor: const Color.fromARGB(255, 14, 79, 71),
          onTabItemSelected: (int index) {
            setState(() {
              _motionTabBarController.index = index;
            });
          },
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _motionTabBarController,
          children: <Widget>[
            HomePage(userId: widget.userId, email: widget.email), // Pass data
            MessagePage(
                userId: widget.userId, email: widget.email), // Pass data
            AccountPage(
                userId: widget.userId, email: widget.email), // Pass data
          ],
        ),
      ),
    );
  }
}