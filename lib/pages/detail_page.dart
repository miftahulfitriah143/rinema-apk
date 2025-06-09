import 'package:flutter/material.dart';
import 'package:rinemaa/widgets/navigation_bar.dart';
import 'package:rinemaa/widgets/header_section.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/event.dart';

class DetailPage extends StatefulWidget {
  final Event event;

  const DetailPage({super.key, required this.event});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // Fungsi untuk membuka URL YouTube di aplikasi YouTube jika memungkinkan
  _launchYouTubeApp(String youtubeVideoId) async {
    final Uri youtubeAppUri = Uri.parse('youtube://watch?v=$youtubeVideoId');
    final Uri youtubeWebUri = Uri.parse('https://www.youtube.com/watch?v=$youtubeVideoId'); // Perbaiki URL fallback

    try {
      if (await canLaunchUrl(youtubeAppUri)) {
        await launchUrl(youtubeAppUri);
      } else if (await canLaunchUrl(youtubeWebUri)) {
        await launchUrl(youtubeWebUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak bisa membuka trailer.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // ID Video YouTube yang Anda inginkan
    // PASTIKAN INI ADALAH ID VIDEO YOUTUBE YANG VALID!
    final String youtubeVideoId = 'P-6STU_kfaU'; // <--- INI YANG DIUBAH!

    // Membuat URL thumbnail YouTube
    // Anda bisa memilih 'mqdefault', 'hqdefault', 'sddefault', atau 'maxresdefault'
    final String youtubeThumbnailUrl = 'https://img.youtube.com/vi/$youtubeVideoId/hqdefault.jpg';

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Area Header dengan Tombol Kembali dan Logo di Tengah
            Container(
              height: 75,
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
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Konten Detail Film
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Image.asset(
                              widget.event.image, // Akses event melalui widget.event
                              width: 120,
                              height: 160,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.event.title, // Akses event melalui widget.event
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Text(
                                      'Horror, Action',
                                      style: TextStyle(color: Colors.white70, fontSize: 14),
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        const Text(
                                          '8.6 ',
                                          style: TextStyle(color: Colors.white70, fontSize: 14),
                                        ),
                                        const Icon(Icons.star, color: Colors.yellow, size: 16),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  '14 April 2005 • 102 Menit • 17+',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Deskripsi film akan ditampilkan di sini. Kamu bisa menambahkan sinopsis, genre, sutradara, dll.',
                                  style: TextStyle(color: Colors.white70, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Trailer YouTube Section
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        onTap: () {
                          _launchYouTubeApp(youtubeVideoId); // Panggil fungsi dengan ID video
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network( // UBAH KE Image.network
                                youtubeThumbnailUrl, // GUNAKAN URL THUMBNAIL YANG DIBUAT
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: screenWidth * 9 / 16, // Aspek rasio 16:9
                                errorBuilder: (context, error, stackTrace) {
                                  // Fallback jika thumbnail gagal dimuat
                                  return Container(
                                    height: screenWidth * 9 / 16,
                                    color: Colors.grey.shade800,
                                    child: const Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.broken_image, color: Colors.white70, size: 50),
                                          SizedBox(height: 10),
                                          Text(
                                            'Thumbnail tidak dapat dimuat',
                                            style: TextStyle(color: Colors.white70),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    height: screenWidth * 9 / 16,
                                    color: Colors.grey.shade900,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                            : null,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const Icon(
                              Icons.play_circle_filled,
                              color: Colors.white,
                              size: 70,
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Tonton di YouTube',
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}
