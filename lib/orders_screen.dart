// lib/screens/orders_screen.dart
import 'package:flutter/material.dart';
import '../widgets/shared_bottom_nav.dart';
import '../utils.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1115),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1115),
        elevation: 0,
        title: const Text(
          "Orders",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF6C63FF),
          indicatorWeight: 3,
          labelColor: const Color(0xFF6C63FF),
          unselectedLabelColor: Colors.grey[400],
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: "Open"),
            Tab(text: "Executed"),
            Tab(text: "Cancelled"),
            Tab(text: "Rejected"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          OpenOrdersTab(),
          ExecutedOrdersTab(),
          CancelledOrdersTab(),
          RejectedOrdersTab(),
        ],
      ),
      bottomNavigationBar: SharedBottomNav(
        currentIndex: 3,
        parentContext: context,
      ),
    );
  }
}

// ======================== TAB CONTENTS ========================

class OpenOrdersTab extends StatelessWidget {
  const OpenOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        OrderCard(
          symbol: "RELIANCE",
          type: "BUY",
          qty: 25,
          price: "₹2,987.45",
          status: "OPEN",
          time: "10:32 AM",
          isBuy: true,
        ),
        OrderCard(
          symbol: "HDFCBANK",
          type: "SELL",
          qty: 50,
          price: "₹1,678.90",
          status: "OPEN",
          time: "10:15 AM",
          isBuy: false,
        ),
        OrderCard(
          symbol: "TCS",
          type: "BUY",
          qty: 10,
          price: "₹4,123.00",
          status: "OPEN",
          time: "09:58 AM",
          isBuy: true,
        ),
      ],
    );
  }
}

class ExecutedOrdersTab extends StatelessWidget {
  const ExecutedOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        OrderCard(
          symbol: "INFY",
          type: "BUY",
          qty: 30,
          price: "₹1,876.30",
          status: "EXECUTED",
          time: "10:28 AM",
          executedPrice: "₹1,876.30",
          isBuy: true,
        ),
        OrderCard(
          symbol: "ADANIPORTS",
          type: "SELL",
          qty: 40,
          price: "₹1,487.20",
          status: "EXECUTED",
          time: "10:05 AM",
          executedPrice: "₹1,487.20",
          isBuy: false,
        ),
      ],
    );
  }
}

class CancelledOrdersTab extends StatelessWidget {
  const CancelledOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        OrderCard(
          symbol: "WIPRO",
          type: "BUY",
          qty: 100,
          price: "₹542.80",
          status: "CANCELLED",
          time: "09:45 AM",
          isBuy: true,
        ),
      ],
    );
  }
}

class RejectedOrdersTab extends StatelessWidget {
  const RejectedOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "No rejected orders",
        style: TextStyle(color: Colors.grey[400], fontSize: 16),
      ),
    );
  }
}

// ======================== REUSABLE ORDER CARD ========================

class OrderCard extends StatelessWidget {
  final String symbol;
  final String type;
  final int qty;
  final String price;
  final String status;
  final String time;
  final String? executedPrice;
  final bool isBuy;

  const OrderCard({
    super.key,
    required this.symbol,
    required this.type,
    required this.qty,
    required this.price,
    required this.status,
    required this.time,
    this.executedPrice,
    required this.isBuy,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor = status == "OPEN"
        ? const Color(0xFF6C63FF)
        : status == "EXECUTED"
        ? const Color(0xFF00D09C)
        : status == "CANCELLED"
        ? Colors.orange
        : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111419),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3)),
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isBuy
                      ? const Color(0xFF00D09C).withOpacity(0.2)
                      : const Color(0xFFFF3B30).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  type,
                  style: TextStyle(
                    color: isBuy
                        ? const Color(0xFF00D09C)
                        : const Color(0xFFFF3B30),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "$qty × $price",
                style: const TextStyle(color: Colors.white70),
              ),
              const Spacer(),
              Text(
                time,
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ),
          if (executedPrice != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  "Executed at: ",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                Text(
                  executedPrice!,
                  style: const TextStyle(
                    color: Color(0xFF00D09C),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
          if (status == "OPEN") ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Order cancelled")),
                    );
                  },
                  child: const Text(
                    "CANCEL",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
