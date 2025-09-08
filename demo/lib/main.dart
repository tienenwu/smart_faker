import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'core/app_theme.dart';

void main() {
  runApp(const SmartFakerDemoApp());
}

class SmartFakerDemoApp extends StatelessWidget {
  const SmartFakerDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartFaker Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
