import 'package:w9/w9-firebase/model/artists/artist.dart';

abstract class ArtistRepository {
  Future<List<Artist>> fetchArtists();
}
