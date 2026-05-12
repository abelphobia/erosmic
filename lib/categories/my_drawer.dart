// My drawer is used to sort the categories of features on the sandwhich column.
// THese include the all tracks, playlist, genres, settings, and upload page.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:erosmic/pages/genre_page.dart';
import 'package:erosmic/pages/playlists_page.dart';
import 'package:erosmic/pages/all_tracks_page.dart';
import 'package:erosmic/pages/settings_page.dart';
import 'package:erosmic/models/track_info.dart';

// creates a custom widget that can be place on multiple apps
class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key}); // super keys accepts an optional key parameter

  @override
  Widget build(BuildContext context) {
    // Navigation to the main menu
    return Drawer(
      // A Child can accept a single widget
      child: ListView(
        padding: EdgeInsets.zero,
        // Children can accept a list of widgets
        children: [
          // consts can not be modified once itialized
          // header of the menu page
          const DrawerHeader(
            decoration: BoxDecoration(color: Color.fromARGB(255, 71, 131, 221)),
            // because there is a children property, we can set multiple childs
            // onto this list.
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
          // First List (Homepage)
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Homepage"),
            onTap: () {
              // Navigators directs the user to another page on the application
              Navigator.pop(context);
              // Since there is no direct push, this pushes the app back to the main
              // page, which in this case would be the homepage.
            },
          ),
          // Second List (Playlists)
          ListTile(
            // icons create physical icons, like Caleb Williams
            leading: const Icon(Icons.library_music),
            title: const Text("Playlists"),
            onTap: () {
              // Ontap allows to trigger the request to send the user
              Navigator.pop(context);
              // Navigator gets pushed to MaterialPageRoute which sends the user
              // to the PlaylistPage that is created.
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PlaylistPage()),
              );
            },
          ),
          // Third List (Genres) | Sends the user to genre page
          ListTile(
            leading: const Icon(Icons.crop_square),
            title: const Text("Genres"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GenrePage()),
              );
            },
          ),
          // Fourth List (All Song) | Sends the user to the AllTracksPage
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
          // Fifth List (Settings) | Sends the user to settings page
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
          // Sixth List (Importing songs)
          ListTile(
            leading: const Icon(Icons.file_upload),
            title: const Text("Import Local Songs"),
            onTap: () {
              // With the depenencies, we can read and write local files
              // to play with media on the application
              Navigator.pop(context);
              context.read<TrackInfo>().pickLocalFiles();
            },
            // The media imported locally will also be placed on recently added.
          ),
        ],
      ),
    );
  }
}
