import 'package:flutter/material.dart';
import 'onboarding_main.dart';
import 'utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Splash delay for GIF display
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, fadePageRoute(const OnboardingMain()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Image.asset(
          "assets/design.gif",
          width: 500, // Adjust size as needed
          height: 500,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
