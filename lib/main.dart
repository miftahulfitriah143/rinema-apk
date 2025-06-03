import 'package:flutter/material.dart';
import 'package:rinemaa/pages/film_page.dart';
import 'package:rinemaa/pages/home_page.dart';
import 'package:rinemaa/pages/profile_page.dart';

void main() => runApp(RinemaApp());

class RinemaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(), // default-nya langsung ke halaman Home
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
    );
  }
}
