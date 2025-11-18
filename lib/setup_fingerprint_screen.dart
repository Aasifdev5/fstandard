// lib/screens/setup_fingerprint_screen.dart
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../utils.dart';
import 'setup_pin_screen.dart';

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
  final LocalAuthentication auth = LocalAuthentication();

  bool _isAuthenticating = false;
  String _authStatus = "Touch the sensor";

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

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authStatus = "Authenticating...";
      });

      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to secure your account',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      setState(() {
        _isAuthenticating = false;
        _authStatus = authenticated ? "Success!" : "Failed. Try again";
      });

      if (authenticated) {
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            fadePageRoute(const SetupPinScreen()),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isAuthenticating = false;
        _authStatus =
            "Error: ${e.toString().contains("not available") ? "No fingerprint enrolled" : "Try again"}";
      });
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

              // Fingerprint Icon (pulses when authenticating)
              ScaleTransition(
                scale: _scale,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: _isAuthenticating
                          ? [prim.withOpacity(0.6), prim.withOpacity(0.1)]
                          : [prim.withOpacity(0.3), prim.withOpacity(0.05)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: prim.withOpacity(_isAuthenticating ? 0.8 : 0.4),
                        blurRadius: _isAuthenticating ? 50 : 30,
                        spreadRadius: _isAuthenticating ? 10 : 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.fingerprint,
                    size: 100,
                    color: _isAuthenticating ? Colors.white : prim,
                  ),
                ),
              ),

              const SizedBox(height: 60),

              const Text(
                "Add Fingerprint",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              Text(
                _authStatus,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 5),

              // Touch Sensor Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isAuthenticating ? null : _authenticate,
                  icon: const Icon(Icons.fingerprint, size: 28),
                  label: Text(
                    _isAuthenticating
                        ? "Authenticating..."
                        : "Touch the Sensor",
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: prim,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 10,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  fadePageRoute(const SetupPinScreen()),
                ),
                child: const Text(
                  "Skip & Use PIN Only",
                  style: TextStyle(color: Colors.grey),
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
