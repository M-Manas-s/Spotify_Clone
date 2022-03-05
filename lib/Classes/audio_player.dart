import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/Constants/music_data.dart';

class AudioPlayerProvider with ChangeNotifier{
  bool playing = false;
  int currently_playing = 0;
  final AudioPlayer _player = AudioPlayer();

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
  }

  Future<void> playCurrent() async {
    _player.setAsset('Assets/Audio/'+tracks[currently_playing].path);
    _player.play();
  }

  void toggle(){
    playing = !playing;
    log(playing.toString());
    if ( playing ) playCurrent();
    notifyListeners();
  }

  void changePlaying(bool increase){
    if ( increase ) {
      currently_playing = (1 + currently_playing)%(tracks.length);
    } else {
      currently_playing = (currently_playing-1+tracks.length)%(tracks.length);
    }
    notifyListeners();
  }
}