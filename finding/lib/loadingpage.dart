// import 'package:flutter/material.dart';
// import 'dart:async';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: LoadingPage(),
//     );
//   }
// }

// class LoadingPage extends StatefulWidget {
//   @override
//   _LoadingPageState createState() => _LoadingPageState();
// }

// class _LoadingPageState extends State<LoadingPage> {
//   @override
//   void initState() {
//     super.initState();
  
//     Future.delayed(Duration(seconds: 10), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => StartPage()),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 14, 79, 71),
//       body: Center(
//         child: AnimatedWriteText('Finding', 3),
//       ),
//     );
//   }
// }

// class AnimatedWriteText extends StatefulWidget {
//   final String text;
//   final double durationInSeconds;

//   AnimatedWriteText(this.text, this.durationInSeconds);

//   @override
//   _AnimatedWriteTextState createState() => _AnimatedWriteTextState();
// }

// class _AnimatedWriteTextState extends State<AnimatedWriteText>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   late List<int> _drawnChars;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: widget.durationInSeconds.toInt()),
//     );

//     _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
//       ..addListener(() {
//         setState(() {
        
//         });
//       });

//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: HandwritingPainter(widget.text, _animation.value),
//     );
//   }
// }

// class HandwritingPainter extends CustomPainter {
//   final String text;
//   final double animationValue;

//   HandwritingPainter(this.text, this.animationValue);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = Colors.yellow[700]!
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 3;

//     TextSpan textSpan = TextSpan(
//       text: text,
//       style: TextStyle(
//         fontFamily: 'DancingScript',
//         fontSize: 64.0,
//         color: Colors.yellow[700],
//         fontWeight: FontWeight.bold,
//       ),
//     );
//     TextPainter textPainter = TextPainter(
//       text: textSpan,
//       textAlign: TextAlign.center,
//       textDirection: TextDirection.ltr,
//     );

//     textPainter.layout();

//     // Draw each letter progressively based on the animation value
//     int numCharsToDraw = (animationValue * text.length).toInt();
//     for (int i = 0; i < numCharsToDraw; i++) {
//       textPainter.paint(canvas, Offset(30.0 + (i * 40.0), size.height / 2));
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }

// class StartPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Start Page")),
//       body: Center(child: Text("This is the start page!")),
//     );
//   }
// }
