import 'dart:convert';

import 'package:w9/w9-firebase/data/dtos/artist_dto.dart';
import 'package:w9/w9-firebase/data/repositories/artists/artist_repository.dart';
import 'package:w9/w9-firebase/model/artists/artist.dart';
import 'package:http/http.dart' as http;

class ArtistRepositoryFirebase implements ArtistRepository {
  final Uri artistUri = Uri.https(
    'w9-firebase-7eba2-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/artists.json',
  );
  @override
  Future<List<Artist>> fetchArtists() async {
    final http.Response response = await http.get(artistUri);

    List<Artist> result = [];
    if (response.statusCode == 200) {
      Map<String, dynamic> artistJson = json.decode(response.body);

      for (var i in artistJson.entries) {
        String id = i.key;
        Map<String, dynamic> value = i.value;

        final artist = ArtistDto.fromJson(value, id);
        result.add(artist);
      }

      return result;
    } else {
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load posts');
    }
  }
}
