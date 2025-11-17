import 'package:flutter/material.dart';
import 'signup_screen.dart';

class OnboardingScreen extends StatelessWidget {
  final PageController controller;

  const OnboardingScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Skip button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignUpScreen()),
                      );
                    },
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4F6AF3),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Image circle
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 260,
                    height: 260,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4F6AF3),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(
                    width: 220,
                    child: Image.asset("assets/b1.png", fit: BoxFit.contain),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              const Text(
                "Stock trading suit",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              const Text(
                "Streamline your investment decisions\nwith expert guidance.",
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF8A8A8A),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 28),

              // Pagination
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Active
                  Container(
                    width: 22,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F6AF3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 6),

                  // Dot → go to second page
                  GestureDetector(
                    onTap: () {
                      controller.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFD0D0D0),
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: const Color(0xFF4F6AF3),
                            width: 1.4,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Sign in",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF4F6AF3),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4F6AF3),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 26),
            ],
          ),
        ),
      ),
    );
  }
}
