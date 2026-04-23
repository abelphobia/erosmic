import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> recentlyAdded = [
    "Blinding Lights",
    "Calm Nights",
    "Golden Hour",
    "Ocean Drive",
  ];

  final List<String> playlists = [
    "Workout Mix",
    "Study Playlist",
    "Chill Vibes",
    "Road Trip",
  ];

  final List<String> genres = [
    "Hip-Hop",
    "Pop",
    "Jazz",
    "Afrobeats",
  ];

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  List<String> filterList(List<String> items) {
    final query = _searchController.text.toLowerCase();

    if (query.isEmpty) return items;

    return items
        .where((item) => item.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredRecentlyAdded = filterList(recentlyAdded);
    final filteredPlaylists = filterList(playlists);
    final filteredGenres = filterList(genres);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================================================
              // SECTION 1: TOP BAR WITH CENTERED HOMEPAGE TITLE
              // =========================================================
              Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.menu, size: 30),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.account_circle, size: 30),
                      ),
                    ],
                  ),
                  const Text(
                    "HOMEPAGE",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // =========================================================
              // SECTION 2: GREETING TEXT
              // =========================================================
              Text(
                getGreeting(),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 18),

              // =========================================================
              // SECTION 3: SEARCH BAR
              // =========================================================
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // =========================================================
              // SECTION 4: RECENTLY ADDED
              // =========================================================
              buildSectionTitle("Recently Added"),
              const SizedBox(height: 14),
              buildHorizontalCards(filteredRecentlyAdded),

              const SizedBox(height: 28),

              // =========================================================
              // SECTION 5: PLAYLIST
              // =========================================================
              buildSectionTitle("Playlist"),
              const SizedBox(height: 14),
              buildHorizontalCards(filteredPlaylists),

              const SizedBox(height: 28),

              // =========================================================
              // SECTION 6: GENRE
              // =========================================================
              buildSectionTitle("Genre"),
              const SizedBox(height: 14),
              buildHorizontalCards(filteredGenres),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // REUSABLE SECTION TITLE WIDGET
  // =========================================================
  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // =========================================================
  // REUSABLE HORIZONTAL CARD LIST FOR EACH SECTION
  // =========================================================
  Widget buildHorizontalCards(List<String> items) {
    return SizedBox(
      height: 150,
      child: items.isEmpty
          ? const Center(
              child: Text(
                "No results found",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: 14),
              itemBuilder: (context, index) {
                return Container(
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        items[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}