import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:erosmic/models/track_info.dart';
import 'package:erosmic/pages/mini_player.dart';

class AllTracksPage extends StatefulWidget {
  const AllTracksPage({super.key});

  @override
  State<AllTracksPage> createState() => _AllTracksPageState();
}

class _AllTracksPageState extends State<AllTracksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("ALL TRACKS"),
        centerTitle: true,
      ),
      body: Consumer<TrackInfo>(
        builder: (context, trackInfo, child) {
          if (trackInfo.tracks.isEmpty) {
            return const Center(
              child: Text("No tracks available"),
            );
          }

          return ListView.builder(
            itemCount: trackInfo.tracks.length,
            itemBuilder: (context, index) {
              final track = trackInfo.tracks[index];

              return ListTile(
                leading: const Icon(Icons.music_note),
                title: Text(track.title),
                subtitle: Text(track.artist),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const MiniPlayer(),
    );
  }
}
