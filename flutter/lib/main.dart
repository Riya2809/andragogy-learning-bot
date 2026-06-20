import 'package:flutter/material.dart';
import 'services/app_theme.dart';
import 'screens/login_screen.dart';

void main() => runApp(const AndragogyApp());

class AndragogyApp extends StatelessWidget {
  const AndragogyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Andragogy Insight',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const LoginScreen(),
    );
  }
}
