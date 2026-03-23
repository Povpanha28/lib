import 'package:app/w9-firebase/data/repositories/artists/artist_repository.dart';
import 'package:app/w9-firebase/ui/screens/artist/view_model/artist_view_model.dart';
import 'package:app/w9-firebase/ui/screens/artist/widgets/artist_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArtistScreen extends StatelessWidget {
  const ArtistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ArtistRepository artistRepo = context.read<ArtistRepository>();
    return ChangeNotifierProvider(
      create: (context) => ArtistViewModel(artistRepository: artistRepo),
      child: ArtistContent(),
    );
  }
}
