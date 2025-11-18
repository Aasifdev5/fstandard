// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../utils.dart';
import '../widgets/shared_bottom_nav.dart';

// Security Screens
import 'setup_fingerprint_screen.dart';
import 'setup_pin_screen.dart';
import 'setup_face_id_screen.dart';

// NEW: Portfolio & Watchlist Screens (PROPERLY ADDED)
import 'portfolio_screen.dart'; // ← Your Holdings (Long-term)
import 'watchlist_screen.dart'; // ← Your Watchlist / Favorites

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
      duration: const Duration(milliseconds: 700),
    );
    _fade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF111419),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Logout",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Are you sure you want to logout?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Logged out successfully"),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0E1115);
    const cardBg = Color(0xFF111419);
    const prim = Color(0xFF6C63FF);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fade,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 12),

              // Profile Header
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: const AssetImage(
                      "assets/avatar_agatha.jpg",
                    ),
                    backgroundColor: prim.withOpacity(0.2),
                    child: const Icon(Icons.person, size: 40, color: prim),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Agatha Bella",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "agbella@gmail.com",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Invite Friends Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: prim.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: prim.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.card_giftcard,
                        color: prim,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Invite Friends & Earn",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Get ₹500 when your friend trades",
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 18,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // === MENU SECTIONS ===
              _buildSectionTitle("My Portfolio"),
              _menuItem(
                icon: Icons.pie_chart,
                title: "Holdings",
                onTap: () => Navigator.push(
                  context,
                  fadePageRoute(const PortfolioScreen()),
                ),
              ),
              _menuItem(
                icon: Icons.bookmark_outline,
                title: "Watchlist",
                onTap: () => Navigator.push(
                  context,
                  fadePageRoute(const WatchlistScreen()),
                ),
              ),

              _buildSectionTitle("Security"),
              _menuItem(
                icon: Icons.fingerprint,
                title: "Setup Fingerprint",
                onTap: () => Navigator.push(
                  context,
                  fadePageRoute(const SetupFingerprintScreen()),
                ),
              ),
              _menuItem(
                icon: Icons.pin,
                title: "Setup PIN",
                onTap: () => Navigator.push(
                  context,
                  fadePageRoute(const SetupPinScreen()),
                ),
              ),
              _menuItem(
                icon: Icons.face_retouching_natural,
                title: "Setup Face ID",
                onTap: () => Navigator.push(
                  context,
                  fadePageRoute(const SetupFaceIDScreen()),
                ),
              ),

              _buildSectionTitle("Account"),
              _menuItem(icon: Icons.person_outline, title: "Personal Details"),
              _menuItem(icon: Icons.credit_card, title: "Bank & Payments"),
              _menuItem(icon: Icons.help_outline, title: "Help & Support"),
              _menuItem(icon: Icons.info_outline, title: "About App"),

              const SizedBox(height: 40),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showLogoutDialog,
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout", style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SharedBottomNav(
        currentIndex: 4,
        parentContext: context,
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(left: 12, bottom: 8, top: 20),
    child: Text(
      title,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
  );

  Widget _menuItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF6C63FF), size: 26),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: const Color(0xFF111419),
      onTap: onTap ?? () => debugPrint("$title tapped"),
    );
  }
}
