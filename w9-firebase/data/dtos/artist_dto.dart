import 'package:app/w9-firebase/model/artists/artist.dart';

class ArtistDto {
  static const nameKey = "name";
  static const imageUrlKey = "imageUrl";
  static const genreKey = "genre";

  static Artist fromJson(Map<String, dynamic> json, String id) {
    assert(json[genreKey] is String);
    assert(json[imageUrlKey] is String);
    assert(json[nameKey] is String);

    return Artist(
      id: id,
      genre: json[genreKey],
      imageUrl: Uri.parse(json[imageUrlKey]),
      name: json[nameKey],
    );
  }
}
