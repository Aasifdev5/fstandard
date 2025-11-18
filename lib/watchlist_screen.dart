// lib/screens/watchlist_screen.dart
import 'package:flutter/material.dart';
import '../widgets/shared_bottom_nav.dart';
import 'stock_detail_screen.dart';
import '../utils.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  final List<Map<String, dynamic>> watchlist = [
    {"symbol": "RELIANCE", "ltp": 2987.45, "changePercent": 1.26, "isUp": true},
    {"symbol": "TATASTEEL", "ltp": 178.30, "changePercent": 4.82, "isUp": true},
    {"symbol": "HDFCBANK", "ltp": 1678.90, "changePercent": 0.74, "isUp": true},
    {"symbol": "INFY", "ltp": 1876.30, "changePercent": 0.99, "isUp": true},
    {
      "symbol": "ADANIPORTS",
      "ltp": 1487.20,
      "changePercent": -2.15,
      "isUp": false,
    },
    {
      "symbol": "NIFTY 50",
      "ltp": 26013.45,
      "changePercent": 0.40,
      "isUp": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1115),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1115),
        elevation: 0,
        title: const Text(
          "Watchlist",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
      body: watchlist.isEmpty
          ? const Center(
              child: Text(
                "Your watchlist is empty",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: watchlist.length,
              itemBuilder: (context, index) {
                final item = watchlist[index];
                final ltp = item["ltp"] as double;
                final changePercent = item["changePercent"] as double;
                final isUp = item["isUp"] as bool;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      fadePageRoute(
                        StockDetailScreen(
                          symbol: item["symbol"],
                          exchange: item["symbol"].toString().contains("NIFTY")
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
                                item["symbol"],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "₹${ltp.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  isUp
                                      ? Icons.trending_up
                                      : Icons.trending_down,
                                  color: isUp
                                      ? const Color(0xFF00D09C)
                                      : const Color(0xFFFF3B30),
                                  size: 18,
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
                            const SizedBox(height: 4),
                            Text(
                              "₹${(ltp * changePercent / 100).abs().toStringAsFixed(2)}",
                              style: TextStyle(
                                color: isUp
                                    ? const Color(0xFF00D09C)
                                    : const Color(0xFFFF3B30),
                                fontSize: 12,
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
      bottomNavigationBar: SharedBottomNav(
        currentIndex: 2,
        parentContext: context,
      ),
    );
  }
}
