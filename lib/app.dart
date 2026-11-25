import 'package:flutter/material.dart';

import 'widgets/auth_gate.dart';

class InventoryApp extends StatelessWidget {
  const InventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Inventory',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00A88F)),
        scaffoldBackgroundColor: const Color(0xFFE9E9E9),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}
