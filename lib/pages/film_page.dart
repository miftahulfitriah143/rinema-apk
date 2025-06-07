import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rinemaa/widgets/navigation_bar.dart';
import 'package:rinemaa/widgets/header_section.dart';

class Film {
  final int id;
  final String title;
  final String posterUrl;
  final double averageRating;
  final DateTime releaseDate;

  Film({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.averageRating,
    required this.releaseDate,
  });

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      id: json['id'],
      title: json['judul'],
      posterUrl: json['poster_url'],
      averageRating: (json['average_rating'] as num).toDouble(),
      releaseDate: DateTime.parse(json['tahun_rilis']),
    );
  }
}

class FilmPage extends StatefulWidget {
  const FilmPage({super.key});

  @override
  State<FilmPage> createState() => _FilmPageState();
}

class _FilmPageState extends State<FilmPage> with SingleTickerProviderStateMixin {
  late Future<List<Film>> _filmsFuture;
  late TabController _tabController;

  final String apiUrl = 'https://rinemaa.paramadina.ac.id/api/films/allFilm';

  @override
  void initState() {
    super.initState();
    _filmsFuture = fetchFilms();
    _tabController = TabController(length: 4, vsync: this);
  }

  Future<List<Film>> fetchFilms() async {
    final response = await http.get(Uri.parse(apiUrl));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (!jsonData.containsKey('data')) {
        throw Exception('Response JSON tidak mengandung key "data"');
      }
      final List filmsJson = jsonData['data'];
      return filmsJson.map((filmJson) => Film.fromJson(filmJson)).toList();
    } else {
      throw Exception('Failed to load films with status ${response.statusCode}');
    }
  }

  List<Film> getNewest(List<Film> films) {
    final sorted = [...films];
    sorted.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
    return sorted;
  }

  List<Film> getOldest(List<Film> films) {
    final sorted = [...films];
    sorted.sort((a, b) => a.releaseDate.compareTo(b.releaseDate));
    return sorted;
  }

  List<Film> getMostPopular(List<Film> films) {
    final sorted = [...films];
    sorted.sort((a, b) => b.averageRating.compareTo(a.averageRating));
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const HeaderSection(),

            // Search bar dengan border putih full rounded dan tulisan tengah
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'Search',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const Icon(Icons.search, color: Colors.white),
                  ],
                ),
              ),
            ),

            // Tab bar tanpa genre
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.white,
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Newest'),
                Tab(text: 'Oldest'),
                Tab(text: 'Popular'),
              ],
            ),

            Expanded(
              child: FutureBuilder<List<Film>>(
                future: _filmsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No films found',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final films = snapshot.data!;

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      buildGridFilm(films),
                      buildGridFilm(getNewest(films)),
                      buildGridFilm(getOldest(films)),
                      buildGridFilm(getMostPopular(films)),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  Widget buildGridFilm(List<Film> films) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        padding: EdgeInsets.zero,
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
                  child: Image.network(
                    film.posterUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey,
                      child: const Icon(Icons.broken_image, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                film.title,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const SizedBox(width: 2),
                  Text(
                    film.averageRating.toStringAsFixed(1),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  )
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
