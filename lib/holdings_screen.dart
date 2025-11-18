// lib/screens/holdings_screen.dart
import 'package:flutter/material.dart';
import '../widgets/shared_bottom_nav.dart';

class HoldingsScreen extends StatelessWidget {
  const HoldingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1115),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1115),
        elevation: 0,
        title: const Text(
          "Holdings",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Portfolio Value Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF4E3CC9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total Portfolio Value",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                const Text(
                  "₹13,24,567.89",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.trending_up, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "+₹24,567 (+1.89%)",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Holdings List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                HoldingCard(
                  symbol: "RELIANCE",
                  qty: 25,
                  avg: 2950.00,
                  ltp: 2987.45,
                  invested: 73750,
                  current: 74686.25,
                ),
                HoldingCard(
                  symbol: "HDFCBANK",
                  qty: 50,
                  avg: 1650.00,
                  ltp: 1678.90,
                  invested: 82500,
                  current: 83945,
                ),
                HoldingCard(
                  symbol: "NIFTYBEES",
                  qty: 200,
                  avg: 248.50,
                  ltp: 260.13,
                  invested: 49700,
                  current: 52026,
                ),
                HoldingCard(
                  symbol: "TCS",
                  qty: 15,
                  avg: 4123.00,
                  ltp: 3987.00,
                  invested: 61845,
                  current: 59805,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SharedBottomNav(
        currentIndex: 1,
        parentContext: context,
      ),
    );
  }
}

class HoldingCard extends StatelessWidget {
  final String symbol;
  final int qty;
  final double avg;
  final double ltp;
  final double invested;
  final double current;

  const HoldingCard({
    super.key,
    required this.symbol,
    required this.qty,
    required this.avg,
    required this.ltp,
    required this.invested,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    final pnl = current - invested;
    final pnlPercent = (pnl / invested) * 100;
    final isUp = pnl >= 0;

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
              Text(
                symbol,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Text(
                "₹${ltp.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Qty: $qty  •  Avg: ₹${avg.toStringAsFixed(2)}",
            style: TextStyle(color: Colors.grey[400]),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
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
              Text(
                "Invested: ₹${invested.toStringAsFixed(0)}",
                style: TextStyle(color: Colors.grey[400]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
