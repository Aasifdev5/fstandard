import 'package:flutter/material.dart';
import 'onboarding_screen.dart';
import 'utils.dart';
import 'main.dart';

class OnboardingMain extends StatefulWidget {
  const OnboardingMain({super.key});
  @override
  State<OnboardingMain> createState() => _OnboardingMainState();
}

class _OnboardingMainState extends State<OnboardingMain> {
  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (i) => setState(() => _page = i),
            children: [
              OnboardingScreen(controller: _controller, isFirst: true),
              OnboardingScreen(controller: _controller, isFirst: false),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.dark_mode),
              onPressed: ThemeSwitcher.of(context)!.toggle,
            ),
          ),
        ],
      ),
    );
  }
}
