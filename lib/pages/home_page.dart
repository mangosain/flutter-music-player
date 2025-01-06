import 'package:flutter/material.dart';
import 'package:music/components/my_drawer.dart';
import 'package:music/model/playlist_provider.dart';
import 'package:music/model/song.dart';
import 'package:music/pages/song_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final dynamic playlistProvider;

  @override
  void initState() {
    super.initState();
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  void goToSong(int songIndex) {
    playlistProvider.currentSongIndex = songIndex;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SongPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text('P L A Y L I S T'),
      ),
      drawer: const MyDrawer(),
      body: Consumer<PlaylistProvider>(
        builder: (context, value, child) {
          final List<Song> playlist = value.playlist;

          return ListView.builder(
            itemCount: playlist.length,
            itemBuilder: (context, index) {
              final Song song = playlist[index];

              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ListTile(
                  title: Text(song.songName),
                  subtitle: Text(song.artistName),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      song.albumArtImagePath,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.playlist_remove_outlined),
                    color: Theme.of(context).colorScheme.inversePrimary,
                    iconSize: 20,
                    onPressed: () {
                      playlistProvider.playlist.removeAt(index);
                      playlistProvider.notifyListeners();
                    },
                  ),
                  onTap: () => {goToSong(index)},
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        // add styling
        backgroundColor: Theme.of(context).colorScheme.primary,

        onPressed: () {
          // function to open a dialogue box with test input
          showDialog(
            context: context,
            builder: (context) {
              final TextEditingController songNameController =
                  TextEditingController();
              final TextEditingController artistNameController =
                  TextEditingController();
              final TextEditingController albumArtImagePathController =
                  TextEditingController();
              final TextEditingController audioPathController =
                  TextEditingController();

              return AlertDialog(
                title: const Text('Add Song'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: songNameController,
                      decoration: const InputDecoration(
                        labelText: 'Song Name',
                      ),
                    ),
                    TextField(
                      controller: artistNameController,
                      decoration: const InputDecoration(
                        labelText: 'Artist Name',
                      ),
                    ),
                    TextField(
                      controller: albumArtImagePathController,
                      decoration: const InputDecoration(
                        labelText: 'Album Art Image Path',
                      ),
                    ),
                    TextField(
                      controller: audioPathController,
                      decoration: const InputDecoration(
                        labelText: 'Audio Path',
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      final Song newSong = Song(
                        songName: songNameController.text,
                        artistName: artistNameController.text,
                        albumArtImagePath: albumArtImagePathController.text,
                        audioPath: audioPathController.text,
                      );

                      playlistProvider.playlist.add(newSong);
                      Navigator.pop(context);
                      playlistProvider.notifyListeners();
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Add Song',
        child: Icon(Icons.add),
      ),
    );
  }
}
