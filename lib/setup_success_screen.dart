// lib/screens/setup_success_screen.dart
import 'package:flutter/material.dart';
import '../utils.dart';
import 'home_screen.dart'; // Fixed import

class SetupSuccessScreen extends StatefulWidget {
  const SetupSuccessScreen({super.key});

  @override
  State<SetupSuccessScreen> createState() => _SetupSuccessScreenState();
}

class _SetupSuccessScreenState extends State<SetupSuccessScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    // Auto go to HomeScreen after success
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          fadePageRoute(const HomeScreen()),
          (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1115),
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Success Check
              ScaleTransition(
                scale: _scale,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF00D09C), Color(0xFF00A879)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF00D09C),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check, size: 90, color: Colors.white),
                ),
              ),

              const SizedBox(height: 48),

              // Title
              const Text(
                "All Set!",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Your account is now protected with PIN & Biometric authentication",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[400],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 80),

              // Optional: Manual Continue Button
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    fadePageRoute(const HomeScreen()),
                    (route) => false,
                  );
                },
                child: const Text(
                  "Continue to Home",
                  style: TextStyle(
                    color: Color(0xFF6C63FF),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
