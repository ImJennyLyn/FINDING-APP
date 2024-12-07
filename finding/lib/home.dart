import 'dart:convert';

import 'package:finding/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String userId; // User ID passed from the previous page
  final String email;
  HomePage({required this.userId, required this.email});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? firstName; // Store the first name of the user
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/get_user_data.php?u_id=${widget.userId}'),
      );

      // Print the raw response body for debugging
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          setState(() {
            firstName = data['data']['fname'];
            isLoading = false;
          });
        } else {
          print("Error: ${data['message']}");
        }
      } else {
        print("Failed to fetch user data: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Text(
              "Hi, ${firstName ?? 'User'}!", // Display user's first name
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Text(
              "Need some help today?",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  buildOption(context, "Referral", Icons.group, ReferralPage()),
                  buildOption(context, "Shops", Icons.store, ShopsHome()),
                  buildOption(context, "Rides", Icons.two_wheeler, RidesPage()),
                  buildOption(context, "Deliveries", Icons.local_shipping,
                      DeliveriesPage()),
                  buildOption(context, "MyGrow", Icons.share, MyGrowPage()),
                  buildOption(
                      context, "Community", Icons.groups, CommunityPage()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOption(
      BuildContext context, String title, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              spreadRadius: 2,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 70, color: Colors.black),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder pages
class ReferralPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Referral")),
      body: Center(child: Text("Referral Page")),
    );
  }
}

class RidesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rides")),
      body: Center(child: Text("Rides Page")),
    );
  }
}

class DeliveriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Deliveries")),
      body: Center(child: Text("Deliveries Page")),
    );
  }
}

class MyGrowPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MyGrow")),
      body: Center(child: Text("MyGrow Page")),
    );
  }
}

class CommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Community")),
      body: Center(child: Text("Community Page")),
    );
  }
}

class ShopsHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shops")),
      body: Center(child: Text("Shops Page")),
    );
  }
}