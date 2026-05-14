import 'dart:typed_data'; // used to handle data such as local artwork
import 'package:on_audio_query/on_audio_query.dart'; // provides information on songs (doesn't currently work)
import 'package:erosmic/models/song.dart';

class LocalAudioService {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<List<Song>> fetchLocalSongs() async {
    final permitted = await _audioQuery
        .permissionsRequest(); // request the user to provide access to the users media
    if (!permitted) return [];

    final List<SongModel> deviceSongs = await _audioQuery.querySongs(
      // puts the songs on the list
      sortType: SongSortType.TITLE, // once approved, this would
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    return deviceSongs
        .where((s) => s.isMusic ?? false)
        .map(
          (s) => Song.fromLocal(
            id: s.id.toString(),
            title: s.title,
            artist: s.artist ?? 'Unknown Artist',
            album: s.album ?? 'Unknown Album',
            genre: s.genre ?? 'Unknown Genre',
            duration: Duration(milliseconds: s.duration ?? 0),
            audioPath: s.data,
            albumArtUrl: null,
          ),
        )
        .toList();
  }

  // if the data provides artwork, then the user will be able to show the artwork up in the front
  Future<Uint8List?> fetchArtwork(int songId) async {
    return await _audioQuery.queryArtwork(
      songId,
      ArtworkType.AUDIO,
      quality: 100,
    );
  }
}
