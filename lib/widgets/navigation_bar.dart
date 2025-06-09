import 'package:flutter/material.dart';
import 'package:rinemaa/pages/home_page.dart';
import 'package:rinemaa/pages/film_page.dart';
import 'package:rinemaa/pages/profile_page.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({Key? key, required this.currentIndex}) : super(key: key);

  void _navigateTo(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget targetPage;
    switch (index) {
      case 0:
        targetPage = HomePage();
        break;
      case 1:
        targetPage = FilmPage();
        break;
      case 2:
        targetPage = ProfilePage();
        break;
      default:
        targetPage = HomePage();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => targetPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      currentIndex: currentIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      onTap: (index) => _navigateTo(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.movie_filter),
          label: 'Film',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
