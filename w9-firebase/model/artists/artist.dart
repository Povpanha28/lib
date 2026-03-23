class Artist {
  final String id;
  final String genre;
  final Uri imageUrl;
  final String name;

  Artist({
    required this.id,
    required this.genre,
    required this.imageUrl,
    required this.name,
  });

  @override
  String toString() {
    return 'Artist(id: $id, genre: $genre, imageUrl: ${imageUrl.toString()}, name: $name';
  }
}
