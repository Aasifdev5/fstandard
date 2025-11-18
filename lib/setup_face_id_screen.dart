// lib/screens/setup_face_id_screen.dart
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../utils.dart';
import 'home_screen.dart'; // Direct to Home

class SetupFaceIDScreen extends StatefulWidget {
  const SetupFaceIDScreen({super.key});

  @override
  State<SetupFaceIDScreen> createState() => _SetupFaceIDScreenState();
}

class _SetupFaceIDScreenState extends State<SetupFaceIDScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<double> _pulse;

  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticating = false;
  String _statusText = "Ready to scan";

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
    _pulse = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeInOut));
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  Future<void> _authenticateWithFace() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _statusText = "Look at your phone...";
      });

      authenticated = await auth.authenticate(
        localizedReason: 'Scan your face to enable secure login',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      setState(() {
        _statusText = authenticated ? "Face ID Enabled!" : "Failed. Try again";
      });

      if (authenticated) {
        await Future.delayed(const Duration(milliseconds: 1200));
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            fadePageRoute(const HomeScreen()),
            (route) => false,
          );
        }
      }
    } catch (e) {
      setState(() {
        _isAuthenticating = false;
        _statusText = "Face ID not available on this device";
      });
    } finally {
      if (mounted) {
        setState(() => _isAuthenticating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const prim = Color(0xFF6C63FF);

    return Scaffold(
      backgroundColor: const Color(0xFF0E1115),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1115),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70),
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

              // Animated Face Icon with Pulse Effect
              ScaleTransition(
                scale: _pulse,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: _isAuthenticating
                          ? [prim.withOpacity(0.8), prim.withOpacity(0.2)]
                          : [prim.withOpacity(0.4), prim.withOpacity(0.05)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: prim.withOpacity(_isAuthenticating ? 0.9 : 0.5),
                        blurRadius: _isAuthenticating ? 60 : 30,
                        spreadRadius: _isAuthenticating ? 15 : 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.face_retouching_natural,
                    size: 90,
                    color: _isAuthenticating ? Colors.white : prim,
                  ),
                ),
              ),

              const SizedBox(height: 60),

              const Text(
                "Enable Face ID",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              Text(
                _statusText,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 5),

              // Scan Face Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isAuthenticating ? null : _authenticateWithFace,
                  icon: Icon(
                    _isAuthenticating
                        ? Icons.visibility
                        : Icons.face_unlock_outlined,
                    size: 28,
                  ),
                  label: Text(
                    _isAuthenticating ? "Scanning..." : "Scan My Face",
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: prim,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 12,
                    shadowColor: prim.withOpacity(0.6),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Skip & Go to Home
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    fadePageRoute(const HomeScreen()),
                    (route) => false,
                  );
                },
                child: const Text(
                  "Skip & Go to Home",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
