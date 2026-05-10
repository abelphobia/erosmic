import 'package:flutter/material.dart';
import 'package:erosmic/pages/genre_page.dart';
import 'package:erosmic/pages/playlists_page.dart';
import 'package:erosmic/pages/all_tracks_page.dart';
import 'package:erosmic/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 71, 131, 221),
            ),
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
            title: const Text("Albums"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PlaylistPage()),
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
                MaterialPageRoute(builder: (_) => const GenrePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.music_note),
            title: const Text("All Songs"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AllTracksPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}