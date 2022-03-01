
import 'package:flutter/cupertino.dart';

class Music{
    String audio = "A";
    final String name;
    final String album;
    final String artist;
    final String image;
    final int duration;
    Alignment albumAlign;

    Music({audio, required this.name, required this.album, required this.artist, required this.image, required this.duration, this.albumAlign = const Alignment(1,1)});

}