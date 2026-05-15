import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:erosmic/models/track_info.dart';
import 'package:erosmic/pages/mini_player.dart';

class AlbumsPage extends StatelessWidget {
  const AlbumsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tracks = context.watch<TrackInfo>().tracks;

    final albums = tracks.map((track) => track.album).toSet().toList();

    final Map<String, String> albumCovers = {
      "B Sides and Rarities": "assets/images/bsides_and_rarities.jpg",
      "House of Balloons": "assets/images/house_of_balloons.png",
      "Daughtry": "assets/images/daughtry.jpg",
      "Hot Mess": "assets/images/hot_mess.jpg",
      "Raymond v Raymond": "assets/images/raymond_v_raymond.png",
      "Random Access Memories": "assets/images/random_access_memories.png",
    };

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("A L B U M S"),
        centerTitle: true,
      ),
      body: albums.isEmpty
          ? const Center(
              child: Text("No albums available"),
            )
          : Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                itemCount: albums.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.78,
                ),
                itemBuilder: (context, index) {
                  final albumName = albums[index];
                  final coverPath = albumCovers[albumName];

                  return Container(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(14),
                            ),
                            child: coverPath != null
                                ? Image.asset(
                                    coverPath,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.album,
                                      size: 60,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            albumName,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
      bottomNavigationBar: const MiniPlayer(),
    );
  }
}