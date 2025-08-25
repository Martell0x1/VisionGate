import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:vision_gate/Screens/home_page.dart';


class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    
    // Navigate after a delay
    _navigateToHomePage();
  }

  Future<void> _navigateToHomePage() async {
    await Future.delayed(const Duration(seconds: 5));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()), // Ensure HomePage is properly defined
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated text
            AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  'Welcome to VisionGate',
                  textStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  speed: Duration(milliseconds: 50),
                ),
              ],
              totalRepeatCount: 1,
              pause: Duration(milliseconds: 500),
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            ),

            // Animation
            Lottie.asset(
              'assets/animations/car_parking_valet.json',
              width: 400,
              height: 400,
              fit: BoxFit.contain,
              alignment: Alignment.center,
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}