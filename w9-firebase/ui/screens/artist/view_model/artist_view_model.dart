import 'package:w9/w9-firebase/data/repositories/artists/artist_repository.dart';
import 'package:w9/w9-firebase/model/artists/artist.dart';
import 'package:w9/w9-firebase/ui/utils/async_value.dart';
import 'package:flutter/material.dart';

class ArtistViewModel extends ChangeNotifier {
  ArtistRepository artistRepository;

  AsyncValue<List<Artist>> artistsValue = AsyncValue.loading();

  ArtistViewModel({required this.artistRepository}) {
    // init
    _init();
  }

  void _init() async {
    fetchArtists();
  }

  void fetchArtists() async {
    // 1 - loading data
    artistsValue = AsyncValue.loading();
    notifyListeners();
    try {
      // 2- Fetch is successfull
      List<Artist> artists = await artistRepository.fetchArtists();
      artistsValue = AsyncValue.success(artists);
    } catch (e) {
      // if error 
      artistsValue = AsyncValue.error(e);
    }
    notifyListeners();
  }
}
