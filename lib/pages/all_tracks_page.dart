import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:erosmic/models/track_info.dart';

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
      appBar: AppBar(title: Text("ALL TRACKS")),
      body: Consumer<TrackInfo>(
        builder: (context, trackInfo, child) {
          return ListView.builder(
            itemCount: trackInfo.tracks.length,
            itemBuilder: (context, index) {
              final track = trackInfo.tracks[index];
              return ListTile(
                title: Text(track.title),
                subtitle: Text(track.artist),
              );
            },
          );
        },

        // miniplayer
        child: const Align(alignment: AlignmentGeometry.bottomCenter),
      ),
    );
  }
}
