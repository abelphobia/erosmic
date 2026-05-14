// The main directory of the page. This allows the user to hover to the category
// page, search songs directly from the homepage, view recently added songs
// genres, and albums. Additionally the user can use the miniplayer where
// the application opens to the now playing section of the page.
//

import 'package:flutter/material.dart';
import 'package:erosmic/pages/mini_player.dart';
import 'package:erosmic/pages/genre_page.dart';
import 'package:erosmic/models/track_info.dart';
import 'package:provider/provider.dart';
import 'package:erosmic/models/song.dart';
import 'package:erosmic/categories/my_drawer.dart';
import 'package:erosmic/pages/albums_page.dart';

// creates a custom widget that can be place on multiple apps
class HomePage extends StatefulWidget {
  // Stateful Widgets can be be changed and rebuilt
  const HomePage({super.key}); // super keys accepts an optional key parameter

  @override // overriding a method from a stateful widget allows to the test the statefulwidget for bugs and/or errors
  // @override is a good method as it gives you safety against future changes, especially with superclasses.
  State<HomePage> createState() => _HomePageState();
  // creates the widget and makes a new instance of the states subclass.
  // this allows for a fresh state object to make cycling objects easier + faster
}

class _HomePageState extends State<HomePage> {
  // creates a statefulwidget for the homepage widget
  final TextEditingController _searchController =
      TextEditingController(); // declares a controller to modify and change text as needed.

  // Greeting text for user
  String getGreeting() {
    // DateTime.Now gets time from device
    final hour =
        DateTime.now().hour; // declare variables assigned to a value only once
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  // This creates a list for recently added from the 5 most recent data
  List<Song> getRecentlyAdded(List<Song> tracks) => tracks.take(5).toList();
  // This creates a list for Genres and maps to the genre
  List<String> getUniqueGenres(List<Song> tracks) =>
      tracks.map((t) => t.genre).toSet().toList();
  // This creates a list for Albums and lets the user select it.
  List<String> getUniqueAlbums(List<Song> tracks) =>
      tracks.map((t) => t.album).toSet().toList();
  // Filters the track then places the controller to a query. || VERIFY
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

  // filters queries in a list
  List<String> filterStrings(List<String> items) {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return items;
    return items.where((s) => s.toLowerCase().contains(query)).toList();
  }

  // disposes the controller to clear out the memory
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  // trackInfo || places data
  Widget build(BuildContext context) {
    // grabs the infromation of the trackInfo then places it on the ome page
    final trackInfo = context.watch<TrackInfo>();
    final allTracks = trackInfo.tracks;
    // filters out the recently added tracks / albums / genres and places them onto the its category
    final filteredRecentlyAdded = filterTracks(getRecentlyAdded(allTracks));
    final filteredAlbums = filterStrings(getUniqueAlbums(allTracks));
    final filteredGenres = filterStrings(getUniqueGenres(allTracks));

    // whole front end design of the app
    return Scaffold( 
      // applies the app drawer package
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: buildAppDrawer(context),
      // miniplayer 
      bottomNavigationBar: const MiniPlayer(),
      body: SafeArea(
        child: SingleChildScrollView(  // makes the widget scrollable
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // allows multiple list of widgets in a widger
              Builder(
                builder: (context) => Stack( // builds the context instances of the multiple widgets
                  alignment: Alignment.center,
                  children: [
                    // applies the MyDrawer package
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Scaffold.of(context).openDrawer(), // callback for the iconbutton
                          icon: const Icon(Icons.menu, size: 30), // caleb williams (for now)
                        ),
                        // Applies the the account circle (will be created later)
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.account_circle, size: 30),
                        ),
                      ],
                    ),
                    // title of the page
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

              // Greeting by time of the hour
              Text(
                getGreeting(),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 18),

              // Search bar // USE A NAVIGATOR
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
               // Creates multiple cards of each category
              // Recently Added
              const SizedBox(height: 28),
              buildSectionTitle("Recently Added"),
              const SizedBox(height: 14),
              buildStaticHorizontalCards(filteredRecentlyAdded),

              // Albums
              const SizedBox(height: 28),
              buildSectionHeader(context, "Albums", const AlbumsPage()),
              const SizedBox(height: 14),
              buildHorizontalCards(context, filteredAlbums, const AlbumsPage()),

              // Genre
              const SizedBox(height: 28),
              buildSectionHeader(context, "Genre", const GenrePage()),
              const SizedBox(height: 14),
              buildHorizontalCards(context, filteredGenres, const GenrePage()),

              // possible deletion, need to check when i get home.
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Applies the MyDrawer widget

  Widget buildAppDrawer(BuildContext context) {
    return const MyDrawer();
  }

  // Applies the Builders

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

//  
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

  // Card builder functionalities

  // Recently Added — tap anywhere on card to play the song
  Widget buildStaticHorizontalCards(List<Song> items) {
    return SizedBox(
      height: 150,
      child: items.isEmpty // if the application does not have any uploaded songs on either local or server
          ? const Center(
              child: Text("No results found", style: TextStyle(fontSize: 16)),
            )
          : ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final song = items[index]; // retrieves the songs from the song package
                return GestureDetector( 
                  onTap: () { // allows the button to be pressed
                    final trackInfo = context.read<TrackInfo>(); // finalizes the trackInfo from package TrackInfo
                    final fullIndex = trackInfo.tracks.indexOf(song); // gets the full index of all the songs provided from song.dart
                    if (fullIndex != -1) {
                      trackInfo.playSong(fullIndex); // allows the user to play the song
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
