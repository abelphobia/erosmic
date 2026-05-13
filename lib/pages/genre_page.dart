import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:erosmic/models/track_info.dart';

class GenrePage extends StatelessWidget {
  const GenrePage({super.key});

  @override
  Widget build(BuildContext context) {
    final trackInfo = context.watch<TrackInfo>();

    if (trackInfo.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (trackInfo.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Genre"), centerTitle: true),
        body: Center(child: Text("Error: ${trackInfo.error}")),
      );
    }

    final genres = trackInfo.genres.isEmpty
        ? trackInfo.tracks.map((t) => t.genre).toSet().toList()
        : trackInfo.genres;

    return Scaffold(
      appBar: AppBar(title: const Text("GENRES"), centerTitle: true),
      body: genres.isEmpty
          ? const Center(child: Text("No genres found"))
          : ListView.builder(
              itemCount: genres.length,
              itemBuilder: (context, index) {
                final genre = genres[index];
                final songCount = trackInfo.tracks
                    .where((t) => t.genre == genre)
                    .length;

                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.library_music, color: Colors.white),
                  ),
                  title: Text(
                    genre,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text("$songCount song${songCount == 1 ? '' : 's'}"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GenreTracksPage(genre: genre),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

// ── Genre Tracks Page ─────────────────────────────────────────────────────────

class GenreTracksPage extends StatelessWidget {
  final String genre;

  const GenreTracksPage({super.key, required this.genre});

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
                    backgroundColor: Colors.deepPurple,
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
