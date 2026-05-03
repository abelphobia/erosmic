import 'package:flutter/material.dart';

class GenrePage extends StatelessWidget {
  const GenrePage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      "Hip-Hop",
      "Pop",
      "Jazz",
      "Afrobeats",
      "R&B",
      "Classical",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Genre"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.library_music),
            title: Text(items[index]),
          );
        },
      ),
    );
  }
}