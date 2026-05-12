import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:erosmic/models/track_info.dart';
import 'package:erosmic/models/song.dart';

class AllTracksPage extends StatefulWidget {
  const AllTracksPage({super.key});

  @override
  State<AllTracksPage> createState() => _AllTracksPageState();
}

class _AllTracksPageState extends State<AllTracksPage> {
  final TextEditingController _searchController = TextEditingController();

  List<Song> filterTracks(List<Song> tracks) {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return tracks;

    return tracks.where((track) {
      return track.title.toLowerCase().contains(query) ||
          track.artist.toLowerCase().contains(query) ||
          track.album.toLowerCase().contains(query) ||
          track.genre.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: const Text("ALL SONGS"), centerTitle: true),

      // Miniplayer location
      body: Consumer<TrackInfo>(
        builder: (context, trackInfo, child) {
          final filteredTracks = filterTracks(trackInfo.tracks);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: "Search songs, artist, album, genre...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: filteredTracks.isEmpty
                    ? const Center(child: Text("No songs found"))
                    : ListView.builder(
                        itemCount: filteredTracks.length,
                        itemBuilder: (context, index) {
                          final track = filteredTracks[index];
                          return ListTile(
                            leading: const Icon(Icons.music_note),
                            title: Text(track.title),
                            subtitle: Text("${track.artist} • ${track.album}"),
                            onTap: () {
                              final trackInfo = context.read<TrackInfo>();
                              final originalIndex = trackInfo.tracks.indexOf(
                                track,
                              );
                              if (originalIndex != -1) {
                                trackInfo.playSong(originalIndex);
                              }
                              trackInfo.playSong(index);
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
