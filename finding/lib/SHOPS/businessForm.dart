import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:finding/constants.dart';




class BusinessForm extends StatefulWidget {
  const BusinessForm({Key? key}) : super(key: key);

  @override
  State<BusinessForm> createState() => _BusinessFormState();
}

class _BusinessFormState extends State<BusinessForm> {
  final TextEditingController bnameController = TextEditingController();
  final TextEditingController bnumberController = TextEditingController();
  final TextEditingController baddressController = TextEditingController();
  String? selectedBcategory;
  int _currentStep = 0;

  final _formKeys = List.generate(4, (_) => GlobalKey<FormState>());
  final List<String> _categories = [
  
    "Logistics 🚚",
    "Cars 🚗",
    "Clothing 👗",
    "Consulting 💼",
    "Delivery 📦",
    "Education 📚",
    "Electronics 💻",
    "Entertainment 🎭",
    "Finance 💰",
    "Fitness 🏋️",
    "Flowers 🌸",
    "Food & Beverage 🍏",
    "Groceries 🛒",
    "Hair care ✂️",
    "Health 🏥",
    "Hobbies 🎨",
    "Home & Garden 🏡",
    "Hotel 🏨",
    "IT 🖥️",
    "Music 🎵",
    "Pets 🐾",
    "Real Estate 🏘️",
    "Restaurant 🍽️",
    "Shopping 🛍️",
    "Sports ⚽",
    "Taxi and rentals 🚕",
    "Technician 🛠️",
    "Travel ✈️",
  ]; // Categories

  Future<void> createBusiness() async {
    final url = Uri.parse('$BASE_URL/business.php');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'bname': bnameController.text,
          'bnumber': bnumberController.text,
          'baddress': baddressController.text,
          'bcategory': selectedBcategory ?? '',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Response: $responseData');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Business created successfully')),
        );
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Business"),
      ),
      body: Column(
        children: [
          // Custom Progress Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: List.generate(5, (index) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    height: 6.0,
                    decoration: BoxDecoration(
                      color: index <= _currentStep
                          ? const Color.fromARGB(255, 14, 79, 71)
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: _buildStepContent(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentStep -= 1;
                      });
                    },
                    child: const Text("Back"),
                  ),
               ElevatedButton(
  onPressed: () {
    if (_currentStep < 4) {
      if (_currentStep == 3) {
        // Validation for category selection
        if (selectedBcategory == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a business category')),
          );
          return; 
        }
      } else if (!_formKeys[_currentStep].currentState!.validate()) {
        return; 
      }
      setState(() {
        _currentStep += 1;
      });
    } else {
      createBusiness();
    }
  },
  child: Text(_currentStep == 4 ? "Submit" : "Next"),
),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return Form(
          key: _formKeys[0],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: bnameController,
              decoration: const InputDecoration(
                labelText: "Business Name",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter the business name";
                }
                return null;
              },
            ),
          ),
        );
      case 1:
        return Form(
          key: _formKeys[1],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: bnumberController,
              decoration: const InputDecoration(
                labelText: "Business Number",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter the business number";
                }
                return null;
              },
            ),
          ),
        );
      case 2:
        return Form(
          key: _formKeys[2],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: baddressController,
              decoration: const InputDecoration(
                labelText: "Business Address",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter the business address";
                }
                return null;
              },
            ),
          ),
        );
      case 3:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Business Category",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, 
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 5, 
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = selectedBcategory == category;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedBcategory = category;
                        });
                      },
                      borderRadius: BorderRadius.circular(8.0),
                      child: SizedBox(
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color.fromARGB(255, 14, 79, 71)
                                : Colors.white,
                            border: Border.all(
                              color: isSelected
                                  ? const Color.fromARGB(255, 14, 79, 71)
                                  : Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold, fontSize: 13
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      case 4:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Review Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text("Business Name: ${bnameController.text}"),
              Text("Business Number: ${bnumberController.text}"),
              Text("Business Address: ${baddressController.text}"),
              Text("Business Category: $selectedBcategory"),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
