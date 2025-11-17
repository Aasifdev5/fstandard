// lib/setup_fingerprint_screen.dart
import 'package:flutter/material.dart';
import 'utils.dart';

class SetupFingerprintScreen extends StatefulWidget {
  const SetupFingerprintScreen({super.key});

  @override
  State<SetupFingerprintScreen> createState() => _SetupFingerprintScreenState();
}

class _SetupFingerprintScreenState extends State<SetupFingerprintScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _anim,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _scale = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.elasticOut));
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final prim = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF121212) : Colors.white;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FadeTransition(
        opacity: _fade,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 4),

              // Animated Fingerprint Icon
              ScaleTransition(
                scale: _scale,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: prim.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.fingerprint, size: 80, color: prim),
                ),
              ),

              const SizedBox(height: 48),

              // Title
              Text(
                "Fingerprint",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Subtitle
              Text(
                "Effortlessly unlock stockline using your\nfingerprint for enhanced security.",
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Color(0xFF8A8A8A),
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 6),

              // Next Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Trigger biometric enrollment or skip
                    debugPrint("Fingerprint setup → Next");
                    // Navigator.push(... next screen)
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: prim,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
