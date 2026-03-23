class Song {
  final String id;
  final String title;
  final String artist;
  final Duration duration;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
  });

  @override
  String toString() {
    return 'Song(id: $id, title: $title, artist: $artist, duration: $duration)';
  }
}
