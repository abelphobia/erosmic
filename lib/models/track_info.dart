import 'package:flutter/material.dart';
import 'package:erosmic/models/song.dart';
import 'package:erosmic/services/jellyfin_service.dart';
import 'package:erosmic/services/local_service.dart';
import 'package:file_picker/file_picker.dart';

// This manages all track's data. It fetches from both Jellyfin and local device, and merges them into a single list.
class TrackInfo extends ChangeNotifier {
  // extends allows to create a subclass that uses ChangeNotifier's to notify users when the data changes.
  final JellyfinService _service = JellyfinService();
  final LocalAudioService _localService = LocalAudioService();

  // Creates the main list of each category then creates getters to access the media.
  List<Song> _tracks = [];
  List<String> _genres = [];
  List<Map<String, String>> _albums = [];
  bool isLoading = false;
  String?
  error; // ? means that the string can be null when handling error messages.
  int _currentTrackIndex =
      0; // Tracks the index of each song that is currently playing.

  // This part is the getters for each category, allowing the app to access the data provided.
  List<Song> get tracks => _tracks;
  List<String> get genres => _genres;
  List<Map<String, String>> get albums =>
      _albums; // gets the list of albums by mapping each album to its respected name and id.
  int get currentTrackIndex =>
      _currentTrackIndex; // gets the index of the song that is currently playing.

  // After getting the list of tracks, then the lists get filtered by each source type, being local or stream.
  List<Song> get localTracks =>
      _tracks.where((t) => t.sourceType == AudioSourceType.local).toList();

  List<Song> get streamTracks =>
      _tracks.where((t) => t.sourceType == AudioSourceType.stream).toList();

  // Once sorted, the playSong function allows the user to play the song by its index.
  void playSong(int index) {
    _currentTrackIndex = index;
    notifyListeners(); // notifyListeners() allows the app to notify the user when something changes on the app.
  }

  // using async functions allows the the data to be fetched and place on standby once the function finishes executing, ensuring that the data is loaded.
  Future<void> fetchAll() async {
    isLoading = true;
    error = null;
    notifyListeners();

    // Future.wait allows the app to wait for all the data to be fetched before being sent to _service
    try {
      final results = await Future.wait([
        _service
            .fetchTracks(), // _service is a service for both jellyfin and local services
        _service.fetchGenres(),
        _service.fetchAlbums(),
      ]);

      _tracks =
          results[0]
              as List<
                Song
              >; // creates the list of tracks first, then genres, then albums.
      _genres = results[1] as List<String>;
      _albums =
          results[2]
              as List<
                Map<String, String>
              >; // albums are stored as a list that contains the id and name of the albums.

      if (_tracks.isNotEmpty) {
        debugPrint(
          "Uploading Stream URL: ${tracks.first.streamUrl}",
        ); // This is used for debugging to ensure that the tracks are working properly.
      }
    } catch (e) {
      // catch e indicates to catch any error and put the error onto a string to be displayed on the app.
      error = e.toString();
    }

    isLoading = false; // if the data is not loading the
    notifyListeners();
  }

  // Loads ALL local device songs via on_audio_query (full metadata)
  Future<void> loadLocalTracks() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final localSongs = await _localService.fetchLocalSongs();

      for (final track in localSongs) {
        if (!_tracks.any((t) => t.audioPath == track.audioPath)) {
          _tracks.add(track);
        }
      }
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  // Fallback: manual file picker (used if user wants to pick specific files)
  Future<void> pickLocalFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
      );

      if (result == null || result.files.isEmpty) return;

      final newLocalTracks = result.files
          .where((file) => file.path != null)
          .map(
            (file) => Song.fromLocal(
              id: file.identifier ?? file.path!,
              title: _cleanFileName(file.name),
              artist: 'Unknown Artist',
              album: 'Unknown Album',
              genre: 'Unknown Genre',
              duration: Duration.zero,
              audioPath: file.path!,
            ),
          )
          .toList();

      for (final track in newLocalTracks) {
        if (!_tracks.any((t) => t.audioPath == track.audioPath)) {
          _tracks.add(track);
        }
      }

      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  String _cleanFileName(String fileName) {
    return fileName.contains('.')
        ? fileName.substring(0, fileName.lastIndexOf('.'))
        : fileName;
  }
}
