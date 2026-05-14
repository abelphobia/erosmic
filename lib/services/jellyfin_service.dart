import 'dart:convert'; // Data conversion used to handle JSON parsing
import 'package:http/http.dart' as http; // Provides HHTP requests
import 'package:erosmic/models/song.dart';
import 'package:erosmic/config/api_config.dart'; // connects the server to the app

class JellyfinService {
  final String _base =
      ApiConfig.baseUrl; // finalizes apiconfig to connect to app

  // Track fetching
  Future<List<Song>> fetchTracks() async {
    // fetches tracks asynchronously
    final response = await http.get(
      Uri.parse("$_base/tracks"),
    ); // imports the http package and breaks down the responses to verify if the tracks were recieved correctly
    if (response.statusCode == 200) {
      // response code 200 is good good good
      final List<dynamic> data = jsonDecode(
        response.body,
      ); // requests the JSON string to convert to the map and send it to the list.
      return data
          .map((j) => Song.fromJson(j))
          .toList(); // sends the list to song.dart using JSON
    }
    throw Exception(
      "Failed to fetch tracks",
    ); // This will throw an error code on the FastAPI Swagger UI page
  }

  // Genre fetching
  Future<List<String>> fetchGenres() async {
    final response = await http.get(Uri.parse("$_base/genres"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((g) => g.toString())
          .toList(); // directs the information to the string list on song.dart
    }
    throw Exception("Failed to fetch genres");
  }

  // Album fetching
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
