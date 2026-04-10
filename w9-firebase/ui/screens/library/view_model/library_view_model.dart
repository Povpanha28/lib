import 'package:flutter/material.dart';
import 'package:w9/w9-firebase/data/repositories/artists/artist_repository.dart';
import 'package:w9/w9-firebase/model/artists/artist.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';
import '../../../utils/async_value.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final ArtistRepository artistRepository;
  final PlayerState playerState;

  AsyncValue<List<Map<String, dynamic>>> songsValue = AsyncValue.loading();

  LibraryViewModel({
    required this.songRepository,
    required this.playerState,
    required this.artistRepository,
  }) {
    playerState.addListener(notifyListeners);

    // init
    _init();
  }

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    fetchSong();
  }

  // List<Map<String, dynamic>> joinSongsWithArtists(
  //   List<Song> songs,
  //   List<Artist> artists,
  // ) {
  //   final artistMap = {for (var artist in artists) artist.id: artist};

  //   return songs.map((song) {
  //     final artist = artistMap[song.artistId];

  //     return {'song': song, 'artist': artist};
  //   }).toList();
  // }

  // easier to understand
  List<Map<String, dynamic>> joinSongsWithArtists(
    List<Song> songs,
    List<Artist> artists,
  ) {
    
    List<Map<String, dynamic>> result = [];

    for (var song in songs) {
      // find matching artist using firstWhere
      Artist? foundArtist = artists.firstWhere(
        (artist) => artist.id == song.artistId,
      );

      result.add({'song': song, 'artist': foundArtist});
    }

    return result;
  }

  void fetchSong() async {
    // 1- Loading state
    songsValue = AsyncValue.loading();
    notifyListeners();

    try {
      // 2- Fetch is successfull
      List<Song> songs = await songRepository.fetchSongs();
      List<Artist> artists = await artistRepository.fetchArtists();

      final songWithArtist = joinSongsWithArtists(songs, artists);

      songsValue = AsyncValue.success(songWithArtist);
    } catch (e) {
      // 3- Fetch is unsucessfull
      songsValue = AsyncValue.error(e);
    }
    notifyListeners();
  }

  bool isSongPlaying(Song song) => playerState.currentSong == song;

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();
}
