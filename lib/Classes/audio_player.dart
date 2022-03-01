import 'package:flutter/material.dart';
import 'package:music_player/Constants/music_data.dart';

class AudioPlayer with ChangeNotifier{
  bool playing = false;
  int currently_playing = 0;

  void toggle(){
    playing = !playing;
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