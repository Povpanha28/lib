import 'package:app/w9-firebase/model/artists/artist.dart';
import 'package:app/w9-firebase/ui/screens/artist/view_model/artist_view_model.dart';
import 'package:app/w9-firebase/ui/theme/theme.dart';
import 'package:app/w9-firebase/ui/utils/async_value.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArtistContent extends StatelessWidget {
  const ArtistContent({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ArtistViewModel>();
    AsyncValue<List<Artist>> asyncValue = vm.artistsValue;

    Widget content;

    switch (asyncValue.state) {
      case AsyncValueState.loading:
        content = Center(child: CircularProgressIndicator());
        break;
      case AsyncValueState.error:
        content = Center(
          child: Text(
            'error = ${asyncValue.error!}',
            style: TextStyle(color: Colors.red),
          ),
        );

      case AsyncValueState.success:
        List<Artist> artists = asyncValue.data!;
        content = ListView.builder(
          itemCount: artists.length,
          itemBuilder: (context, index) => ArtistTile(artist: artists[index]),
        );
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          Text("Artist", style: AppTextStyles.heading),
          SizedBox(height: 50),

          Expanded(child: content),
        ],
      ),
    );
  }
}

class ArtistTile extends StatelessWidget {
  final Artist artist;
  const ArtistTile({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(artist.imageUrl.toString()),
      ),
      title: Text(artist.name),
      subtitle: Text(artist.genre),
    );
  }
}
