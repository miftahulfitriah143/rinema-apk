import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const RinemaApp());
}

class RinemaApp extends StatelessWidget {
  const RinemaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
