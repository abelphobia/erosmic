import 'package:flutter/material.dart';
import '../widgets/mini_player.dart';
import 'playlists_page.dart';
import 'genre_page.dart';

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
    return items.where((item) => item.toLowerCase().contains(query)).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredRecentlyAdded = filterList(recentlyAdded);
    final filteredPlaylists = filterList(playlists);
    final filteredGenres = filterList(genres);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      drawer: buildAppDrawer(context),
      bottomNavigationBar: const MiniPlayer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar with centered title
              Builder(
                builder: (context) => Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
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
              ),

              const SizedBox(height: 20),

              // Greeting
              Text(
                getGreeting(),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 18),

              // Search bar
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

              // Recently Added (homepage only, not clickable)
              buildSectionTitle("Recently Added"),
              const SizedBox(height: 14),
              buildStaticHorizontalCards(filteredRecentlyAdded),

              const SizedBox(height: 28),

              // Playlist (clickable)
              buildSectionHeader(
                context,
                "Playlist",
                const PlaylistPage(),
              ),
              const SizedBox(height: 14),
              buildHorizontalCards(
                context,
                filteredPlaylists,
                const PlaylistPage(),
              ),

              const SizedBox(height: 28),

              // Genre (clickable)
              buildSectionHeader(
                context,
                "Genre",
                const GenrePage(),
              ),
              const SizedBox(height: 14),
              buildHorizontalCards(
                context,
                filteredGenres,
                const GenrePage(),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAppDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurple),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Erosmic Menu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Homepage"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.queue_music),
            title: const Text("Playlist"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlaylistPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.library_music),
            title: const Text("Genre"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GenrePage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildSectionHeader(BuildContext context, String title, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }

  // For Recently Added only (not clickable)
  Widget buildStaticHorizontalCards(List<String> items) {
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
              separatorBuilder: (context, index) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                return Container(
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
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

  // For Playlist and Genre (clickable)
  Widget buildHorizontalCards(
    BuildContext context,
    List<String> items,
    Widget page,
  ) {
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
              separatorBuilder: (context, index) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => page),
                    );
                  },
                  child: Container(
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
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
                  ),
                );
              },
            ),
    );
  }
}