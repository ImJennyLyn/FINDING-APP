import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'startedpage.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: [
              buildPage(
                title: "Lorem ipsum firin ameri!",
                description:
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean eget ex eget justo vehicula interdum vitae nec risus.",
                bgColor: const Color.fromARGB(255, 255, 255, 255),
              ),
              buildPage(
                title: "Aenean eget risus!",
                description:
                    "In laoreet congue leo sed rutrum. Vivamus tincidunt tortor eu finibus sagittis.",
                bgColor:const Color.fromARGB(255, 255, 255, 255),
              ),
              buildPage(
                title: "Consectetur adipiscing!",
                description:
                    "Etiam facilisis, lectus a bibendum bibendum, arcu velit tempus ligula, sed elementum enim tortor a purus.",
                bgColor: const Color.fromARGB(255, 255, 255, 255),
              ),
              buildPage(
                title: "Vivamus tincidunt tortor!",
                description:
                    "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.",
                bgColor: const Color.fromARGB(255, 255, 255, 255),
              ),
            ],
          ),
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 4,
                effect: WormEffect(
                  activeDotColor: Color.fromARGB(255, 14, 79, 71),
                  dotHeight: 12,
                  dotWidth: 12,
                  spacing: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40, right: 15),
        child: FloatingActionButton(
          onPressed: () {
           
            if (_pageController.page!.toInt() < 3) {
              _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } else {
             
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
              );
            }
          },
          backgroundColor: Color.fromARGB(255, 14, 79, 71),
          child: Icon(Icons.arrow_forward, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget buildPage({
    required String title,
    required String description,
    required Color bgColor,
  }) {
    return Container(
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             const SizedBox(height: 50),

            Container(
              
              width: 350,
              height: 400,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
         
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15.0),
            // Description text
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
