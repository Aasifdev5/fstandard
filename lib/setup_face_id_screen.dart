// lib/setup_face_id_screen.dart
import 'package:flutter/material.dart';
import 'utils.dart';

class SetupFaceIDScreen extends StatefulWidget {
  const SetupFaceIDScreen({super.key});

  @override
  State<SetupFaceIDScreen> createState() => _SetupFaceIDScreenState();
}

class _SetupFaceIDScreenState extends State<SetupFaceIDScreen>
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
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _anim,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
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
              const Spacer(flex: 3),

              // Face ID Icon with subtle animation
              ScaleTransition(
                scale: _scale,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: prim.withOpacity(0.3), width: 3),
                  ),
                  child: Icon(
                    Icons.face_retouching_natural,
                    size: 64,
                    color: prim,
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Title
              Text(
                "Setup Face ID",
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
                "Enable face ID authentication on\nStockWave for fast and secure entry.",
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Color(0xFF8A8A8A),
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 5),

              // Scan My Face Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Trigger Face ID enrollment
                    debugPrint("Face ID setup initiated");
                    // Navigate to next screen or show success
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
                    "Scan my face",
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
