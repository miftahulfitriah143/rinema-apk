import 'package:flutter/material.dart';
import 'package:rinemaa/widgets/navigation_bar.dart'; // Import BottomNavBar
import 'package:rinemaa/widgets/header_section.dart';  // Import HeaderSection

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  int _selectedIndex = 2;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    // Implementasi logika registrasi di sini
    // Contoh: validasi input, panggil API registrasi, dll.
    print('Username: ${_usernameController.text}');
    print('Email: ${_emailController.text}');
    print('Password: ${_passwordController.text}');
    print('Confirm Password: ${_confirmPasswordController.text}');

    // Anda dapat menambahkan navigasi ke halaman lain setelah registrasi berhasil
    // Misalnya, kembali ke halaman login atau ke halaman beranda.
    // Navigator.pop(context); // Kembali ke halaman sebelumnya
  }

  @override
  Widget build(BuildContext context) {
    // Dapatkan lebar layar untuk Container Header
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black, // Background hitam
      body: SafeArea(
        child: Column(
          children: [
            // Area Header dengan Tombol Kembali dan Logo RINEMA di Tengah
            Container(
              height: 75, // Atur tinggi sesuai kebutuhan HeaderSection Anda
              width: screenWidth,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const HeaderSection(), // Pastikan HeaderSection ada dan berfungsi
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context); // Kembali ke halaman sebelumnya
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Memberi sedikit jarak setelah header

            Expanded(
              child: SingleChildScrollView( // Membungkus konten agar bisa di-scroll
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    _buildInputField('Username', _usernameController, false),
                    const SizedBox(height: 20),
                    _buildInputField('Email', _emailController, false, keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 20),
                    _buildInputField('Password', _passwordController, true),
                    const SizedBox(height: 20),
                    _buildInputField('Confirm Password', _confirmPasswordController, true),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Warna tombol biru
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Sudut tombol bulat
                          ),
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Memberi sedikit ruang di bagian bawah
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // BottomNavBar di bagian bawah halaman
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex, // Menggunakan _selectedIndex dari state
      ),
    );
  }

  Widget _buildInputField(String labelText, TextEditingController controller, bool isPassword, {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white), // Warna teks input putih
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[800], // Warna background input field
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), // Sudut input field bulat
              borderSide: BorderSide.none, // Tanpa border samping
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue, width: 2), // Border saat fokus
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none, // Border saat tidak fokus
            ),
            hintText: 'Enter your $labelText',
            hintStyle: TextStyle(color: Colors.grey[400]), // Warna hint teks
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}
