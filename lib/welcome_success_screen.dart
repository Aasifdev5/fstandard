import 'package:flutter/material.dart';
import 'utils.dart';
import 'home_screen.dart';

class WelcomeSuccessScreen extends StatefulWidget {
  final String userName; // e.g., "Agatha Bella"
  const WelcomeSuccessScreen({super.key, required this.userName});

  @override
  State<WelcomeSuccessScreen> createState() => _WelcomeSuccessScreenState();
}

class _WelcomeSuccessScreenState extends State<WelcomeSuccessScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _anim,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );
    _scale = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.elasticOut));
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _onStart() {
    // TODO: Navigate to Home / Dashboard
    debugPrint("User ready: ${widget.userName}");
    // Navigator.pushReplacement(context, fadePageRoute(HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final prim = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "10. Setup – Success",
          style: TextStyle(color: Color(0xFF8A8A8A), fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: Stack(
            children: [
              // Confetti particles
              ..._buildParticles(isDark),

              // Main content
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ScaleTransition(
                        scale: _scale,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: prim,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Image.asset(
                            "assets/wel.png",
                            width: 48,
                            height: 48,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                          children: [
                            const TextSpan(text: "Hello "),
                            TextSpan(
                              text: widget.userName,
                              style: TextStyle(color: prim),
                            ),
                            const TextSpan(text: " "),
                            const WidgetSpan(
                              child: Text(
                                "waving_hand",
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Welcome to StockWave",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "It's great to have you here",
                        style: TextStyle(
                          color: isDark
                              ? Colors.white70
                              : const Color(0xFF8A8A8A),
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              fadePageRoute(const HomeScreen()),
                              (route) => false, // Clears previous stack
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: prim,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "I'm ready to start!",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildParticles(bool isDark) {
    final colors = isDark
        ? [
            const Color(0xFF4A90E2),
            const Color(0xFF50C878),
            const Color(0xFFFFD60A),
          ]
        : [
            const Color(0xFF355CFF),
            const Color(0xFF34C759),
            const Color(0xFFFF9500),
          ];

    return [
      _particle(Offset(80, 120), colors[0], size: 8, shape: BoxShape.circle),
      _particle(Offset(280, 140), colors[1], size: 6, shape: BoxShape.circle),
      _particle(Offset(60, 200), colors[2], size: 10, shape: BoxShape.circle),
      _particle(Offset(320, 220), colors[0], size: 7, shape: BoxShape.circle),
      _particle(
        Offset(140, 80),
        colors[1],
        size: 12,
        shape: BoxShape.rectangle,
        rotation: 45,
      ),
      _particle(Offset(240, 100), colors[2], size: 9, shape: BoxShape.circle),
      _particle(Offset(100, 260), colors[0], size: 11, shape: BoxShape.circle),
      _particle(
        Offset(300, 280),
        colors[1],
        size: 8,
        shape: BoxShape.rectangle,
        rotation: -30,
      ),
    ];
  }

  Widget _particle(
    Offset pos,
    Color color, {
    double size = 8,
    BoxShape shape = BoxShape.circle,
    double rotation = 0,
  }) {
    return Positioned(
      left: pos.dx,
      top: pos.dy,
      child: Transform.rotate(
        angle: rotation * 3.14159 / 180,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: color, shape: shape),
        ),
      ),
    );
  }
}
