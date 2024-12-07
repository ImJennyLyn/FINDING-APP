import 'package:flutter/material.dart';
import 'hotline.dart';
import 'login.dart';
import 'registration.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WelcomeScreen(),
  ));
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(25.0),
            
            child: Text(
              "How can we help?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(height: 10),
        Expanded(
        child: GridView.count(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            buildHelpOption(
              context,
              Icons.phone,
              "Hotline",
              true, 
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmergencyHotlinesPage()),
                );
              },
            ),
            buildHelpOption(
              context,
              Icons.search,
              "Search Shops",
              false, // Disabled
              null,
            ),
            buildHelpOption(
              context,
              Icons.two_wheeler,
              "Rides",
              false, // Disabled
              null,
            ),
            buildHelpOption(
              context,
              Icons.local_shipping,
              "Deliveries",
              false, // Disabled
              null,
            ),
            buildHelpOption(
              context,
              Icons.share,
              "MyGrow",
              false, // Disabled
              null,
            ),
            buildHelpOption(
              context,
              Icons.groups,
              "Community",
              false, // Disabled
              null,
            ),
          ],
        ),
      ),

          Container(
              decoration: BoxDecoration(
              color: const Color(0xFF234239), 
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), 
                topRight: Radius.circular(20), 
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Let's get you started!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "In just a flash, you can access all our offers, services, and more.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Registration()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green[900],
                      minimumSize: const Size(150, 50), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Sign Up"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF234239),
                      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                      minimumSize: const Size(150, 50), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                    child: const Text("Log In"),
                  ),
                ],
              ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHelpOption(
    BuildContext context, IconData icon, String label, bool isActive, VoidCallback? onTap) {
  return GestureDetector(
    onTap: isActive ? onTap : null, // Disable tap if not active
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
            color: isActive ? const Color.fromARGB(255, 1, 26, 1) : Colors.grey,
          ),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              color: isActive ? const Color.fromARGB(255, 11, 73, 41) : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
  );
}
}



class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
     
    );
  }
}
