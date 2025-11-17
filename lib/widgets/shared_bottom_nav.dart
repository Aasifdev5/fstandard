import 'package:flutter/material.dart';
import '../home_screen.dart';
import '../portfolio_screen.dart';
import '../profile_screen.dart';
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
        nextScreen = const PortfolioScreen();
        break;
      case 2:
        nextScreen = const Scaffold(
          body: Center(
            child: Text("Add Stocks", style: TextStyle(fontSize: 24)),
          ),
        );
        break;
      case 3:
        nextScreen = const Scaffold(
          body: Center(child: Text("Charts", style: TextStyle(fontSize: 24))),
        );
        break;
      case 4:
        nextScreen = const ProfileScreen();
        break;
      default:
        nextScreen = const HomeScreen();
    }

    Navigator.push(parentContext, fadePageRoute(nextScreen));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final prim = theme.colorScheme.primary;
    final inactive = theme.brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 0.5),
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.scaffoldBackgroundColor,
        selectedItemColor: prim,
        unselectedItemColor: inactive,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ""),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: "",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
        ],
      ),
    );
  }
}
