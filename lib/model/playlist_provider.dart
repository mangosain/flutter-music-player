import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music/model/song.dart';

class PlaylistProvider extends ChangeNotifier {
  final List<Song> _playlist = [
    Song(
      songName: "Horizon Zero Dawn OST",
      artistName: "Joris De Man",
      albumArtImagePath: "assets/images/song1img.jpeg",
      audioPath: "audio/song1.mp3",
    ),
    Song(
      songName: "The Island",
      artistName: "Joris De Man",
      albumArtImagePath: "assets/images/song1img.jpeg",
      audioPath: "/audio/song1.mp3",
    ),
    Song(
      songName: "Five Years",
      artistName: "Joris De Man",
      albumArtImagePath: "assets/images/song1img.jpeg",
      audioPath: "/audio/song1.mp3",
    ),
    Song(
      songName: "Farewell",
      artistName: "Joris De Man",
      albumArtImagePath: "assets/images/song1img.jpeg",
      audioPath: "/audio/song1.mp3",
    ),
  ];

  int? _currentSongIndex;

  // A U D I O    P L A Y E R
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Duration
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // Constructor
  PlaylistProvider() {
    listenToDuration();
  }

  // initially not playing
  bool _isPlaying = false;

  // play song
  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  // pause song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // resume song
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // pause or resume song
  void pauseOrResume() {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  // seek to a particular position
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // skip to next song
  void skipToNext() {
    if (_currentSongIndex! < _playlist.length - 1) {
      currentSongIndex = _currentSongIndex! + 1;
    } else {
      currentSongIndex = 0;
    }
    play();
  }

  // skip to previous song
  void skipToPrevious() {
    if (_currentDuration.inSeconds > 5) {
      seek(Duration.zero);
    } else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  // listen to duration
  void listenToDuration() {
    // listen for total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    // listen for current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    // listen for song completion
    _audioPlayer.onPlayerComplete.listen((event) {
      skipToNext();
    });
  }

  // getters
  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play();
    }

    notifyListeners();
  }
}
