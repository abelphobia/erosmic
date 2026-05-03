import 'package:flutter/material.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      "Workout Mix",
      "Study Playlist",
      "Chill Vibes",
      "Road Trip",
      "Relax Mode",
      "Party Mix",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Playlist"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.queue_music),
            title: Text(items[index]),
          );
        },
      ),
    );
  }
}