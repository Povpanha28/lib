// song_repository_mock.dart

import '../../../model/songs/song.dart';
import 'song_repository.dart';

class SongRepositoryMock implements SongRepository {
  final List<Song> _songs = [];
  List<Song>? _cachedSongs;

  @override
  Future<List<Song>> fetchSongs({bool forceFetch = false}) async {
    if (!forceFetch && _cachedSongs != null) {
      return _cachedSongs!;
    }

    return Future.delayed(Duration(seconds: 1), () {
      _cachedSongs = List<Song>.from(_songs);
      return _cachedSongs!;
    });
  }

  @override
  Future<Song?> fetchSongById(String id) async {
    return Future.delayed(Duration(seconds: 4), () {
      return _songs.firstWhere(
        (song) => song.id == id,
        orElse: () => throw Exception("No song with id $id in the database"),
      );
    });
  }

  @override
  Future<Song> likeSong({
    required String songId,
    required int currentLikes,
  }) async {
    return Future.delayed(Duration(milliseconds: 200), () {
      final int index = _songs.indexWhere((song) => song.id == songId);
      if (index < 0) {
        throw Exception("No song with id $songId in the database");
      }

      final Song song = _songs[index];
      final Song updatedSong = Song(
        id: song.id,
        title: song.title,
        artistId: song.artistId,
        duration: song.duration,
        imageUrl: song.imageUrl,
        likes: currentLikes + 1,
      );

      _songs[index] = updatedSong;
      return updatedSong;
    });
  }
}
