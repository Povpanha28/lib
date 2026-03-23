    import '../../model/songs/song.dart';

class SongDto {
  static const String idKey = 'id';
  static const String titleKey = 'name';
  static const String artistKey = 'artists';
  static const String durationKey = 'durationMs';   // in ms

  static Song fromJson(Map<String, dynamic> json) {
    assert(json[idKey] is String);
    assert(json[titleKey] is String);
    assert(json[artistKey] is String);
    assert(json[durationKey] is int);

    return Song(
      id: json[idKey],
      title: json[titleKey],
      artist: json[artistKey],
      duration: Duration(milliseconds: json[durationKey]),
    );
  }

  /// Convert Song to JSON
  Map<String, dynamic> toJson(Song song) {
    return {
      idKey: song.id,
      titleKey: song.title,
      artistKey: song.artist,
      durationKey: song.duration.inMilliseconds,
    };
  }
}
