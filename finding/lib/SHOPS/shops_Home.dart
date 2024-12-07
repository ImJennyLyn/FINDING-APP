import 'package:finding/SHOPS/businessForm.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:finding/CATEGORIES/beverage.dart';
import 'package:finding/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ShopsHome extends StatefulWidget {
  @override
  _ShopsHomeState createState() => _ShopsHomeState();
}

class _ShopsHomeState extends State<ShopsHome> {
  final List<Map<String, dynamic>> categoryList = [
    {"icon": Icons.fastfood, "title": "Food & Beverage"},
    {"icon": FontAwesomeIcons.shirt, "title": "Clothing"},
    {"icon": FontAwesomeIcons.utensils, "title": "Restaurant"}, 
    {"icon": FontAwesomeIcons.scissors, "title": "Hair Care"}, 
    {"icon": FontAwesomeIcons.plug, "title": "Electronics"},  
    {"icon": FontAwesomeIcons.football, "title": "Sports"},   
    {"icon": FontAwesomeIcons.masksTheater, "title": "Entertainment"}, 
    {"icon": FontAwesomeIcons.book, "title": "Education"}, 
    {"icon": FontAwesomeIcons.truck, "title": "Delivery"}, 
    {"icon": FontAwesomeIcons.dumbbell, "title": "Fitness"}, 
  ]; 
    // "Beauty 💄",
    // "Logistics 🚚",
    // "Cars 🚗",
    // "Clothing 👗",
    // "Consulting 💼",
    // "Delivery 📦",
    // "Education 📚",
    // "Electronics 💻",
    // "Entertainment 🎭",
    // "Finance 💰",
    // "Fitness 🏋️",
    // "Flowers 🌸",
    // "Food & Beverage 🍏",
    // "Groceries 🛒",
    // "Hair care ✂️",
    // "Health 🏥",
    // "Hobbies 🎨",
    // "Home & Garden 🏡",
    // "IT 🖥️",
    // "Music 🎵",
    // "Pets 🐾",
    // "Real Estate 🏘️",
    // "Restaurant 🍽️",
    // "Sports ⚽",
    // "Taxi and rentals 🚕",
    // "Technician 🛠️",
    // "Travel ✈️",
  final List<String> topPicks = [
    'asset/images/1.jpg',
    'asset/images/2.jpg',
    'asset/images/3.jpg',
  ];@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 14, 79, 71),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 14, 79, 71),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.store, color: Colors.white, size: 30,),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color.fromARGB(255, 13, 91, 48), Color.fromARGB(255, 33, 129, 99)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.close),
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Image.asset(
                          //   'assets/business_image.png', 
                          //   height: 100,
                          // ),
                          const SizedBox(height: 16),
                          const Text(
                            "Grow your business",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Column(
                            children: const [
                              ListTile(
                                leading:
                                    Icon(Icons.star, color: Colors.white),
                                title: Text(
                                  "Create a business profile",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ListTile(
                                leading:
                                    Icon(Icons.shop, color: Colors.white),
                                title: Text(
                                  "Feature your products and services.",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ListTile(
                                leading:
                                    Icon(Icons.search, color: Colors.white),
                                title: Text(
                                  "Make your business easy to find nearby",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                             
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color.fromARGB(255, 11, 92, 49),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 24,
                              ),
                            ),
                           onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => BusinessForm()),
                                  );
                                },

                            child: const Text("Create business profile"),
                          ),
                          const SizedBox(height: 8),
                          // TextButton(
                          //   onPressed: () {
                          //     // Navigate to learn more page o
                          //   },
                          //   child: const Text(
                          //     "Learn more",
                          //     style: TextStyle(color: Colors.white),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
              child: Container(
                height: 50,
                width: 380,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: const [
                    SizedBox(width: 10),
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Text(
                      "Search Shop",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Categories",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            categoryList.length,
                            (index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: _buildCategory(
                                categoryList[index]['icon'],
                                categoryList[index]['title'],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Top Picks",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildCarousel(topPicks),
                      const SizedBox(height: 16),
                      const Text(
                        "My Favorites",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(
                          4,
                          (index) => Expanded(
                            child: Container(
                              height: 100,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildCategory(IconData icon, String title) {
  return GestureDetector(
    onTap: () {
      if (title == "Fashion") {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => FashionPage()),
        // );
      } else if (title == "Food & Beverage") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BeverageBusinessesPage ()),
        );
      }
      
      // Add similar checks for other categories
    },
    child: Column(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 40,
            color: const Color.fromARGB(255, 14, 79, 71),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    ),
  );
}


Widget _buildCarousel(List<String> images) {
  return CarouselSlider(
    options: CarouselOptions(
      height: 120,
    
      aspectRatio: 12 / 9,
      viewportFraction: 0.8,
      enableInfiniteScroll: true,

    ),
    items: List.generate(
      images.length,
      (index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),

        child: Center(
          child: Text(
            "Top Pick ${index + 1}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      ),
    ),
  );
}
}


  Widget _buildCategory(IconData icon, String title) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 40,
            color: const Color.fromARGB(255, 14, 79, 71),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
      ],
    );
  }


class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController searchController;
  List<Business> filteredBusinesses = [];

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  Future<List<Business>> fetchBusinesses(String keyword) async {
    final url = Uri.parse('$BASE_URL/business_list.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        List<Business> businessesList = (data['data'] as List)
            .map((business) => Business.fromJson(business))
            .toList();

        return businessesList
            .where((business) =>
                business.bname.toLowerCase().contains(keyword.toLowerCase()) ||
                business.baddress.toLowerCase().contains(keyword.toLowerCase()) ||
                business.bcategory.toLowerCase().contains(keyword.toLowerCase()))
            .toList(); 
      } else {
        throw Exception('Failed to load businesses');
      }
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  void filterBusinesses(String keyword) {
    fetchBusinesses(keyword).then((businesses) {
      setState(() {
        filteredBusinesses = businesses;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 14, 79, 71),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: TextField(
          controller: searchController,
          onChanged: (value) => filterBusinesses(value),
          style: TextStyle(
            color: Colors.white, // Change the font color here
          ),
          decoration: const InputDecoration(
            hintText: 'Search for Business',
            hintStyle: TextStyle(color: Color.fromARGB(255, 246, 239, 239)),
            border: InputBorder.none,
          ),
        ),
      ),


      body: filteredBusinesses.isNotEmpty
          ? ListView.builder(
              itemCount: filteredBusinesses.length,
              itemBuilder: (context, index) {
                final business = filteredBusinesses[index];
              return ListTile(
  title: Text(business.bname),
  subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
  
      Text(business.baddress),
    ],
  ),
);

              },
            )
          : const Center(child: Text('No Result')),
    );
  }
}

class Business {
  final String bref;
  final String bname;
  final String bnumber;
  final String baddress;
  final String bcategory;

  Business({
    required this.bref,
    required this.bname,
    required this.bnumber,
    required this.baddress,
    required this.bcategory,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      bref: json['bref'] ?? '',
      bname: json['bname'] ?? '',
      bnumber: json['bnumber'] ?? '',
      baddress: json['baddress'] ?? '',
      bcategory: json['bcategory'] ?? '',
    );
  }
}
  