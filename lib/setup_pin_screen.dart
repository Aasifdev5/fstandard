// lib/setup_pin_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils.dart';

class SetupPinScreen extends StatefulWidget {
  const SetupPinScreen({super.key});

  @override
  State<SetupPinScreen> createState() => _SetupPinScreenState();
}

class _SetupPinScreenState extends State<SetupPinScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _fade;
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

    // Auto-focus the hidden TextField
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    _anim.dispose();
    super.dispose();
  }

  String _getDisplayedPin() {
    return _pinController.text.padRight(6, ' ');
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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              const Text(
                "Create New Pin",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Adding a pin number will make your investment secure",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF8A8A8A),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),

              // PIN Display Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  final char = index < _pinController.text.length
                      ? _pinController.text[index]
                      : '';
                  final isActive = index == _pinController.text.length;

                  return Container(
                    width: 48,
                    height: 64,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E1E1E)
                          : const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isActive ? prim : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      char.isEmpty ? '' : '•', // Bullet for entered digits
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
              ),
              const Spacer(),

              // Confirm Button (enabled only when 6 digits)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _pinController.text.length == 6
                      ? () {
                          debugPrint("PIN Set: ${_pinController.text}");
                          // Navigate to next screen (e.g., Confirm PIN or Success)
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
                    "Confirm",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Custom Numeric Keyboard
              _buildNumericKeyboard(prim),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      // Hidden TextField to capture input
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Opacity(
        opacity: 0,
        child: TextField(
          controller: _pinController,
          focusNode: _focusNode,
          keyboardType: TextInputType.none,
          inputFormatters: [LengthLimitingTextInputFormatter(6)],
          onChanged: (value) => setState(() {}),
        ),
      ),
    );
  }

  Widget _buildNumericKeyboard(Color prim) {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['*', '0', 'backspace'],
    ];

    return Column(
      children: keys.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((key) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: 80,
                height: 80,
                child: TextButton(
                  onPressed: () => _onKeyPressed(key),
                  style: TextButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF1E1E1E)
                        : const Color(0xFFF8F9FA),
                    shape: const CircleBorder(),
                  ),
                  child: key == 'backspace'
                      ? Icon(Icons.backspace_outlined, color: prim, size: 28)
                      : Text(
                          key == '*' ? '·' : key,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            color: key == '*' || key == 'backspace'
                                ? prim
                                : null,
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

  void _onKeyPressed(String key) {
    HapticFeedback.lightImpact();
    if (key == 'backspace') {
      if (_pinController.text.isNotEmpty) {
        _pinController.text = _pinController.text.substring(
          0,
          _pinController.text.length - 1,
        );
      }
    } else if (key != '*' && _pinController.text.length < 6) {
      _pinController.text += key;
    }
    setState(() {});
  }
}
