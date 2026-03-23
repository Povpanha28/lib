import 'package:app/w9-firebase/model/artists/artist.dart';

abstract class ArtistRepository {
  Future<List<Artist>> fetchArtists();
}
