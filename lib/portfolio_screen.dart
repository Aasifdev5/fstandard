// lib/screens/portfolio_screen.dart
import 'package:flutter/material.dart';
import '../widgets/shared_bottom_nav.dart';
import 'stock_detail_screen.dart';
import '../utils.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1115),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1115),
        elevation: 0,
        title: const Text(
          "Portfolio",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Total Portfolio Value",
              style: TextStyle(color: Colors.grey, fontSize: 14),
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
            Row(
              children: const [
                Icon(Icons.trending_up, color: Color(0xFF00D09C), size: 20),
                SizedBox(width: 8),
                Text(
                  "+₹24,567 (+1.89%)",
                  style: TextStyle(
                    color: Color(0xFF00D09C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            const Text(
              "Holdings",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _holdingCard(
              context,
              symbol: "NIFTY 50",
              qty: 75,
              avgPrice: 24850.0,
              ltp: 26013.45,
              isUp: true,
            ),
            _holdingCard(
              context,
              symbol: "RELIANCE",
              qty: 25,
              avgPrice: 2950.0,
              ltp: 2987.45,
              isUp: true,
            ),
            _holdingCard(
              context,
              symbol: "HDFCBANK",
              qty: 50,
              avgPrice: 1650.0,
              ltp: 1678.90,
              isUp: true,
            ),
            _holdingCard(
              context,
              symbol: "ADANIPORTS",
              qty: 30,
              avgPrice: 1520.0,
              ltp: 1487.20,
              isUp: false,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SharedBottomNav(
        currentIndex: 1,
        parentContext: context,
      ),
    );
  }

  Widget _holdingCard(
    BuildContext context, {
    required String symbol,
    required int qty,
    required double avgPrice,
    required double ltp,
    required bool isUp,
  }) {
    final totalInvested = avgPrice * qty;
    final currentValue = ltp * qty;
    final pnl = currentValue - totalInvested;
    final pnlPercent = (pnl / totalInvested) * 100;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          fadePageRoute(
            StockDetailScreen(
              symbol: symbol,
              exchange: symbol.contains("NIFTY") ? "INDEX" : "NSE",
              currentPrice: ltp,
              change: ltp - avgPrice,
              changePercent: (ltp - avgPrice) / avgPrice * 100,
              isUp: ltp >= avgPrice,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF111419),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    symbol,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Qty: $qty | Avg: ₹${avgPrice.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "₹${ltp.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${pnl >= 0 ? '+' : ''}₹${pnl.abs().toStringAsFixed(2)} (${pnlPercent >= 0 ? '+' : ''}${pnlPercent.toStringAsFixed(2)}%)",
                  style: TextStyle(
                    color: pnl >= 0
                        ? const Color(0xFF00D09C)
                        : const Color(0xFFFF3B30),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
