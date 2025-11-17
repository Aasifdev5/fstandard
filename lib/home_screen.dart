// lib/home_screen.dart
import 'package:flutter/material.dart';
import 'utils.dart';
import 'profile_screen.dart';
import 'portfolio_screen.dart';
import 'widgets/shared_bottom_nav.dart'; // ← NEW: Shared navigation

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
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
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset("assets/wel.png", width: 24, height: 24),
        ),
        title: const Text(
          "StockWave",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fade,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Portfolio value",
                style: TextStyle(fontSize: 16, color: Color(0xFF8A8A8A)),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    "\$13,240.11",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  _miniChart(isUp: true),
                ],
              ),
              const SizedBox(height: 20),

              // Index Cards
              Row(
                children: [
                  Expanded(
                    child: _indexCard(
                      "S&P 500",
                      "Standard & Poor's",
                      "+49.50%",
                      true,
                      prim,
                      cardBg,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _indexCard(
                      "DOW",
                      "Dow Jones",
                      "+1",
                      true,
                      prim,
                      cardBg,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Wishlist
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Wishlist",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, size: 28),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _wishlistItem(
                      "AMZN",
                      "Amazon, Inc.",
                      "-0.05%",
                      false,
                      "assets/ama.png",
                      cardBg,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _wishlistItem(
                      "ADBE",
                      "Adobe, Inc.",
                      "+0.32%",
                      true,
                      "assets/ado.png",
                      cardBg,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Stocks
              const Text(
                "Stocks",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _stockItem(
                "NFLX",
                "Netflix, Inc.",
                "\$88.91",
                "+1.29%",
                true,
                "assets/n.png",
                cardBg,
              ),
              const SizedBox(height: 12),
              _stockItem(
                "AAPL",
                "Apple, Inc.",
                "\$142.65",
                "+0.81%",
                true,
                "assets/a.png",
                cardBg,
              ),
              const SizedBox(height: 12),
              _stockItem(
                "FB",
                "Facebook, Inc.",
                "\$343.01",
                "+1.07%",
                true,
                "assets/fb.png",
                cardBg,
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // REPLACED with SharedBottomNav → Perfect navigation (no duplicates!)
      bottomNavigationBar: SharedBottomNav(
        currentIndex: 0,
        parentContext: context,
      ),
    );
  }

  // ───── ALL YOUR ORIGINAL WIDGETS BELOW (UNCHANGED) ─────

  Widget _miniChart({required bool isUp}) {
    return SizedBox(
      width: 80,
      height: 32,
      child: CustomPaint(
        painter: _LineChartPainter(
          data: [1, 2, 3, 5, 4, 6, 7],
          color: isUp ? const Color(0xFF34C759) : Colors.red,
        ),
      ),
    );
  }

  Widget _indexCard(
    String title,
    String subtitle,
    String change,
    bool isUp,
    Color prim,
    Color bg,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Color(0xFF8A8A8A)),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                change,
                style: TextStyle(
                  color: isUp ? const Color(0xFF34C759) : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Icon(
                isUp ? Icons.trending_up : Icons.trending_down,
                size: 16,
                color: isUp ? const Color(0xFF34C759) : Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _wishlistItem(
    String symbol,
    String name,
    String change,
    bool isUp,
    String logo,
    Color bg,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 16, backgroundImage: AssetImage(logo)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  symbol,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8A8A8A),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                change,
                style: TextStyle(
                  color: isUp ? const Color(0xFF34C759) : Colors.red,
                  fontSize: 13,
                ),
              ),
              _miniChart(isUp: isUp),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stockItem(
    String symbol,
    String name,
    String price,
    String change,
    bool isUp,
    String logo,
    Color bg,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 20, backgroundImage: AssetImage(logo)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  symbol,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8A8A8A),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(
                change,
                style: TextStyle(
                  color: isUp ? const Color(0xFF34C759) : Colors.red,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          _miniChart(isUp: isUp),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  _LineChartPainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final stepX = size.width / (data.length - 1);
    path.moveTo(0, size.height - data[0] * size.height / 7);

    for (int i = 1; i < data.length; i++) {
      path.lineTo(i * stepX, size.height - data[i] * size.height / 7);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
