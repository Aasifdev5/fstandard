// lib/verification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils.dart';

class VerificationScreen extends StatefulWidget {
  final String email; // Pass from previous screen

  const VerificationScreen({super.key, required this.email});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _fade;

  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _resendCountdown = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
    _anim.forward();

    // Start resend countdown
    Future.delayed(const Duration(seconds: 1), _startCountdown);
  }

  void _startCountdown() {
    if (!mounted) return;
    if (_resendCountdown > 0) {
      setState(() => _resendCountdown--);
      Future.delayed(const Duration(seconds: 1), _startCountdown);
    } else {
      setState(() => _canResend = true);
    }
  }

  void _resendCode() {
    setState(() {
      _resendCountdown = 30;
      _canResend = false;
    });
    _startCountdown();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Verification code resent!")));
  }

  bool get _isComplete => _controllers.every((c) => c.text.isNotEmpty);

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final prim = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF121212) : Colors.white;
    final boxBg = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FadeTransition(
        opacity: _fade,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Enter verification code",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                "We have sent the code verification to your mobile number",
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF8A8A8A),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),

              // 6-Digit OTP Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 50,
                    height: 56,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: boxBg,
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: prim, width: 2),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          if (index < 5) {
                            _focusNodes[index + 1].requestFocus();
                          } else {
                            _focusNodes[index].unfocus();
                          }
                        } else if (index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                        setState(() {});
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 24),

              // Resend Code
              Center(
                child: _canResend
                    ? TextButton(
                        onPressed: _resendCode,
                        child: Text(
                          "Resend code",
                          style: TextStyle(
                            color: prim,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : Text(
                        "Resend code in $_resendCountdown s",
                        style: const TextStyle(color: Color(0xFF8A8A8A)),
                      ),
              ),

              const Spacer(),

              // Verify Account Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isComplete
                      ? () {
                          final code = _controllers.map((c) => c.text).join();
                          debugPrint(
                            "OTP Submitted: $code for ${widget.email}",
                          );
                          // Navigate to CreateNewPasswordScreen()
                          // Navigator.push(context, fadePageRoute(CreateNewPasswordScreen()));
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: prim,
                    disabledBackgroundColor: prim.withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Verify account",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
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
