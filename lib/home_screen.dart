// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../widgets/shared_bottom_nav.dart';
import 'profile_info_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _fade;

  int _selectedTab = 1; // 0: Stocks, 1: F&O, 2: Mutual Funds, 3: FD
  final List<String> categories = ['Stocks', 'F&O', 'Mutual Funds', 'FD'];

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
    const bg = Color(0xFF0E1115);
    const prim = Color(0xFF6C63FF);
    final textMuted = Colors.grey[400]!;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF0F1720),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Image.asset('assets/wel.png', width: 22, height: 22),
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // TODO: Navigate to SearchScreen()
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen()));
                },
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111418),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search,
                        color: Color(0xFF6B6F76),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Search Niftybees, ITBEES",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: textMuted, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileInfoScreen()),
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFF1A1F24),
                child: const Icon(Icons.person_outline, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _fade,
        child: Column(
          children: [
            // Category Tabs
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: List.generate(categories.length, (i) {
                  final active = i == _selectedTab;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = i),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            categories[i],
                            style: TextStyle(
                              color: active ? prim : Colors.white70,
                              fontWeight: active
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: active ? 40 : 0,
                            height: 4,
                            decoration: BoxDecoration(
                              color: prim,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            // Content
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _selectedTab == 0
                    ? const StocksTabContent()
                    : _selectedTab == 1
                    ? const FnoTabContent()
                    : _selectedTab == 2
                    ? const MutualFundsTabContent()
                    : const FdTabContent(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SharedBottomNav(
        currentIndex: 0,
        parentContext: context,
      ),
    );
  }
}

// ======================== TAB CONTENTS ========================

class StocksTabContent extends StatelessWidget {
  const StocksTabContent({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Popular Stocks',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _stockCard('RELIANCE', '₹2,987.45', '+45.20 (+1.53%)', true),
          _stockCard('TCS', '₹4,123.00', '-23.10 (-0.56%)', false),
          _stockCard('HDFCBANK', '₹1,678.90', '+34.50 (+2.10%)', true),
          const SizedBox(height: 20),
          const Text(
            'Gainers & Losers',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 12),
          _gainerLoserCard('ADANIENT', '+8.2%', true),
          _gainerLoserCard('WIPRO', '-5.1%', false),
        ],
      ),
    );
  }
}

class FnoTabContent extends StatelessWidget {
  const FnoTabContent({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Markets Today',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: [
                  Text(
                    'View all',
                    style: TextStyle(
                      color: Color(0xFF6C63FF),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Color(0xFF6C63FF),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF111419),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _indexCard('SENSEX', '84,950.95', '+388.17 (+0.46%)', true),
                  const SizedBox(width: 12),
                  _indexCard(
                    'BANKNIFTY',
                    '58,962.70',
                    '+445.15 (+0.76%)',
                    true,
                  ),
                  const SizedBox(width: 12),
                  _indexCard('NIFTY', '25,911.95', '+104.00 (+0.40%)', true),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top Commodities',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF16302E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'LIVE',
                  style: TextStyle(color: Colors.greenAccent, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.05,
            children: const [
              CommodityCard(
                title: 'Crude Oil',
                price: '₹5,326.00',
                change: '-₹16.00 (-0.30%)',
                red: true,
              ),
              CommodityCard(
                title: 'Natural Gas',
                price: '₹396.10',
                change: '-₹4.30 (-1.07%)',
                red: true,
              ),
              CommodityCard(
                title: 'Gold',
                price: '₹1,23,130.00',
                change: '-₹431.00 (-0.35%)',
                red: true,
              ),
              CommodityCard(
                title: 'Silver',
                price: '₹1,55,681.00',
                change: '-₹337.00 (-0.22%)',
                red: true,
              ),
            ],
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class MutualFundsTabContent extends StatelessWidget {
  const MutualFundsTabContent({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _fundCard('SBI Small Cap Fund', '₹182.45', '+2.1%', true),
          _fundCard('HDFC Mid-Cap Opportunities', '₹156.78', '+1.8%', true),
          _fundCard('Axis Bluechip Fund', '₹58.23', '-0.4%', false),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF111419),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Start SIP from ₹500/month',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class FdTabContent extends StatelessWidget {
  const FdTabContent({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _fdCard('Bajaj Finance FD', '8.6%', 'AAA Rated'),
          _fdCard('Shriram Finance', '8.4%', 'AA+ Rated'),
          _fdCard('Mahindra Finance', '8.1%', 'AA Rated'),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF111419),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  'Safe & Secure',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'FDs up to ₹5 lakh insured by DICGC',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ======================== REUSABLE WIDGETS (FULLY WRITTEN) ========================

Widget _indexCard(String title, String value, String change, bool up) {
  return Container(
    width: 220,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFF0F1418),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF101216),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Expiry Thu',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: TextStyle(
            color: up ? const Color(0xFF34C759) : Colors.redAccent,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(change, style: const TextStyle(color: Colors.white70)),
      ],
    ),
  );
}

Widget _stockCard(String name, String price, String change, bool up) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF0F1418),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              price,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              change,
              style: TextStyle(color: up ? Colors.green : Colors.red),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _gainerLoserCard(String name, String change, bool up) {
  return ListTile(
    title: Text(name, style: const TextStyle(color: Colors.white)),
    trailing: Text(
      change,
      style: TextStyle(
        color: up ? Colors.green : Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget _fundCard(String name, String nav, String change, bool up) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF0F1418),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(nav, style: const TextStyle(color: Colors.white)),
            Text(
              change,
              style: TextStyle(color: up ? Colors.green : Colors.red),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _fdCard(String name, String rate, String rating) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF0F1418),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              rate,
              style: const TextStyle(
                color: Color(0xFF6C63FF),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(rating, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    ),
  );
}

class CommodityCard extends StatelessWidget {
  final String title;
  final String price;
  final String change;
  final bool red;
  const CommodityCard({
    super.key,
    required this.title,
    required this.price,
    required this.change,
    this.red = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1418),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF111418),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.all_inbox,
                  color: Colors.white70,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF0B0D0F),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Options Expiry Today',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            price,
            style: TextStyle(
              color: red ? Colors.redAccent : Colors.greenAccent,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(change, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
