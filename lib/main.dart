import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'utils.dart';

void main() => runApp(const StocklineApp());

class StocklineApp extends StatefulWidget {
  const StocklineApp({super.key});
  @override
  State<StocklineApp> createState() => _StocklineAppState();
}

class _StocklineAppState extends State<StocklineApp> {
  ThemeMode _mode = ThemeMode.light;
  void _toggle() => setState(
    () => _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stockline',
      theme: _light,
      darkTheme: _dark,
      themeMode: _mode,
      home: const SplashScreen(),
      builder: (c, child) => ThemeSwitcher(toggle: _toggle, child: child!),
    );
  }
}

class ThemeSwitcher extends InheritedWidget {
  final VoidCallback toggle;
  const ThemeSwitcher({required this.toggle, required super.child, super.key});
  static ThemeSwitcher? of(BuildContext ctx) =>
      ctx.dependOnInheritedWidgetOfExactType<ThemeSwitcher>();
  @override
  bool updateShouldNotify(_) => false;
}

final ThemeData _light = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: Colors.white,
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF3F4F6),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
  ),
);

final ThemeData _dark = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF2A2A2A),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
  ),
);
