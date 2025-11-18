// lib/screens/positions_screen.dart
import 'package:flutter/material.dart';
import '../widgets/shared_bottom_nav.dart';

class PositionsScreen extends StatelessWidget {
  const PositionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1115),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1115),
        elevation: 0,
        title: const Text(
          "Positions",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Exit All clicked")));
            },
            child: const Text(
              "Exit All",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Today's P&L Summary
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF111419),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF00D09C).withOpacity(0.3),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today's P&L",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "₹8,450.00",
                      style: TextStyle(
                        color: Color(0xFF00D09C),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "+12.34%",
                      style: TextStyle(
                        color: Color(0xFF00D09C),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text("5 Positions", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),

          // Positions List — REMOVED 'const' from ListView children
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                PositionCard(
                  symbol: "RELIANCE",
                  qty: 25,
                  avgPrice: 2987.45,
                  ltp: 3025.00,
                  pnl: 937.50,
                  pnlPercent: 1.26,
                  isUp: true,
                ),
                PositionCard(
                  symbol: "HDFCBANK",
                  qty: 50,
                  avgPrice: 1678.90,
                  ltp: 1692.50,
                  pnl: 680.00,
                  pnlPercent: 0.81,
                  isUp: true,
                ),
                PositionCard(
                  symbol: "ADANIPORTS",
                  qty: 30,
                  avgPrice: 1520.00,
                  ltp: 1487.20,
                  pnl: -984.00,
                  pnlPercent: -2.16,
                  isUp: false,
                ),
                PositionCard(
                  symbol: "NIFTY2411225000CE",
                  qty: 75,
                  avgPrice: 145.50,
                  ltp: 198.00,
                  pnl: 3937.50,
                  pnlPercent: 36.08,
                  isUp: true,
                  isOption: true,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SharedBottomNav(
        currentIndex: 2,
        parentContext: context,
      ),
    );
  }
}

// ────────────────────── POSITION CARD (unchanged & perfect) ──────────────────────
class PositionCard extends StatelessWidget {
  final String symbol;
  final int qty;
  final double avgPrice;
  final double ltp;
  final double pnl;
  final double pnlPercent;
  final bool isUp;
  final bool isOption;

  const PositionCard({
    super.key,
    required this.symbol,
    required this.qty,
    required this.avgPrice,
    required this.ltp,
    required this.pnl,
    required this.pnlPercent,
    required this.isUp,
    this.isOption = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111419),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  symbol,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              if (isOption)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    "OPTION",
                    style: TextStyle(color: Colors.purple, fontSize: 10),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "LTP",
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                  Text(
                    "₹${ltp.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Avg",
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                  Text(
                    "₹${avgPrice.toStringAsFixed(2)}",
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Qty",
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                  Text("×$qty", style: const TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                isUp ? Icons.trending_up : Icons.trending_down,
                color: isUp ? const Color(0xFF00D09C) : const Color(0xFFFF3B30),
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                "${isUp ? '+' : ''}₹${pnl.abs().toStringAsFixed(2)}",
                style: TextStyle(
                  color: isUp
                      ? const Color(0xFF00D09C)
                      : const Color(0xFFFF3B30),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "(${isUp ? '+' : ''}${pnlPercent.toStringAsFixed(2)}%)",
                style: TextStyle(
                  color: isUp
                      ? const Color(0xFF00D09C)
                      : const Color(0xFFFF3B30),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Exit order placed")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF3B30),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "EXIT",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
