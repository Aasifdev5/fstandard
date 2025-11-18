// lib/widgets/shared_bottom_nav.dart
import 'package:flutter/material.dart';
import '../home_screen.dart';
import '../holdings_screen.dart'; // ← Your long-term portfolio
import '../positions_screen.dart'; // ← Today's live P&L
import '../orders_screen.dart'; // ← Orders history
import '../profile_screen.dart'; // ← Profile
import '../utils.dart';

class SharedBottomNav extends StatelessWidget {
  final int currentIndex;
  final BuildContext parentContext;

  const SharedBottomNav({
    super.key,
    required this.currentIndex,
    required this.parentContext,
  });

  void _onTabTapped(int index) {
    if (index == currentIndex) return;

    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen = const HomeScreen();
        break;
      case 1:
        nextScreen = const HoldingsScreen(); // Long-term investments
        break;
      case 2:
        nextScreen = const PositionsScreen(); // Intraday + F&O live positions
        break;
      case 3:
        nextScreen = const OrdersScreen(); // Open/Executed/Cancelled orders
        break;
      case 4:
        nextScreen = const ProfileScreen();
        break;
      default:
        nextScreen = const HomeScreen();
    }

    Navigator.pushAndRemoveUntil(
      parentContext,
      fadePageRoute(nextScreen),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    const prim = Color(0xFF6C63FF);
    const bg = Color(0xFF0E1115);

    return Container(
      decoration: const BoxDecoration(
        color: bg,
        border: Border(top: BorderSide(color: Color(0xFF2A2A2A), width: 0.8)),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        selectedItemColor: prim,
        unselectedItemColor: Colors.grey[600],
        selectedFontSize: 12,
        unselectedFontSize: 11,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            activeIcon: Icon(Icons.pie_chart),
            label: "Holdings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            activeIcon: Icon(Icons.bar_chart_rounded),
            label: "Positions",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: "Orders",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
