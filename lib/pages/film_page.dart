import 'package:flutter/material.dart';
import 'package:rinemaa/widgets/navigation_bar.dart';

class FilmPage extends StatelessWidget {
  final List<Map<String, String>> films = List.generate(
    12,
        (index) => {
      "title": [
        "Petaka Gunung Gede",
        "Petrok Gula",
        "Menanti",
        "Komang",
        "Sikandar",
        "Cecote Tongce"
      ][index % 6],
      "image": [
        "assets/petaka.jpg",
        "assets/petrok.jpg",
        "assets/menanti.jpg",
        "assets/komang.jpg",
        "assets/sikandar.jpg",
        "assets/cecote.jpg"
      ][index % 6],
      "rating": "6.${index % 10}"
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "RINEMA",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GridView.builder(
          itemCount: films.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final film = films[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 2 / 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      film['image']!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  film['title']!,
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 2),
                    Text(
                      film['rating']!,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    )
                  ],
                )
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}
