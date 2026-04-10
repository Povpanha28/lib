import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  static const String _host =
      'w9-firebase-7eba2-default-rtdb.asia-southeast1.firebasedatabase.app';

  final Uri songsUri = Uri.https(_host, '/songs.json');
  List<Song>? _cachedSongs;

  @override
  Future<List<Song>> fetchSongs({bool forceFetch = false}) async {
    if (!forceFetch && _cachedSongs != null) {
      return _cachedSongs!;
    }

    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> songJson = json.decode(response.body);

      List<Song> result = [];
      for (final entry in songJson.entries) {
        result.add(SongDto.fromJson(entry.key, entry.value));
      }
      _cachedSongs = result;
      return result;
    } else {
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {
    if (_cachedSongs != null) {
      for (final song in _cachedSongs!) {
        if (song.id == id) {
          return song;
        }
      }
    }

    return _fetchSongByIdFromNetwork(id);
  }

  Future<Song?> _fetchSongByIdFromNetwork(String id) async {
    final Uri songUri = Uri.https(_host, '/songs/$id.json');
    final http.Response response = await http.get(songUri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load song with id $id');
    }

    final dynamic responseBody = json.decode(response.body);
    if (responseBody == null) {
      return null;
    }

    return SongDto.fromJson(id, responseBody as Map<String, dynamic>);
  }

  @override
  Future<Song> likeSong({
    required String songId,
    required int currentLikes,
  }) async {
    final Uri songUri = Uri.https(_host, '/songs/$songId.json');

    final http.Response response = await http.patch(
      songUri,
      body: json.encode({'likes': currentLikes + 1}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to like song with id $songId');
    }

    final Song? updatedSong = await _fetchSongByIdFromNetwork(songId);
    if (updatedSong == null) {
      throw Exception('Song with id $songId not found after like');
    }

    if (_cachedSongs != null) {
      final int songIndex = _cachedSongs!.indexWhere(
        (song) => song.id == songId,
      );
      if (songIndex >= 0) {
        _cachedSongs![songIndex] = updatedSong;
      }
    }

    return updatedSong;
  }
}
