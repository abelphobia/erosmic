import 'package:flutter/material.dart';
import 'package:erosmic/models/song.dart';
import 'package:erosmic/services/jellyfin_service.dart';
import 'package:file_picker/file_picker.dart';

class TrackInfo extends ChangeNotifier {
  final JellyfinService _service = JellyfinService();

  List<Song> _tracks = [];
  List<String> _genres = [];
  List<Map<String, String>> _albums = [];
  bool isLoading = false;
  String? error;
  int _currentTrackIndex = 0;

  List<Song> get tracks => _tracks;
  List<String> get genres => _genres;
  List<Map<String, String>> get albums => _albums;
  int get currentTrackIndex => _currentTrackIndex;

  List<Song> get localTracks =>
      _tracks.where((t) => t.sourceType == AudioSourceType.local).toList();

  List<Song> get streamTracks =>
      _tracks.where((t) => t.sourceType == AudioSourceType.stream).toList();

  // ← now correctly outside fetchAll
  void playSong(int index) {
    _currentTrackIndex = index;
    notifyListeners();
  }

  Future<void> fetchAll() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.fetchTracks(),
        _service.fetchGenres(),
        _service.fetchAlbums(),
      ]);

      _tracks = results[0] as List<Song>;
      _genres = results[1] as List<String>;
      _albums = results[2] as List<Map<String, String>>;
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

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
              artist: "Unknown",
              album: "Unknown",
              genre: "Unknown",
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
