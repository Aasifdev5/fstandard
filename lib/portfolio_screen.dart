import 'package:flutter/material.dart';
import 'utils.dart';
import 'widgets/shared_bottom_nav.dart'; // ← NEW: Shared navigation
import 'stock_detail_screen.dart'; // ← For stock tap navigation

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});
  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen>
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
          "Portfolio",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
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
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF34C759).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.trending_up,
                          size: 16,
                          color: Color(0xFF34C759),
                        ),
                        SizedBox(width: 4),
                        Text(
                          "+1.74%",
                          style: TextStyle(
                            color: Color(0xFF34C759),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Gain / Loss
              Row(
                children: [
                  Expanded(
                    child: _gainLossCard("Gain", "\$234.11", true, cardBg),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _gainLossCard("Loss", "\$34.11", false, cardBg),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Chart
              Container(
                height: 240,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    _LineChartWithTooltip(),
                    // ... your Y-axis labels and X-axis labels (unchanged)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text(
                            "\$40k",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8A8A8A),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "\$30k",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8A8A8A),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "\$20k",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8A8A8A),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "\$10k",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8A8A8A),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "\$0k",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8A8A8A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Mon",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8A8A8A),
                            ),
                          ),
                          Text(
                            "Sun",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8A8A8A),
                            ),
                          ),
                          Text(
                            "Tue",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8A8A8A),
                            ),
                          ),
                          Text(
                            "Wed",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8A8A8A),
                            ),
                          ),
                          Text(
                            "Thu",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8A8A8A),
                            ),
                          ),
                          Text(
                            "Fri",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8A8A8A),
                            ),
                          ),
                          Text(
                            "Sat",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8A8A8A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // PERFECT NAVIGATION – Same as HomeScreen
      bottomNavigationBar: SharedBottomNav(
        currentIndex: 1, // Portfolio tab active
        parentContext: context,
      ),
    );
  }

  // ───── ALL YOUR ORIGINAL WIDGETS (UNCHANGED) ─────

  Widget _gainLossCard(String label, String value, bool isGain, Color bg) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isGain ? Icons.trending_up : Icons.trending_down,
            size: 20,
            color: isGain ? const Color(0xFF34C759) : Colors.red,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Color(0xFF8A8A8A)),
              ),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () =>
            Navigator.push(context, fadePageRoute(const StockDetailScreen())),
        child: Container(
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
                  Text(
                    price,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
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
        ),
      ),
    );
  }

  Widget _miniChart({required bool isUp}) {
    return SizedBox(
      width: 60,
      height: 32,
      child: CustomPaint(
        painter: _LineChartPainter(
          data: isUp ? [2, 3, 4, 5, 6] : [5, 4, 3, 2, 1],
          color: isUp ? const Color(0xFF34C759) : Colors.red,
        ),
      ),
    );
  }
}

// ───── CHART CLASSES (UNCHANGED) ─────
class _LineChartWithTooltip extends StatefulWidget {
  @override
  State<_LineChartWithTooltip> createState() => _LineChartWithTooltipState();
}

class _LineChartWithTooltipState extends State<_LineChartWithTooltip> {
  Offset? _tapPosition;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (d) => setState(() => _tapPosition = d.localPosition),
      onTapUp: (_) => setState(() => _tapPosition = null),
      child: CustomPaint(
        size: const Size(double.infinity, 180),
        painter: _PortfolioChartPainter(tapPosition: _tapPosition),
      ),
    );
  }
}

class _PortfolioChartPainter extends CustomPainter {
  final Offset? tapPosition;
  _PortfolioChartPainter({this.tapPosition});

  final List<double> data = [10, 15, 12, 18, 16, 25, 29];
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF355CFF)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path();
    final stepX = size.width / (data.length - 1);
    final maxY = 40.0;
    final scaleY = size.height / maxY;
    path.moveTo(0, size.height - data[0] * scaleY);
    for (int i = 1; i < data.length; i++) {
      path.lineTo(i * stepX, size.height - data[i] * scaleY);
    }
    canvas.drawPath(path, paint);

    if (tapPosition != null) {
      final index = (tapPosition!.dx / stepX).round().clamp(0, data.length - 1);
      final value = data[index];
      final x = index * stepX;
      final y = size.height - value * scaleY;
      canvas.drawCircle(
        Offset(x, y),
        5,
        Paint()..color = const Color(0xFF355CFF),
      );

      final textPainter = TextPainter(textDirection: TextDirection.ltr);
      textPainter.text = TextSpan(
        text: "\$${value.toInt()},140",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      );
      textPainter.layout();
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x - 30, y - 40, 60, 24),
          const Radius.circular(8),
        ),
        Paint()..color = const Color(0xFF1E1E1E),
      );
      textPainter.paint(canvas, Offset(x - 25, y - 34));
    }
  }

  @override
  bool shouldRepaint(_) => true;
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
    path.moveTo(0, size.height * 0.8);
    for (int i = 1; i < data.length; i++) {
      path.lineTo(i * stepX, size.height - (data[i] * size.height / 7));
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
