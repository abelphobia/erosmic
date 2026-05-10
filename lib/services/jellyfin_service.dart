import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:erosmic/models/song.dart';
import 'package:erosmic/config/api_config.dart';

class JellyfinService {
  final String _base = ApiConfig.baseUrl;

  Future<List<Song>> fetchTracks() async {
    final response = await http.get(Uri.parse("$_base/tracks"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((j) => Song.fromJson(j)).toList();
    }
    throw Exception("Failed to fetch tracks");
  }

  Future<List<String>> fetchGenres() async {
    final response = await http.get(Uri.parse("$_base/genres"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((g) => g.toString()).toList();
    }
    throw Exception("Failed to fetch genres");
  }

  Future<List<Map<String, String>>> fetchAlbums() async {
    final response = await http.get(Uri.parse("$_base/albums"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((a) => {"id": a["id"].toString(), "name": a["name"].toString()})
          .toList();
    }
    throw Exception("Failed to fetch albums");
  }
}
