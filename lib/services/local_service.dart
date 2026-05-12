import 'dart:typed_data';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:erosmic/models/song.dart';

class LocalAudioService {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<List<Song>> fetchLocalSongs() async {
    final permitted = await _audioQuery.permissionsRequest();
    if (!permitted) return [];

    final List<SongModel> deviceSongs = await _audioQuery.querySongs(
      sortType: SongSortType.TITLE,
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

  Future<Uint8List?> fetchArtwork(int songId) async {
    return await _audioQuery.queryArtwork(
      songId,
      ArtworkType.AUDIO,
      quality: 100,
    );
  }
}
