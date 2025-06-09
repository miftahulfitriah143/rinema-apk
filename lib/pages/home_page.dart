import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:rinemaa/widgets/navigation_bar.dart';
import '../models/event.dart';
import '../widgets/header_section.dart';
import '../widgets/menu_card.dart';
import '../widgets/event_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedGenre = 'Semua';
  final PageController _posterController = PageController(viewportFraction: 1.0);

  final List<String> posterImages = [
    'assets/images/pembantaian.jpg',
    'assets/images/pabrik_gula.jpg',
    'assets/images/komang.jpg',
    'assets/images/pembantaian.jpg',
  ];

  final List<Event> terbaru = [
    Event(title: "Petaka Gunung Gede", image: "assets/images/petaka.jpeg"),
    Event(title: "Pabrik Gula Uncut", image: "assets/images/pabrik_gula.jpg"),
    Event(title: "Pembantaian Dukun Santet", image: "assets/images/pembantaian.jpg"),
    Event(title: "Pabrik Gula Uncut", image: "assets/images/pabrik_gula.jpg"),
  ];

  final List<Event> terlawas = [
    Event(title: "Komang", image: "assets/images/komang.jpg"),
    Event(title: "Pabrik Gula Uncut", image: "assets/images/pabrik_gula.jpg"),
    Event(title: "Pembantaian Dukun Santet", image: "assets/images/pembantaian.jpg"),
    Event(title: "Pabrik Gula Uncut", image: "assets/images/pabrik_gula.jpg"),
  ];

  Widget genreButton(String label) {
    final isSelected = label == selectedGenre;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGenre = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          border: Border.all(color: Colors.white24),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const HeaderSection(),

            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 16),

                  // 🔥 Poster Slider (kotak penuh + page indicator)
                  SizedBox(
                    height: 360,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 340,
                          child: PageView.builder(
                            controller: _posterController,
                            itemCount: posterImages.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Image.asset(
                                  posterImages[index],
                                  fit: BoxFit.contain, // tampil utuh tanpa crop
                                  width: double.infinity,
                                  height: 320,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        SmoothPageIndicator(
                          controller: _posterController,
                          count: posterImages.length,
                          effect: ExpandingDotsEffect(
                            dotColor: Colors.white24,
                            activeDotColor: Colors.white,
                            dotHeight: 8,
                            dotWidth: 8,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  MenuCard(title: 'Terbaru'),
                  SizedBox(
                    height: 230,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: terbaru.length,
                      itemBuilder: (context, index) {
                        return EventCard(event: terbaru[index]);
                      },
                    ),
                  ),
                  MenuCard(title: 'Terlawas'),
                  SizedBox(
                    height: 230,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: terlawas.length,
                      itemBuilder: (context, index) {
                        return EventCard(event: terlawas[index]);
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text(
                      'Pilihan Genre',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
                      children: [
                        genreButton('Semua'),
                        genreButton('Comedy'),
                        genreButton('Action'),
                        genreButton('Drama'),
                        genreButton('Thriller'),
                        genreButton('Romance'),
                        genreButton('Animation'),
                        genreButton('Fantasy'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Terpopuler',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/pabrik_gula.jpg',
                            width: 120,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pabrik Gula Uncut',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Horror, Action\n14 April 2025 • 102 Menit • 17+',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    '8,6 ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}
