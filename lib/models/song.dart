enum AudioSourceType { local, stream }

class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String genre;
  final Duration duration;
  final String? streamUrl; // used for Jellyfin
  final String? audioPath; // used for local files
  final String? albumArtUrl;
  final AudioSourceType sourceType;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.genre,
    required this.duration,
    required this.sourceType,
    this.streamUrl,
    this.audioPath,
    this.albumArtUrl,
  });

  // For Jellyfin API tracks
  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json["id"],
      title: json["title"],
      artist: json["artist"],
      album: json["album"],
      genre: json["genre"],
      duration: Duration(seconds: json["duration"]),
      streamUrl: json["streamUrl"],
      albumArtUrl: json["albumArtUrl"],
      sourceType: AudioSourceType.stream,
    );
  }

  // For local files
  factory Song.fromLocal({
    required String id,
    required String title,
    required String artist,
    required String album,
    required String genre,
    required Duration duration,
    required String audioPath,
    String? albumArtUrl,
  }) {
    return Song(
      id: id,
      title: title,
      artist: artist,
      album: album,
      genre: genre,
      duration: duration,
      audioPath: audioPath,
      albumArtUrl: albumArtUrl,
      sourceType: AudioSourceType.local,
    );
  }
}
