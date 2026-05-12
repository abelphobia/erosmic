import 'package:flutter/material.dart';
import 'package:erosmic/pages/mini_player.dart';
import 'package:erosmic/pages/playlists_page.dart';
import 'package:erosmic/pages/genre_page.dart';
import 'package:erosmic/models/track_info.dart';
import 'package:provider/provider.dart';
import 'package:erosmic/models/song.dart';
import 'package:erosmic/categories/my_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  List<Song> getRecentlyAdded(List<Song> tracks) => tracks.take(5).toList();

  List<String> getUniqueGenres(List<Song> tracks) =>
      tracks.map((t) => t.genre).toSet().toList();

  List<String> getUniqueAlbums(List<Song> tracks) =>
      tracks.map((t) => t.album).toSet().toList();

  List<Song> filterTracks(List<Song> tracks) {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return tracks;
    return tracks
        .where(
          (t) =>
              t.title.toLowerCase().contains(query) ||
              t.artist.toLowerCase().contains(query),
        )
        .toList();
  }

  List<String> filterStrings(List<String> items) {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return items;
    return items.where((s) => s.toLowerCase().contains(query)).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trackInfo = context.watch<TrackInfo>();
    final allTracks = trackInfo.tracks;

    final filteredRecentlyAdded = filterTracks(getRecentlyAdded(allTracks));
    final filteredAlbums = filterStrings(getUniqueAlbums(allTracks));
    final filteredGenres = filterStrings(getUniqueGenres(allTracks));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: buildAppDrawer(context),
      bottomNavigationBar: const MiniPlayer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Builder(
                builder: (context) => Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Scaffold.of(context).openDrawer(),
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
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.05),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Recently Added
              buildSectionTitle("Recently Added"),
              const SizedBox(height: 14),
              buildStaticHorizontalCards(filteredRecentlyAdded),

              const SizedBox(height: 28),

              // Albums
              buildSectionHeader(context, "Albums", const PlaylistPage()),
              const SizedBox(height: 14),
              buildHorizontalCards(
                context,
                filteredAlbums,
                const PlaylistPage(),
              ),

              const SizedBox(height: 28),

              // Genre
              buildSectionHeader(context, "Genre", const GenrePage()),
              const SizedBox(height: 14),
              buildHorizontalCards(context, filteredGenres, const GenrePage()),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ── Drawer ──────────────────────────────────────────────────────────────────

  Widget buildAppDrawer(BuildContext context) {
    return const MyDrawer();
  }

  // ── Section builders ────────────────────────────────────────────────────────

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget buildSectionHeader(BuildContext context, String title, Widget page) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }

  // ── Card builders ────────────────────────────────────────────────────────────

  // Recently Added — tap anywhere on card to play the song
  Widget buildStaticHorizontalCards(List<Song> items) {
    return SizedBox(
      height: 150,
      child: items.isEmpty
          ? const Center(
              child: Text("No results found", style: TextStyle(fontSize: 16)),
            )
          : ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final song = items[index];
                return GestureDetector(
                  onTap: () {
                    final trackInfo = context.read<TrackInfo>();
                    final fullIndex = trackInfo.tracks.indexOf(song);
                    if (fullIndex != -1) {
                      trackInfo.playSong(fullIndex);
                    }
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Play button in the middle
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 71, 131, 221),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            song.title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            song.artist,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Albums / Genres — String labels, clickable
  Widget buildHorizontalCards(
    BuildContext context,
    List<String> items,
    Widget page,
  ) {
    return SizedBox(
      height: 150,
      child: items.isEmpty
          ? const Center(
              child: Text("No results found", style: TextStyle(fontSize: 16)),
            )
          : ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (ctx, i) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => page),
                  ),
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
                            fontSize: 15,
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
