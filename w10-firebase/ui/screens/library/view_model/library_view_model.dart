import 'package:flutter/material.dart';
import '../../../../data/repositories/artist/artist_repository.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../../model/artist/artist.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';
import '../../../utils/async_value.dart';
import 'library_item_data.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final ArtistRepository artistRepository;

  final PlayerState playerState;

  AsyncValue<List<LibraryItemData>> asyncValue = AsyncValue.loading();
  final Set<String> _likingSongIds = <String>{};

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

  Future<void> fetchSong({bool forceFetch = false}) async {
    // 1- Loading state
    asyncValue = AsyncValue.loading();
    notifyListeners();

    try {
      // 1- Fetch songs
      List<Song> songs = await songRepository.fetchSongs(
        forceFetch: forceFetch,
      );

      // 2- Fethc artist
      List<Artist> artists = await artistRepository.fetchArtists(
        forceFetch: forceFetch,
      );

      // 3- Create the mapping artistid-> artist
      Map<String, Artist> mapArtist = {};
      for (Artist artist in artists) {
        mapArtist[artist.id] = artist;
      }

      List<LibraryItemData> data = songs
          .map(
            (song) =>
                LibraryItemData(song: song, artist: mapArtist[song.artistId]!),
          )
          .toList();

      asyncValue = AsyncValue.success(data);
    } catch (e) {
      // 3- Fetch is unsucessfull
      asyncValue = AsyncValue.error(e);
    }
    notifyListeners();
  }

  bool isSongPlaying(Song song) => playerState.currentSong == song;

  bool isLikingSong(String songId) => _likingSongIds.contains(songId);

  Future<void> likeSong(Song song) async {
    if (isLikingSong(song.id) || asyncValue.state != AsyncValueState.success) {
      return;
    }

    final int previousLikes = song.likes;

    _likingSongIds.add(song.id);
    _updateSongLikesLocally(song.id, previousLikes + 1);
    notifyListeners();

    try {
      final Song updatedSong = await songRepository.likeSong(
        songId: song.id,
        currentLikes: previousLikes,
      );
      _replaceSongLocally(updatedSong);
    } catch (error) {
      _updateSongLikesLocally(song.id, previousLikes);
    } finally {
      _likingSongIds.remove(song.id);
      notifyListeners();
    }
  }

  void _replaceSongLocally(Song updatedSong) {
    if (asyncValue.state != AsyncValueState.success ||
        asyncValue.data == null) {
      return;
    }

    final List<LibraryItemData> currentData = asyncValue.data!;
    final List<LibraryItemData> updatedData = currentData.map((item) {
      if (item.song.id != updatedSong.id) {
        return item;
      }
      return LibraryItemData(song: updatedSong, artist: item.artist);
    }).toList();

    asyncValue = AsyncValue.success(updatedData);
  }

  void _updateSongLikesLocally(String songId, int likes) {
    if (asyncValue.state != AsyncValueState.success ||
        asyncValue.data == null) {
      return;
    }

    final List<LibraryItemData> currentData = asyncValue.data!;
    final List<LibraryItemData> updatedData = currentData.map((item) {
      if (item.song.id != songId) {
        return item;
      }

      final Song song = item.song;
      final Song updatedSong = Song(
        id: song.id,
        title: song.title,
        artistId: song.artistId,
        duration: song.duration,
        imageUrl: song.imageUrl,
        likes: likes,
      );

      return LibraryItemData(song: updatedSong, artist: item.artist);
    }).toList();

    asyncValue = AsyncValue.success(updatedData);
  }

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();
}
