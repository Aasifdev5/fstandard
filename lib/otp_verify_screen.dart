import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils.dart';
import 'welcome_success_screen.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String userName; // required
  const OtpVerifyScreen({super.key, required this.userName});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _canVerify = false;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 6; i++) {
      _controllers[i].addListener(_checkIfFilled);
    }
  }

  void _checkIfFilled() {
    final filled = _controllers.every((c) => c.text.isNotEmpty);
    if (filled != _canVerify) setState(() => _canVerify = filled);
  }

  void _onKeypadPress(String key) {
    for (var ctrl in _controllers) {
      if (ctrl.text.isEmpty) {
        ctrl.text = key;
        final idx = _controllers.indexOf(ctrl);
        if (idx < 5) FocusScope.of(context).requestFocus(_focusNodes[idx + 1]);
        break;
      }
    }
    _checkIfFilled();
  }

  void _onBackspace() {
    for (var i = 5; i >= 0; i--) {
      if (_controllers[i].text.isNotEmpty) {
        _controllers[i].clear();
        if (i > 0) FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
        break;
      }
    }
    _checkIfFilled();
  }

  void _onVerify() {
    if (!_canVerify) return;
    final code = _controllers.map((c) => c.text).join();
    debugPrint("Verify OTP: $code");

    // Navigate to Welcome screen (dummy data for now)
    Navigator.pushReplacement(
      context,
      fadePageRoute(WelcomeSuccessScreen(userName: widget.userName)),
    );
  }

  void _onResend() => debugPrint("Resend code");

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
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
          "9. Setup – Enter verification code",
          style: TextStyle(color: Color(0xFF8A8A8A), fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Enter verification code",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                "We have sent the code verification to your\nmobile number",
                style: TextStyle(color: Color(0xFF8A8A8A), height: 1.4),
              ),
            ),
            const SizedBox(height: 32),

            // 6-digit OTP fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) {
                  return SizedBox(
                    width: 48,
                    height: 56,
                    child: TextField(
                      controller: _controllers[i],
                      focusNode: _focusNodes[i],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.none,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        counterText: "",
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF2A2A2A)
                            : const Color(0xFFF3F4F6),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: prim, width: 2),
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (v) {
                        if (v.isNotEmpty && i < 5) {
                          FocusScope.of(
                            context,
                          ).requestFocus(_focusNodes[i + 1]);
                        } else if (v.isEmpty && i > 0) {
                          FocusScope.of(
                            context,
                          ).requestFocus(_focusNodes[i - 1]);
                        }
                      },
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 16),

            // Resend code
            Center(
              child: GestureDetector(
                onTap: _onResend,
                child: Text(
                  "Resend code",
                  style: TextStyle(color: prim, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Verify button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canVerify ? _onVerify : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: prim,
                    disabledBackgroundColor: prim.withOpacity(0.4),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Verify account",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Keypad
            Container(
              padding: const EdgeInsets.only(top: 24, bottom: 32),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E1E1E)
                    : const Color(0xFFFAFAFA),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  _keypadRow(["1", "2", "3"], _onKeypadPress),
                  _keypadRow(["4", "5", "6"], _onKeypadPress),
                  _keypadRow(["7", "8", "9"], _onKeypadPress),
                  _keypadRow(
                    ["*", "0", "back"],
                    _onKeypadPress,
                    onBackspace: _onBackspace,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _keypadRow(
    List<String> keys,
    void Function(String) onPress, {
    VoidCallback? onBackspace,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: keys.map((k) {
          if (k == "back") {
            return _keypadButton(
              child: const Icon(
                Icons.backspace_outlined,
                size: 28,
                color: Color(0xFF8A8A8A),
              ),
              onTap: onBackspace!,
            );
          }
          return _keypadButton(
            child: Text(
              k,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
            ),
            onTap: () => onPress(k),
          );
        }).toList(),
      ),
    );
  }

  Widget _keypadButton({required Widget child, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
