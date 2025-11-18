// lib/screens/setup_pin_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils.dart';
import 'setup_success_screen.dart'; // We'll create this next

class SetupPinScreen extends StatefulWidget {
  const SetupPinScreen({super.key});

  @override
  State<SetupPinScreen> createState() => _SetupPinScreenState();
}

class _SetupPinScreenState extends State<SetupPinScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _fade;

  String _firstPin = '';
  String _confirmPin = '';
  bool _isConfirming = false;

  final TextEditingController _pinController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
    _anim.forward();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _focusNode.requestFocus(),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    _anim.dispose();
    super.dispose();
  }

  void _onKeyPressed(String key) {
    HapticFeedback.lightImpact();
    final current = _pinController.text;

    if (key == 'backspace') {
      if (current.isNotEmpty) {
        _pinController.text = current.substring(0, current.length - 1);
      }
    } else if (key != '*' && current.length < 6) {
      _pinController.text = current + key;
    }

    // Auto-submit when 6 digits entered
    if (_pinController.text.length == 6) {
      _handlePinComplete();
    }
    setState(() {});
  }

  void _handlePinComplete() async {
    if (!_isConfirming) {
      _firstPin = _pinController.text;
      setState(() => _isConfirming = true);
      _pinController.clear();
      await Future.delayed(const Duration(milliseconds: 300));
      _focusNode.requestFocus();
    } else {
      _confirmPin = _pinController.text;
      if (_firstPin == _confirmPin) {
        // SUCCESS!
        Navigator.pushReplacement(
          context,
          fadePageRoute(const SetupSuccessScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("PINs don't match. Try again."),
            backgroundColor: Colors.red,
          ),
        );
        _pinController.clear();
        setState(() => _isConfirming = false);
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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              Text(
                _isConfirming ? "Confirm Your PIN" : "Set Up Your PIN",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                _isConfirming
                    ? "Re-enter your 6-digit PIN to confirm"
                    : "Choose a 6-digit PIN for quick & secure access",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),

              // PIN Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (i) {
                  final filled = i < _pinController.text.length;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled ? prim : Colors.transparent,
                      border: Border.all(
                        color: filled ? prim : Colors.grey[600]!,
                        width: 2,
                      ),
                    ),
                  );
                }),
              ),

              const Spacer(),

              // Custom Keyboard
              _buildKeyboard(prim),

              const SizedBox(height: 30),

              // Hidden TextField
              Opacity(
                opacity: 0,
                child: TextField(
                  controller: _pinController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.none,
                  inputFormatters: [LengthLimitingTextInputFormatter(6)],
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeyboard(Color prim) {
    final rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', 'backspace'],
    ];

    return Column(
      children: rows.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((key) {
            if (key.isEmpty) return const SizedBox(width: 100);

            return Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: 82,
                height: 82,
                child: Material(
                  color: const Color(0xFF111419),
                  borderRadius: BorderRadius.circular(50),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () => _onKeyPressed(key),
                    child: Center(
                      child: key == 'backspace'
                          ? Icon(
                              Icons.backspace_outlined,
                              color: prim,
                              size: 28,
                            )
                          : Text(
                              key,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
