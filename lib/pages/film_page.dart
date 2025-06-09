import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rinemaa/widgets/navigation_bar.dart';
import 'package:rinemaa/widgets/header_section.dart';

// Kelas Film yang diperbarui dengan bidang 'genres'
class Film {
  final int id;
  final String title;
  final String posterUrl;
  final double averageRating;
  final DateTime releaseDate;
  final List<String> genres; // Bidang genre baru

  Film({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.averageRating,
    required this.releaseDate,
    required this.genres, // Menambahkan genre ke konstruktor
  });

  factory Film.fromJson(Map<String, dynamic> json) {
    List<String> parsedGenres = [];
    if (json.containsKey('genres') && json['genres'] is List) {
      // Mengasumsikan 'genres' adalah daftar string
      parsedGenres = List<String>.from(json['genres'].map((x) => x.toString()));
    } else if (json.containsKey('genre') && json['genre'] is String) {
      // Jika 'genre' adalah string tunggal, bungkus dalam daftar
      parsedGenres = [json['genre']];
    }
    // Jika kunci 'genres' tidak ada atau bukan daftar, parsedGenres akan tetap kosong.

    return Film(
      id: json['id'],
      title: json['judul'],
      posterUrl: json['poster_url'],
      averageRating: (json['average_rating'] as num).toDouble(),
      releaseDate: DateTime.parse(json['tahun_rilis']),
      genres: parsedGenres, // Menetapkan genre yang diurai
    );
  }
}

class FilmPage extends StatefulWidget {
  const FilmPage({super.key});

  @override
  State<FilmPage> createState() => _FilmPageState();
}

class _FilmPageState extends State<FilmPage> with SingleTickerProviderStateMixin {
  Future<List<Film>>? _filmsFuture; // Mengubah menjadi Future yang nullable
  TabController? _tabController; // Mengubah menjadi TabController yang nullable
  List<Film> _allFilms = []; // Menyimpan semua film yang diambil
  final TextEditingController _searchController = TextEditingController(); // Controller untuk search bar
  String _searchQuery = ''; // State untuk menyimpan query pencarian

  // Mengatur daftar genre secara eksplisit
  final List<String> _genres = [
    'All',
    'Newest',
    'Oldest',
    'Popular',
    'Komedi', // Genre yang diminta
    'Aksi',   // Genre yang diminta
    'Drama',  // Genre yang diminta
    'Thriller', // Genre yang diminta
    'Romance',  // Genre yang diminta
    'Animasi',  // Genre yang diminta
    'Fantasi',  // Genre yang diminta
    'Horor',    // Genre yang diminta
  ];

  final String apiUrl = 'https://rinemaa.paramadina.ac.id/api/films/allFilm';

  @override
  void initState() {
    super.initState();
    _filmsFuture = fetchFilms();
    _tabController = TabController(length: _genres.length, vsync: this);

    _filmsFuture!.then((films) {
      setState(() {
        _allFilms = films;
      });
    }).catchError((error) {
      print('Error fetching films: $error');
    });

    // Menambahkan listener pada controller pencarian
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text; // Memperbarui query pencarian
      });
    });
  }

  @override
  void dispose() {
    _tabController?.dispose(); // Buang pengontrol saat widget dibuang
    _searchController.dispose(); // Buang controller pencarian
    super.dispose();
  }

  Future<List<Film>> fetchFilms() async {
    final response = await http.get(Uri.parse(apiUrl));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (!jsonData.containsKey('data')) {
        throw Exception('Response JSON tidak mengandung kunci "data"');
      }
      final List filmsJson = jsonData['data'];
      return filmsJson.map((filmJson) => Film.fromJson(filmJson)).toList();
    } else {
      throw Exception('Gagal memuat film dengan status ${response.statusCode}');
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

  // Fungsi baru untuk memfilter film berdasarkan genre
  List<Film> getFilmsByGenre(List<Film> films, String genre) {
    return films.where((film) => film.genres.contains(genre)).toList();
  }

  // Fungsi baru untuk memfilter film berdasarkan query pencarian
  List<Film> _filterFilms(List<Film> films) {
    if (_searchQuery.isEmpty) {
      return films;
    } else {
      return films.where((film) {
        return film.title.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Mengatur semua konten kolom ke kiri
          children: [
            const HeaderSection(),

            // Search bar dengan border putih full rounded dan tulisan tengah
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField( // Mengubah Row menjadi TextField
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.white), // Ikon search di kiri
                    border: InputBorder.none, // Menghilangkan border default TextField
                    contentPadding: const EdgeInsets.symmetric(vertical: 12), // Padding konten input
                  ),
                  textAlign: TextAlign.start, // Mengatur teks ke awal
                ),
              ),
            ),

            // Tab bar, selalu tampilkan karena _tabController sudah diinisialisasi di initState
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0), // Padding hanya di sisi kiri
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.white,
                tabAlignment: TabAlignment.start, // Menambahkan ini untuk meratakan tab ke awal
                indicatorSize: TabBarIndicatorSize.label, // Mengatur ukuran indikator agar sesuai dengan lebar label
                tabs: _genres.map((genre) => Tab(text: genre)).toList(),
              ),
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
                        'Tidak ada film ditemukan',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  // Terapkan filter pencarian pada semua film yang diambil
                  final filteredFilms = _filterFilms(snapshot.data!);

                  if (filteredFilms.isEmpty && _searchQuery.isNotEmpty) {
                    return Center(
                      child: Text(
                        'Tidak ada film ditemukan untuk "${_searchQuery}"',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }


                  // Setelah data dimuat dan _allFilms diisi, _tabController sudah siap di initState
                  return TabBarView(
                    controller: _tabController,
                    children: _genres.map((genre) {
                      // Menggunakan filteredFilms yang sudah difilter oleh search bar
                      switch (genre) {
                        case 'All':
                          return buildGridFilm(filteredFilms);
                        case 'Newest':
                          return buildGridFilm(getNewest(filteredFilms));
                        case 'Oldest':
                          return buildGridFilm(getOldest(filteredFilms));
                        case 'Popular':
                          return buildGridFilm(getMostPopular(filteredFilms));
                        default:
                          return buildGridFilm(getFilmsByGenre(filteredFilms, genre));
                      }
                    }).toList(),
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
