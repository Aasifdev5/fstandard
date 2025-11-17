import 'package:flutter/material.dart';

const Color primary = Color(0xFF355CFF);

PageRouteBuilder fadePageRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, a, __, child) =>
        FadeTransition(opacity: a, child: child),
  );
}
