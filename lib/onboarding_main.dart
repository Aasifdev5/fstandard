import 'package:flutter/material.dart';
import 'onboarding_screen.dart';
import 'onboarding_screen_3.dart';

class OnboardingMain extends StatefulWidget {
  const OnboardingMain({super.key});

  @override
  State<OnboardingMain> createState() => _OnboardingMainState();
}

class _OnboardingMainState extends State<OnboardingMain> {
  final PageController controller = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        onPageChanged: (index) {
          setState(() => currentPage = index);
        },
        children: [
          OnboardingScreen(controller: controller),
          OnboardingScreen3(controller: controller),
        ],
      ),
    );
  }
}
