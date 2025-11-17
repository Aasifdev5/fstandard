import 'package:flutter/material.dart';
import 'utils.dart';

class ConfirmOrderScreen extends StatefulWidget {
  const ConfirmOrderScreen({super.key});
  @override
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _fade;
  int _paymentMethod = 0; // 0 = Debit Card, 1 = Apple Pay

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
          "Confirm Order",
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
              const SizedBox(height: 16),

              // Stock Card
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
                    const Text(
                      "\$88.91",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Order Details
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _detailRow("Funding source", "Stockup"),
                    const Divider(height: 24),
                    _detailRow("Approx share price", "\$14.65"),
                    const Divider(height: 24),
                    _detailRow("Approx shares", "3.00"),
                    const Divider(height: 24),
                    _detailRow("Fee", "\$2.10"),
                    const Divider(height: 24),
                    _detailRow("Total", "\$41.65", isTotal: true),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Payment Method
              const Text(
                "Payment method",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              _paymentOption(
                index: 0,
                icon: Icons.credit_card,
                title: "Debit Card",
                subtitle: "Deposit & invest right from your debit card",
                isSelected: _paymentMethod == 0,
                onTap: () => setState(() => _paymentMethod = 0),
              ),
              const SizedBox(height: 12),
              _paymentOption(
                index: 1,
                icon: Icons.apple,
                title: "Apple Pay",
                subtitle: "Connect your Apple Pay account",
                isSelected: _paymentMethod == 1,
                onTap: () => setState(() => _paymentMethod = 1),
              ),
              const SizedBox(height: 32),

              // Confirm Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Confirm order API
                    debugPrint("Order confirmed: NFLX x3.00");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: prim,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Confirm order",
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

  Widget _detailRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF8A8A8A))),
        Text(
          value,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            fontSize: isTotal ? 18 : 16,
          ),
        ),
      ],
    );
  }

  Widget _paymentOption({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final prim = theme.colorScheme.primary;
    final cardBg = theme.brightness == Brightness.dark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF8F9FA);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? prim : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? prim : const Color(0xFF8A8A8A),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8A8A8A),
                    ),
                  ),
                ],
              ),
            ),
            Radio<int>(
              value: index,
              groupValue: _paymentMethod,
              onChanged: (_) => onTap(),
              activeColor: prim,
            ),
          ],
        ),
      ),
    );
  }
}
