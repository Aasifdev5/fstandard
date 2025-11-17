import 'package:flutter/material.dart';
import 'utils.dart';
import 'confirm_order_screen.dart';

class StockDetailScreen extends StatefulWidget {
  const StockDetailScreen({super.key});
  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _fade;
  int _selectedTab = 0; // 0 = Summary, 1 = Details
  String _selectedRange = "1M";

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
          "Detail Stock",
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
              // Stock Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: const AssetImage("assets/n.png"),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "NFLX",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Netflix, Inc.",
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF8A8A8A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Price & Change
              Row(
                children: [
                  const Text(
                    "\$43.08",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  _changeBadge("+189 (+4.59%)", "Past Month", true),
                  const SizedBox(width: 12),
                  _changeBadge("+0.13 (+0.30%)", "YTD", true),
                ],
              ),
              const SizedBox(height: 24),

              // Chart
              Container(
                height: 260,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _StockChartWithTooltip(selectedRange: _selectedRange),
              ),
              const SizedBox(height: 16),

              // Time Range
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ["1D", "1W", "1M", "1Y", "5Y", "ALL"].map((range) {
                  final isActive = _selectedRange == range;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedRange = range),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isActive ? prim : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        range,
                        style: TextStyle(
                          color: isActive
                              ? Colors.white
                              : const Color(0xFF8A8A8A),
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Tabs
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _tabButton("Summary", 0, prim, cardBg),
                    _tabButton("Details", 1, prim, cardBg),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Financials
              const Text(
                "Financials",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              // Placeholder for real data
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Financial data goes here",
                  style: TextStyle(color: Color(0xFF8A8A8A)),
                ),
              ),
              const SizedBox(height: 32),

              // Buy Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      fadePageRoute(const ConfirmOrderScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: prim,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Buy stocks",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _changeBadge(String change, String label, bool isUp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          change,
          style: TextStyle(
            color: isUp ? const Color(0xFF34C759) : Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF8A8A8A)),
        ),
      ],
    );
  }

  Widget _tabButton(String text, int index, Color prim, Color bg) {
    final isActive = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : bg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? prim : const Color(0xFF8A8A8A),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// Interactive Chart with Tooltip
class _StockChartWithTooltip extends StatefulWidget {
  final String selectedRange;
  const _StockChartWithTooltip({required this.selectedRange});
  @override
  State<_StockChartWithTooltip> createState() => _StockChartWithTooltipState();
}

class _StockChartWithTooltipState extends State<_StockChartWithTooltip> {
  Offset? _tapPosition;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (d) => setState(() => _tapPosition = d.localPosition),
      onTapUp: (_) => setState(() => _tapPosition = null),
      child: CustomPaint(
        size: const Size(double.infinity, 180),
        painter: _StockChartPainter(
          tapPosition: _tapPosition,
          range: widget.selectedRange,
        ),
      ),
    );
  }
}

class _StockChartPainter extends CustomPainter {
  final Offset? tapPosition;
  final String range;
  _StockChartPainter({this.tapPosition, required this.range});

  final Map<String, List<double>> data = {
    "1D": [42.5, 42.8, 43.0, 42.9, 43.1, 43.08],
    "1W": [41.0, 41.5, 42.0, 42.5, 43.0, 43.1, 43.08],
    "1M": [39.0, 40.0, 41.0, 42.0, 41.5, 43.0, 44.0, 43.5, 44.04, 43.8, 43.08],
    "1Y": List.generate(12, (i) => 35 + i * 0.8),
    "5Y": List.generate(60, (i) => 30 + i * 0.3),
    "ALL": List.generate(100, (i) => 25 + i * 0.2),
  };

  @override
  void paint(Canvas canvas, Size size) {
    final values = data[range] ?? data["1M"]!;
    final paint = Paint()
      ..color = const Color(0xFF355CFF)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final stepX = size.width / (values.length - 1);
    final maxY = values.reduce((a, b) => a > b ? a : b);
    final minY = values.reduce((a, b) => a < b ? a : b);
    final rangeY = maxY - minY;
    final scaleY = size.height / (rangeY == 0 ? 1 : rangeY);

    path.moveTo(0, size.height - (values[0] - minY) * scaleY);

    for (int i = 1; i < values.length; i++) {
      path.lineTo(i * stepX, size.height - (values[i] - minY) * scaleY);
    }

    canvas.drawPath(path, paint);

    // Tooltip
    if (tapPosition != null) {
      final index = (tapPosition!.dx / stepX).round().clamp(
        0,
        values.length - 1,
      );
      final value = values[index];
      final x = index * stepX;
      final y = size.height - (value - minY) * scaleY;

      final dotPaint = Paint()..color = const Color(0xFF355CFF);
      canvas.drawCircle(Offset(x, y), 5, dotPaint);

      final text = "\$ ${value.toStringAsFixed(2)}";
      final date = range == "1M" && index == 8 ? "Sep 27" : "";
      final textPainter = TextPainter(textDirection: TextDirection.ltr);
      textPainter.text = TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      );
      textPainter.layout();

      final rect = Rect.fromLTWH(x - 40, y - 50, 80, 32);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(12)),
        Paint()..color = const Color(0xFF1E1E1E),
      );

      if (date.isNotEmpty) {
        final datePainter = TextPainter(textDirection: TextDirection.ltr);
        datePainter.text = TextSpan(
          text: date,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        );
        datePainter.layout();
        datePainter.paint(canvas, Offset(x - datePainter.width / 2, y - 38));
      }

      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - 22));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}
