// The purpose of song.dart is to allow the user to fetch
// music from both local and streaming files so the user can
// get the infromation needed.

// Enumerates values by parameters and returns it to the AudioScorceType
// which this is used to specify the source of the media.
enum AudioSourceType { local, stream }

// creates a method containing the infromation needed for this application
class Song {
  final String id; // final only allow variables to be set once
  final String title; // instead of using var, this helps with
  final String artist; // optimization and time-constraints
  final String album;
  final String genre;
  final Duration duration;
  final String? streamUrl; // used for Jellyfin
  final String? audioPath; // used for local files
  final String? albumArtUrl; // ? resolves the null state before running
  final AudioSourceType sourceType;

  Song({
    required this.id, // required requires the parameter as mandatory
    required this.title, // this makes the contructor non-null valued
    required this.artist, // meaning this can not be null.
    required this.album,
    required this.genre,
    required this.duration,
    required this.sourceType,
    this.streamUrl,
    this.audioPath,
    this.albumArtUrl,
  });

  // For Jellyfin API tracks
  // Factory creates an interface that reports on the type of created objects
  // meaning this creates a cached instance instead of constantly creating a
  // new instance.
  factory Song.fromJson(Map<String, dynamic> json) {
    // Json converts to Song object from using a dynamic value.
    return Song(
      id: json["id"],
      title: json["title"],
      artist: json["artist"],
      album: json["album"],
      genre: json["genre"],
      duration: Duration(seconds: json["duration"]),
      streamUrl: json["streamUrl"], // streaming URL source from Jellyfin
      albumArtUrl:
          json["albumArtUrl"], // uploading album art source from Jellyfin
      sourceType: AudioSourceType.stream,
    );
  }

  // For local files
  // Same premise for factory gets applied to local files as well.

  // fromLocal requires the certain information needed from source.
  // metagod
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
    // sends the local file onto Song object
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
