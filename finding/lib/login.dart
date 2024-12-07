import 'dart:convert';

import 'package:finding/constants.dart';
import 'package:finding/navBar.dart';
import 'package:finding/stepper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Future<void> loginUser(BuildContext context) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/login.php'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        'email': _emailController.text,
        'password': _passwordController.text,
      },
    );

    try {
      var data = jsonDecode(response.body);
      print("Response Body: ${response.body}"); // Debugging output

      if (data['status'] == 'success') {
        print("Login Successful!");

        // Extract and log the user data
        String userId = data['u_id']
            .toString(); // Convert to String in case it's an integer
        String email = data['email'];
        print("Logged-in User:");
        print("User ID: $userId");
        print("Email: $email");

        // Save to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('u_id', userId);
        prefs.setString('email', email);

        // Navigate to the next page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => NavigationBarPage(
                    userId: userId, // Pass the user ID
                    email: email, // Pass the email
                  )),
        );
      } else {
        print("Login Failed: ${data['message'] ?? 'Unknown error'}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Login failed")),
        );
      }
    } catch (e) {
      print("Error decoding JSON: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An unexpected error occurred.")),
      );
    }
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs
        .getString('u_id'); // Returns the stored user ID, or null if not set
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "LOGIN",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 30),
            // Username TextField
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Username",
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Password TextField
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => loginUser(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 14, 79, 71),
                padding:
                    const EdgeInsets.symmetric(vertical: 13, horizontal: 163),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Log In",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HorizontalMultiStepForm()),
                );
              },
              child: const Text(
                "Don't have an account? Sign up",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue, // Makes the text look clickable
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}