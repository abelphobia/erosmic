import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:erosmic/models/track_info.dart';

class AlbumsPage extends StatelessWidget {
  const AlbumsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tracks = context.watch<TrackInfo>().tracks;

    final Map<String, String?> albumArt = {};
    for (final track in tracks) {
      if (!albumArt.containsKey(track.album)) {
        albumArt[track.album] = track.albumArtUrl;
      }
    }

    final albums = albumArt.keys.toList();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: const Text("A L B U M S"), centerTitle: true),
      body: albums.isEmpty
          ? const Center(child: Text("No albums available"))
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
                  final artUrl = albumArt[albumName];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AlbumTracksPage(album: albumName),
                        ),
                      );
                    },
                    child: Container(
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
                              child: artUrl != null
                                  ? Image.network(
                                      artUrl,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, progress) {
                                            if (progress == null) return child;
                                            return Container(
                                              color: Colors.grey[200],
                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              ),
                                            );
                                          },
                                      errorBuilder: (context, error, stack) {
                                        return Container(
                                          color: Colors.grey[300],
                                          child: const Icon(
                                            Icons.album,
                                            size: 60,
                                            color: Colors.grey,
                                          ),
                                        );
                                      },
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
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class AlbumTracksPage extends StatelessWidget {
  final String album;

  const AlbumTracksPage({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    final trackInfo = context.watch<TrackInfo>();
    final songs = trackInfo.tracks.where((t) => t.album == album).toList();

    return Scaffold(
      appBar: AppBar(title: Text(album), centerTitle: true),
      body: songs.isEmpty
          ? const Center(child: Text("No tracks found"))
          : ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                final fullIndex = trackInfo.tracks.indexWhere(
                  (t) => t.id == song.id,
                );

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 64, 131, 175),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    song.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(song.artist),
                  trailing: const Icon(Icons.play_arrow),
                  onTap: () {
                    if (fullIndex != -1) {
                      trackInfo.playSong(fullIndex);
                    }
                  },
                );
              },
            ),
    );
  }
}

class ArtistTrackPage extends StatelessWidget {
  final String genre;

  const ArtistTrackPage({super.key, required this.genre});

  @override
  Widget build(BuildContext context) {
    final trackInfo = context.watch<TrackInfo>();
    final songs = trackInfo.tracks.where((t) => t.genre == genre).toList();

    return Scaffold(
      appBar: AppBar(title: Text(genre), centerTitle: true),
      body: songs.isEmpty
          ? const Center(child: Text("No songs found"))
          : ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 64, 131, 175),
                    child: Icon(Icons.music_note, color: Colors.white),
                  ),
                  title: Text(
                    song.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(song.artist),
                  trailing: const Icon(Icons.play_arrow),
                  onTap: () {
                    final fullIndex = trackInfo.tracks.indexWhere(
                      (t) => t.id == song.id,
                    );
                    if (fullIndex != -1) {
                      trackInfo.playSong(fullIndex);
                    }
                  },
                );
              },
            ),
    );
  }
}
