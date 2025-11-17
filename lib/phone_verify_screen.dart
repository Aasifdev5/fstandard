import 'package:flutter/material.dart';
import 'utils.dart';
import 'otp_verify_screen.dart';

class PhoneVerifyScreen extends StatefulWidget {
  const PhoneVerifyScreen({super.key});
  @override
  State<PhoneVerifyScreen> createState() => _PhoneVerifyScreenState();
}

class _PhoneVerifyScreenState extends State<PhoneVerifyScreen> {
  final TextEditingController _phoneCtrl = TextEditingController();
  bool _canSend = false;

  @override
  void initState() {
    super.initState();
    _phoneCtrl.addListener(() {
      setState(() => _canSend = _phoneCtrl.text.trim().length >= 10);
    });
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
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
          "8. Setup – 2 Verify phone number",
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
                "Enter your phone number",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                "You’ll receive a 4 digit code for the\nphone number verification",
                style: TextStyle(color: Color(0xFF8A8A8A), height: 1.4),
              ),
            ),
            const SizedBox(height: 24),

            // Country + Phone field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset("assets/ind.png", width: 24, height: 24),
                        const SizedBox(width: 6),
                        const Icon(Icons.keyboard_arrow_down, size: 20),
                        const SizedBox(width: 6),
                        const Text(
                          "+91",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "000-000-0000",
                        filled: true,
                        fillColor: const Color(0xFFF3F4F6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Send code button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canSend
                      ? () {
                          // dummy user name for now
                          Navigator.push(
                            context,
                            fadePageRoute(
                              OtpVerifyScreen(userName: "Agatha Bella"),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: prim,
                    disabledBackgroundColor: prim.withOpacity(0.4),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Send code",
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
                  _keypadRow(["1", "2", "3"]),
                  _keypadRow(["4", "5", "6"]),
                  _keypadRow(["7", "8", "9"]),
                  _keypadRow(["*", "0", "back"]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _keypadRow(List<String> keys) {
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
              onTap: () {
                final txt = _phoneCtrl.text;
                if (txt.isNotEmpty) {
                  _phoneCtrl.text = txt.substring(0, txt.length - 1);
                }
              },
            );
          }
          return _keypadButton(
            child: Text(
              k,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
            ),
            onTap: () => _phoneCtrl.text += k,
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
