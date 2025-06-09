import 'package:flutter/material.dart';
import 'package:rinemaa/widgets/navigation_bar.dart';
import 'package:rinemaa/widgets/header_section.dart';  // Import HeaderSection
import 'package:rinemaa/pages/register_page.dart'; // Import RegisterPage
import 'package:rinemaa/pages/login_page.dart'; // Import LoginPage

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigasi ke halaman lain ditangani di BottomNavBar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // Hapus AppBar
      body: SafeArea(
        child: Column(
          children: [
            const HeaderSection(), // Pasang HeaderSection sebagai pengganti AppBar
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      label: "Login",
                      onPressed: () {
                        // Navigasi ke halaman LoginPage saat tombol ditekan
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      label: "Register",
                      onPressed: () {
                        // Navigasi ke halaman RegisterPage saat tombol ditekan
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[850],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
