import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:finding/constants.dart';

class BeverageBusinessesPage extends StatefulWidget {
  @override
  _BeverageBusinessesPageState createState() => _BeverageBusinessesPageState();
}

class _BeverageBusinessesPageState extends State<BeverageBusinessesPage> {
  List businesses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBeverageBusinesses();
  }

  Future<void> fetchBeverageBusinesses() async {
    final url = Uri.parse('$BASE_URL/beverage.php'); 
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'success') {
          setState(() {
            businesses = data['data'];
            isLoading = false;
          });
        } else {
          showError(data['message']);
        }
      } else {
        showError('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      showError('An error occurred: $e');
    }
  }

  void showError(String message) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Food and Beverage',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: businesses.length,
                    itemBuilder: (context, index) {
                      final business = businesses[index];
                      return ListTile(
                        title: Text(business['bname']),
                        subtitle: Text(business['baddress']),
                        // trailing: Text(business['bnumber']),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
