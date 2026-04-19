import 'package:flutter/material.dart';
import 'package:erosmic/models/song.dart';

class TrackInfo extends ChangeNotifier {
  // This will be changed to use local files and api data in the future

  final List<Song> _tracks = [
    Song(
      title: "A320",
      artist: "Foo Fighters",
      album: "B Sides and Rarities",
      genre: "Alternative Rock",
      duration: Duration(minutes: 5, seconds: 45),
      audioPath: "audio/A320.mp3",
    ),
    Song(
      title: "Glass Table Girls",
      artist: "The Weeknd",
      album: "House of Balloons",
      genre: "R&B",
      duration: Duration(minutes: 6, seconds: 47),
      audioPath: "audio/Glass Table Girls.mp3",
    ),
    Song(
      title: "Home",
      artist: "Daughtry",
      album: "Daughtry",
      genre: "Alternative Rock",
      duration: Duration(minutes: 4, seconds: 15),
      audioPath: "audio/Home.mp3",
    ),
  ];

  // currently played tracks
  int _currentTrackIndex = 0;

  // Method to change the current track

  List<Song> get tracks => _tracks;
  int get currentTrackIndex => _currentTrackIndex;
}
