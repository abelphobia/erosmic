import 'package:flutter/material.dart';
import 'package:erosmic/pages/settings_page.dart';
import 'package:erosmic/pages/all_tracks_page.dart';
import 'package:erosmic/pages/artists_page.dart';
import 'package:erosmic/pages/albums_page.dart';
import 'package:erosmic/pages/genre_page.dart';
import 'package:erosmic/pages/playlists_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // logo
          DrawerHeader(
            child: Center(
              child: Text(
                "E R O S M I C",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),

          // home tile
          Padding(
            padding: EdgeInsets.only(left: 30.0, top: 26.0),
            child: ListTile(
              title: const Text(" H O M E "),
              leading: Icon(Icons.home),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),

          // playlists tile
          Padding(
            padding: EdgeInsets.only(left: 30.0, top: 26.0),
            child: ListTile(
              title: const Text(" P L A Y L I S T S "),
              leading: Icon(Icons.playlist_play),
              onTap: () {
                Navigator.pop(context);

                // navigate to playlists page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlaylistsPage()),
                );
              },
            ),
          ),

          // all tracks tile
          Padding(
            padding: EdgeInsets.only(left: 30.0, top: 26.0),
            child: ListTile(
              title: const Text(" A L L   T R A C K S "),
              leading: Icon(Icons.music_note),
              onTap: () {
                Navigator.pop(context);

                // navigate to all tracks page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllTracksPage()),
                );
              },
            ),
          ),

          // Artists tile
          Padding(
            padding: EdgeInsets.only(left: 30.0, top: 26.0),
            child: ListTile(
              title: const Text(" A R T I S T S "),
              leading: Icon(Icons.person),
              onTap: () {
                Navigator.pop(context);

                // navigate to artists page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ArtistsPage()),
                );
              },
            ),
          ),

          // albums tile
          Padding(
            padding: EdgeInsets.only(left: 30.0, top: 26.0),
            child: ListTile(
              title: const Text(" A L B U M S "),
              leading: Icon(Icons.album),
              onTap: () {
                Navigator.pop(context);

                // navigate to albums page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AlbumsPage()),
                );
              },
            ),
          ),

          // genres tile
          Padding(
            padding: EdgeInsets.only(left: 30.0, top: 26.0),
            child: ListTile(
              title: const Text(" G E N R E S "),
              leading: Icon(Icons.category),
              onTap: () {
                Navigator.pop(context);

                // navigate to genres page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GenrePage()),
                );
              },
            ),
          ),

          // settings tile
          Padding(
            padding: EdgeInsets.only(left: 30.0, top: 26.0),
            child: ListTile(
              title: const Text(" S E T T I N G S "),
              leading: Icon(Icons.settings),
              onTap: () {
                // pop drawer
                Navigator.pop(context);

                // navigate to settings page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
