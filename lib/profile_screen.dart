// lib/profile_screen.dart
import 'package:flutter/material.dart';
import 'utils.dart';
import 'widgets/shared_bottom_nav.dart'; // ← Shared navigation
import 'setup_fingerprint_screen.dart'; // ← Add these 3 files later
import 'setup_pin_screen.dart';
import 'setup_face_id_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _fade;

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
    final cardBg = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fade,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 24),

              // Avatar + Name + Email
              Row(
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundImage: AssetImage("assets/avatar_agatha.jpg"),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Agatha Bella",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "agbella@gmail.com",
                        style: TextStyle(color: Color(0xFF8A8A8A)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Invite Friends Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.card_giftcard,
                      size: 28,
                      color: Color(0xFF8A8A8A),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Invite friends",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Invite your friends and get \$15",
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF8A8A8A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Color(0xFF8A8A8A)),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ───── MENU ITEMS ─────
              _menuItem(Icons.person_outline, "Account", prim),
              _menuItem(Icons.fingerprint, "Security", prim),

              // NEW: Biometric & PIN Setup
              _menuItem(
                Icons.fingerprint,
                "Setup Fingerprint",
                prim,
                onTap: () {
                  Navigator.push(
                    context,
                    fadePageRoute(const SetupFingerprintScreen()),
                  );
                },
              ),
              _menuItem(
                Icons.pin,
                "Setup PIN",
                prim,
                onTap: () {
                  Navigator.push(
                    context,
                    fadePageRoute(const SetupPinScreen()),
                  );
                },
              ),
              _menuItem(
                Icons.face_retouching_natural,
                "Setup Face ID",
                prim,
                onTap: () {
                  Navigator.push(
                    context,
                    fadePageRoute(const SetupFaceIDScreen()),
                  );
                },
              ),

              _menuItem(Icons.credit_card, "Billing / Payments", prim),
              _menuItem(
                Icons.language,
                "Language",
                prim,
                trailing: const Text(
                  "English",
                  style: TextStyle(color: Color(0xFF8A8A8A)),
                ),
              ),
              _menuItem(Icons.settings_outlined, "Settings", prim),
              _menuItem(Icons.help_outline, "FAQ", prim),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // PERFECT BOTTOM NAVIGATION – Profile tab active
      bottomNavigationBar: SharedBottomNav(
        currentIndex: 4, // Profile is 5th tab (index 4)
        parentContext: context,
      ),
    );
  }

  Widget _menuItem(
    IconData icon,
    String title,
    Color prim, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF8A8A8A)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing:
          trailing ?? const Icon(Icons.chevron_right, color: Color(0xFF8A8A8A)),
      onTap: onTap ?? () => debugPrint("$title tapped"),
    );
  }
}
