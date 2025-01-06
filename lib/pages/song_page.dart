import 'package:flutter/material.dart';

import 'package:music/components/neu_box.dart';
import 'package:music/model/playlist_provider.dart';

import 'package:provider/provider.dart';

class SongPage extends StatelessWidget {
  const SongPage({super.key});

  // convert duration to string
  String formatTime(Duration duration) {
    String twoDigitSeconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    String formattedTime = "${duration.inMinutes}:$twoDigitSeconds";

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, value, child) {
        final playlist = value.playlist;

        final currentSong = playlist[value.currentSongIndex ?? 0];

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Text('P L A Y I N G'),
                      IconButton(
                        icon: const Icon(Icons.more_horiz_rounded),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // album art

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade800,
                          offset: const Offset(5, 5),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(currentSong.albumArtImagePath,
                          width: 300, height: 300),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: NeuBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Column to hold the song and artist name
                          Expanded(
                            // This will give the text room to expand
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentSong.songName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text(
                                  currentSong.artistName,
                                ),
                              ],
                            ),
                          ),

                          // Icon Button for favorite
                          IconButton(
                            icon: const Icon(Icons.favorite),
                            color: Colors.red,
                            iconSize: 30,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formatTime(value.currentDuration)),
                            Text(formatTime(value.totalDuration)),
                          ],
                        ),

                        // seek bar
                        SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 2,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 2,
                            ),
                          ),
                          child: Slider(
                            min: 0.0,
                            max: value.totalDuration.inSeconds.toDouble(),
                            value: value.currentDuration.inSeconds.toDouble(),
                            activeColor: Colors.green,
                            inactiveColor: Colors.white,
                            onChanged: (double double) {},
                            onChangeEnd: (double double) => {
                              value.seek(
                                Duration(
                                  seconds: double.toInt(),
                                ),
                              ),
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // player controls
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              value.skipToPrevious();
                            },
                            child: const NeuBox(
                              child: Icon(Icons.skip_previous_rounded),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              value.pauseOrResume();
                            },
                            child: NeuBox(
                              child: Icon(value.isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              value.skipToNext();
                            },
                            child: const NeuBox(
                              child: Icon(Icons.skip_next_rounded),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shuffle),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.playlist_add,
                          ),
                          onPressed: () => {},
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.cast_rounded,
                          ),
                          onPressed: () => {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.repeat),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
