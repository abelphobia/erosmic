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
      audioPath: "assets/audio/A320.mp3",
    ),
    Song(
      title: "Glass Table Girls",
      artist: "The Weeknd",
      album: "House of Balloons",
      genre: "R&B",
      duration: Duration(minutes: 6, seconds: 47),
      audioPath: "assets/audio/Glass-Table-Girls.mp3",
    ),
    Song(
      title: "Home",
      artist: "Daughtry",
      album: "Daughtry",
      genre: "Alternative Rock",
      duration: Duration(minutes: 4, seconds: 15),
      audioPath: "assets/audio/Home.mp3",
    ),
    Song(
      title: "You Make Me Feel",
      artist: "Cobra Starship",
      album: "Hot Mess",
      genre: "Pop",
      duration: Duration(minutes: 3, seconds: 30),
      audioPath: "assets/audio/You-Make-Me-Feel.mp3",
    ),
    Song(
      title: "What You Need",
      artist: "The Weeknd",
      album: "House of Balloons",
      genre: "R&B",
      duration: Duration(minutes: 3, seconds: 26),
      audioPath: "assets/audio/What-You-Need.mp3",
    ),
    Song(
      title: "OMG",
      artist: "Usher",
      album: "Raymond v Raymond",
      genre: "R&B",
      duration: Duration(minutes: 4, seconds: 29),
      audioPath: "assets/audio/OMG.mp3",
    ),
    Song(
      title: "Fragments Of Time",
      artist: "Daft Punk",
      album: "Random Access Memories",
      genre: "Electronic",
      duration: Duration(minutes: 3, seconds: 54),
      audioPath: "assets/audio/Fragments-Of-Time.mp3",
    ),
  ];

  // currently played tracks
  final int _currentTrackIndex = 0;

  // Method to change the current track

  List<Song> get tracks => _tracks;
  int get currentTrackIndex => _currentTrackIndex;
}
