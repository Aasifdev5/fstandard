// lib/screens/charts_screen.dart
import 'package:flutter/material.dart';
import '../widgets/shared_bottom_nav.dart';
import 'stock_detail_screen.dart';
import '../utils.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  final List<Map<String, dynamic>> trendingStocks = [
    {"symbol": "RELIANCE", "ltp": 2987.45, "changePercent": 1.26, "isUp": true},
    {"symbol": "TATASTEEL", "ltp": 178.30, "changePercent": 4.82, "isUp": true},
    {
      "symbol": "ADANIPORTS",
      "ltp": 1487.20,
      "changePercent": -2.15,
      "isUp": false,
    },
    {"symbol": "HDFCBANK", "ltp": 1678.90, "changePercent": 0.74, "isUp": true},
    {"symbol": "INFY", "ltp": 1876.30, "changePercent": 0.99, "isUp": true},
    {
      "symbol": "NIFTY 50",
      "ltp": 26013.45,
      "changePercent": 0.40,
      "isUp": true,
    },
  ];

  final List<String> chartTypes = [
    "Line",
    "Candle",
    "Bar",
    "Heikin Ashi",
    "Renko",
  ];
  String selectedChartType = "Candle";
  String selectedTimeframe = "1D";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1115),
        elevation: 0,
        title: const Text(
          "Charts",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white70),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Top Gainers
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF111419),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Top Gainers Today",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 90,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: trendingStocks.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final stock = trendingStocks[index];
                      final ltp = stock["ltp"] as double;
                      final changePercent = stock["changePercent"] as double;
                      final isUp = stock["isUp"] as bool;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            fadePageRoute(
                              StockDetailScreen(
                                symbol: stock["symbol"],
                                exchange:
                                    stock["symbol"].toString().contains("NIFTY")
                                    ? "INDEX"
                                    : "NSE",
                                currentPrice: ltp,
                                change: ltp * changePercent / 100,
                                changePercent: changePercent,
                                isUp: isUp,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 120,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1F24),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isUp
                                  ? const Color(0xFF00D09C).withOpacity(0.3)
                                  : const Color(0xFFFF3B30).withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stock["symbol"],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              Text(
                                "₹${ltp.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    isUp
                                        ? Icons.trending_up
                                        : Icons.trending_down,
                                    color: isUp
                                        ? const Color(0xFF00D09C)
                                        : const Color(0xFFFF3B30),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${isUp ? '+' : ''}${changePercent.toStringAsFixed(2)}%",
                                    style: TextStyle(
                                      color: isUp
                                          ? const Color(0xFF00D09C)
                                          : const Color(0xFFFF3B30),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Main Chart Area
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF111419),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  CustomPaint(
                    painter: _MockChartPainter(),
                    size: Size.infinite,
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "NIFTY 50 • $selectedTimeframe",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            [
                              "1m",
                              "5m",
                              "15m",
                              "30m",
                              "1h",
                              "1D",
                              "1W",
                              "1M",
                            ].map((tf) {
                              final active = selectedTimeframe == tf;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => selectedTimeframe = tf),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: active
                                          ? const Color(0xFF6C63FF)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: active
                                            ? const Color(0xFF6C63FF)
                                            : Colors.grey.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Text(
                                      tf,
                                      style: TextStyle(
                                        color: active
                                            ? Colors.white
                                            : Colors.grey[400],
                                        fontWeight: active
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Chart Type Selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: chartTypes.map((type) {
                  final active = selectedChartType == type;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      label: Text(type),
                      selected: active,
                      onSelected: (_) =>
                          setState(() => selectedChartType = type),
                      selectedColor: const Color(0xFF6C63FF),
                      backgroundColor: const Color(0xFF1A1F24),
                      labelStyle: TextStyle(
                        color: active ? Colors.white : Colors.grey[400],
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: SharedBottomNav(
        currentIndex: 3,
        parentContext: context,
      ),
    );
  }
}

class _MockChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintGreen = Paint()..color = const Color(0xFF00D09C);
    final paintRed = Paint()..color = const Color(0xFFFF3B30);
    final linePaint = Paint()
      ..color = const Color(0xFF6C63FF)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    // Grid
    final gridPaint = Paint()..color = Colors.white.withOpacity(0.05);
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    // Trend line
    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.6,
      size.width * 0.7,
      size.height * 0.4,
    );
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.35,
      size.width,
      size.height * 0.3,
    );
    canvas.drawPath(path, linePaint);

    // Candlesticks
    double x = 40.0;
    for (int i = 0; i < 20; i++) {
      final h = 30.0 + (i % 5) * 10.0;
      final y = size.height * (0.3 + (i % 3) * 0.1);
      final isUp = i % 3 != 1;

      canvas.drawRect(
        Rect.fromLTWH(x, y, 12.0, h),
        isUp ? paintGreen : paintRed,
      );
      canvas.drawLine(
        Offset(x + 6, y - 15),
        Offset(x + 6, y + h + 15),
        Paint()
          ..color = isUp ? paintGreen.color : paintRed.color
          ..strokeWidth = 1.2,
      );
      x += 25.0;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
