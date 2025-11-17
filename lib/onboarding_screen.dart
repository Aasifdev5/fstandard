import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'sign_in_screen.dart';
import 'utils.dart';

class OnboardingScreen extends StatelessWidget {
  final PageController controller;
  final bool isFirst;
  const OnboardingScreen({
    super.key,
    required this.controller,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    final String image = isFirst ? "assets/b1.png" : "assets/b2.png";
    final String title = isFirst ? "Stock trading suit" : "Boost your profits";
    final String subtitle = isFirst
        ? "Streamline your investment decisions\nwith expert guidance."
        : "Unlocking profit potential for financial\ngrowth.";

    final prim = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      fadePageRoute(const SignUpScreen()),
                    ),
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        fontSize: 16,
                        color: prim,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      color: prim,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(
                    width: 220,
                    child: Image.asset(image, fit: BoxFit.contain),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.white70 : const Color(0xFF8A8A8A),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _dot(
                    active: isFirst,
                    prim: prim,
                    onTap: () => controller.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                    ),
                  ),
                  const SizedBox(width: 6),
                  _dot(
                    active: !isFirst,
                    prim: prim,
                    onTap: () => controller.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: _outlineBtn(
                      context,
                      "Sign in",
                      () => Navigator.push(
                        context,
                        fadePageRoute(const SignInScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _filledBtn(
                      context,
                      "Sign up",
                      () => Navigator.push(
                        context,
                        fadePageRoute(const SignUpScreen()),
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

  Widget _dot({
    required bool active,
    required Color prim,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: active ? null : onTap,
      child: Container(
        width: active ? 22 : 6,
        height: active ? 4 : 6,
        decoration: BoxDecoration(
          color: active ? prim : const Color(0xFFD0D0D0),
          borderRadius: active
              ? BorderRadius.circular(4)
              : BorderRadius.circular(100),
        ),
      ),
    );
  }

  Widget _outlineBtn(BuildContext ctx, String txt, VoidCallback onTap) {
    final p = Theme.of(ctx).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: p, width: 1.4),
        ),
        alignment: Alignment.center,
        child: Text(
          txt,
          style: TextStyle(fontSize: 16, color: p, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _filledBtn(BuildContext ctx, String txt, VoidCallback onTap) {
    final p = Theme.of(ctx).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: p,
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: Text(
          txt,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
